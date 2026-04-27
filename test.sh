#!/bin/bash
set -e

# Setup a temporary directory for the test repository
TEST_DIR=$(mktemp -d)
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
  echo "Output was: $OG_OUTPUT"
  exit 1
fi

# 3. Test git-recent
# Setting GIT_RECENT_QUERY="x" uses fzf --filter="x" which is non-interactive.
# git-recent logic: if fzf returns exactly one line (line_count == 0 due to printf/wc behavior), it checks it out.
echo "Testing git-recent..."
export GIT_RECENT_QUERY="x"
$GIT_RECENT > /dev/null 2>&1

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" == "feature-x-branch" ]; then
  echo "✅ git-recent correctly checked out 'feature-x-branch'."
else
  echo "❌ git-recent failed to check out expected branch."
  echo "Current branch is: $CURRENT_BRANCH"
  exit 1
fi

echo "All tests passed! 🎉"
