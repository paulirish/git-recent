#!/bin/bash
set -e

# Setup a temporary directory for the test repository
TEST_DIR=$(mktemp -d)
BIN_DIR="$TEST_DIR/bin"
mkdir -p "$BIN_DIR"
trap 'rm -rf "$TEST_DIR"' EXIT

# Absolute paths to the scripts in the current directory
GIT_RECENT="$(pwd)/git-recent"
GIT_RECENT_OG="$(pwd)/git-recent-og"

echo "Running tests in $TEST_DIR"
cd "$TEST_DIR"

# 1. Initialize repository and commits
git init --initial-branch=main
git config user.name "BrewTestBot"
git config user.email "brew@test.bot"

# Setup dummy remote to satisfy git symbolic-ref refs/remotes/origin/HEAD
git remote add origin https://example.com/repo.git
mkdir -p .git/refs/remotes/origin
echo "ref: refs/remotes/origin/main" > .git/refs/remotes/origin/HEAD

git commit --allow-empty -m "test_commit"
git checkout -b "feature-x-branch"
git commit --allow-empty -m "commit on feature branch"
git checkout -b "another-branch"
git commit --allow-empty -m "commit on another branch"
git checkout main

# 2. Test git-recent-og
echo "Testing git-recent-og..."
OG_OUTPUT=$($GIT_RECENT_OG)
if echo "$OG_OUTPUT" | grep -q "main" && echo "$OG_OUTPUT" | grep -q "BrewTestBot" && echo "$OG_OUTPUT" | grep -q "test_commit"; then
  echo "✅ git-recent-og output matches expected pattern."
else
  echo "❌ git-recent-og output mismatch."
  exit 1
fi

# 3. Test git-recent basic checkout
echo "Testing git-recent basic checkout..."
export GIT_RECENT_QUERY="feature-x"
$GIT_RECENT > /dev/null 2>&1
[ "$(git rev-parse --abbrev-ref HEAD)" == "feature-x-branch" ] && echo "✅ git-recent checkout passed." || exit 1

# 4. Regression: Gerrit Link Generation (via git config)
echo "Testing Gerrit link generation (via git config)..."
git config "branch.feature-x-branch.gerritissue" "1234"
git config "gerrit.host" "chromium-review.googlesource.com"
git config "gerrit.project" "devtools/devtools-frontend"
git checkout main > /dev/null 2>&1

export GIT_RECENT_QUERY="feature-x"
export GIT_RECENT_TEST_NO_CHECKOUT="true"
export TERM="dumb"
# We use fzf --filter which outputs the matching line
# We capture both stdout and stderr to be safe
OUTPUT=$($GIT_RECENT --cl 2>&1)
# We check if the number and the URL fragment are present. 
# Terminal escape codes for hyperlinks can make exact string matching tricky in bash.
if echo "$OUTPUT" | grep -q "1234" && echo "$OUTPUT" | grep -q "chromium-review.googlesource.com" && echo "$OUTPUT" | grep -q "devtools-frontend"; then
  echo "✅ Gerrit link correctly generated from config."
else
  echo "❌ Gerrit link mismatch."
  echo "Output was: $OUTPUT"
  exit 1
fi

# 5. Regression: GitHub PR Link Generation (via gh mock)
echo "Testing GitHub PR link generation (via mock gh)..."
# Create a mock gh command
cat > "$BIN_DIR/gh" <<EOF
#!/bin/bash
if [[ "\$*" == *"pr list"* ]]; then
  echo "feature-x-branch : https://github.com/paulirish/git-recent/pull/99 99"
fi
EOF
chmod +x "$BIN_DIR/gh"
export PATH="$BIN_DIR:$PATH"

# Set a github remote to trigger github logic
git remote add origin-github https://github.com/paulirish/git-recent.git
# Remove gerrit configs to avoid gerrit matching first
git config --unset "branch.feature-x-branch.gerritissue"
git config --remove-section gerrit 2>/dev/null || true

export GIT_RECENT_QUERY="feature-x"
OUTPUT=$($GIT_RECENT --pr 2>&1)
if echo "$OUTPUT" | grep -q "#99" && echo "$OUTPUT" | grep -q "github.com/paulirish/git-recent/pull/99"; then
  echo "✅ GitHub PR link correctly generated from gh."
else
  echo "❌ GitHub PR link mismatch."
  echo "Output was: $OUTPUT"
  exit 1
fi

# 6. Regression: Priority Detection (GitHub over Gerrit false positive)
echo "Testing Repo Priority (GitHub over Gerrit false positive)..."
# Mock git-cl to return 0 but No issue assigned (the false positive case)
cat > "$BIN_DIR/git-cl" <<EOF
#!/bin/bash
echo "No issue assigned."
exit 0
EOF
chmod +x "$BIN_DIR/git-cl"

# With both a github remote and git-cl present, it should still pick GitHub
OUTPUT=$($GIT_RECENT --cl 2>&1)
if echo "$OUTPUT" | grep -q "#99"; then
  echo "✅ GitHub prioritized over git-cl false positive."
else
  echo "❌ Repo detection failed to prioritize GitHub."
  echo "Output was: $OUTPUT"
  exit 1
fi

echo "All regression tests passed! 🎉"
