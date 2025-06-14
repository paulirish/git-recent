class GitRecent < Formula
  desc "See your latest local git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ab9c3f5da92747f7b53f1a301b22433116ee8d204562cc8f0364f70f4a79d318"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3a4143920243a863447daa6f2b17b3cda4e0a163e8502c6c36a910eee4ee7450"
  end

  depends_on "fzf"

  depends_on macos: :sierra

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-plus", because: "both install `git-recent` binaries"

  def install
    bin.install "git-recent"
    bin.install "git-recent-og"
  end

  test do
    system "git", "init", "--initial-branch=main"
    # User will be 'BrewTestBot' on CI, needs to be set here to work locally
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    system "git", "commit", "--allow-empty", "-m", "initial commit"

    # Create a branch that we will later select.
    system "git", "checkout", "-b", "feature-x-branch"
    system "git", "commit", "--allow-empty", "-m", "commit on feature branch"

    # Create another branch to ensure fzf has multiple choices.
    system "git", "checkout", "-b", "another-branch"
    system "git", "commit", "--allow-empty", "-m", "commit on another branch"
    system "git", "checkout", "main"

    # This should select "feature-x-branch" and the script will check it out.
    output = with_env "GIT_RECENT_QUERY" => "x" do
      shell_output("#{bin}/git-recent")
    end

    # The important result is that the current branch has been changed.
    # We verify this by asking git for the current branch name.
    assert_equal "feature-x-branch", shell_output("git rev-parse --abbrev-ref HEAD").strip
  end
end
