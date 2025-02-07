# git recent

Speedily browse your latest local git branches, `checkout` with Enter. Also view  branches unique commits, and optionally the diff against main.

[Demo video of git recent 2.0](https://github.com/user-attachments/assets/441f0b9b-8469-41bd-a826-0bb0cd7c7de8)

`git recent` now offers an interactive UI (thx to [fzf](https://github.com/junegunn/fzf)) for browsing recent branches, seeing differences, and `checkout`'ing your selection.

See a diff of your branch vs main with `ctrl-o`. If you have [delta](https://dandavison.github.io/delta//) it'll use that for formatting, but will fallback, too.

If you're like me, mostly using classic git commands, then `git recent` provides a nice upgrade for browsing/selecting recent branches. But if you're a TUI fan using [git-fuzzy](https://github.com/bigH/git-fuzzy), [`lazygit`](https://github.com/jesseduffield/lazygit) or [`tig`](https://jonas.github.io/tig/) or [`fzf-git`](https://github.com/junegunn/fzf-git.sh), well… this probably isn't an upgrade. :p  (But you can certainly [read the source](/git-recent) quickly!)


### Installation

`fzf` is required for 2.0. TBH, it's a fantastic tool; those [shell key bindings](https://junegunn.github.io/fzf/shell-integration/) are _delightful_. That said, if you're dependency-averse, the older version below, [`git recent-og`](#git-recent-og), may be for you.

* Mac: `brew install fzf`
* Linux: `sudo apt-get install fzf`
* Windows: `choco install fzf`

Then, do one of these:

* Manual: Grab the `git-recent` script from this repo and put it anywhere in your `$PATH`. Run `chmod +x git-recent`.
* Via NPM: `npm install --global git-recent`
* ~Homebrew: `brew install git-recent`~ _(Coming soon! Updated for 2.0)_

### Usage

    git recent

Hit `Enter` to checkout the selected branch.

Type or use arrow keys to navigate your list of branches.

Hit `ctrl-o` to see the branch diff.

--------------------------------

# `git recent-og`

`git recent-og` is the [OG](https://www.urbandictionary.com/define.php?term=OG) `git recent`, released back in 2016. Now it's been renamed to `git recent-og`.

    git recent-og

Optionally, add `-n<int>` to see the most recent `<n>` branches

    git recent-og -n5

![git-recent-og screenshot](https://cloud.githubusercontent.com/assets/39191/17446638/039d4cee-5aff-11e6-9e11-4294f0020513.png)

If you're a Windows user, you need to use [Git Bash](https://git-scm.com/downloads) or similar shell in order to effectively use this utility.

### Installation

You can add the `git-recent` location to your path (e.g. add the directory to your `PATH` environment
or copy `git-recent` into an existing included path like `/usr/local/bin` or `~/bin/`).

You can use also `npm` to install the global binary:

    npm install --global git-recent

On Mac, you can install with homebrew:

    brew install git-recent

----------

## If you like this you may also be interested in...

- [`git open`](https://github.com/paulirish/git-open) - Open the repo website in your browser
- [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy/) - Making the output of `git diff` so fancy

## License

Copyright Paul Irish. Licensed under MIT.

## Changelog

- **2025-02** - 2.0 upgrade with fzf integration. 1.0 binary is now available as `git recent-og`.
- **2019-06** - Last bugfix for 1.0 landed. Been stable since then.
- **2018-10** - Added count `-n` parameter
- **2016-08** - released in standalone repo and published to npm
- **2016-05** - added to [paulirish/dotfiles](https://github.com/paulirish/dotfiles/commit/1ca1ff760832af558447145fa2a367046b1829d2)
