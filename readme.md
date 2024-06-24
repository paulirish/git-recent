# git-recent

Type `git recent` to see your latest local git branches

## Usage

    git recent


Optionally, add `-n<int>` to see the most recent `<n>` branches

    git recent -n5

![git-recent screenshot](https://cloud.githubusercontent.com/assets/39191/17446638/039d4cee-5aff-11e6-9e11-4294f0020513.png)

If you're a Windows user, you need to use [Git Bash](https://git-scm.com/downloads) or similar shell in order to effectively use this utility.

## Installation

### Basic install

You can add the `git-recent` location to your path (e.g. add the directory to your `PATH` environment
or copy `git-recent` into an existing included path like `/usr/local/bin` or `~/bin/`).

### Install via NPM:

You can use also `npm` to install the global binary:

    npm install --global git-recent

On Mac, you can install with homebrew:

    brew install git-recent

### ZSH

#### [Antigen](https://github.com/zsh-users/antigen)

Add `antigen bundle paulirish/git-recent` to your `.zshrc` with your other bundle
commands.

Antigen will handle cloning the plugin for you automatically the next time you
start zsh, and periodically checking for updates to the git repository. You can
also add the plugin to a running zsh with `antigen bundle paulirish/git-recent`
for testing before adding it to your `.zshrc`.

#### [Oh-My-Zsh](http://ohmyz.sh/)

1. `git clone https://github.com/paulirish/git-recent.git $ZSH_CUSTOM/plugins/git-recent`
1. Add `git-recent` to your plugin list - edit `~/.zshrc` and change
   `plugins=(...)` to `plugins=(... git-recent)`

#### [Zgen](https://github.com/tarjoilija/zgen)

Add `zgen load paulirish/git-recent` to your .zshrc file in the same function
you're doing your other `zgen load` calls in. ZGen will take care of cloning
the repository the next time you run `zgen save`, and will also periodically
check for updates to the git repository.

#### [zplug](https://github.com/zplug/zplug)

`zplug "paulirish/git-recent", as:plugin`


## If you like this you may also be interested in...

- [`git open`](https://github.com/paulirish/git-open) - Open the repo website in your browser
- [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy/) - Making the output of `git diff` so fancy

## License

Copyright Paul Irish. Licensed under MIT.


## Changelog

- **2016-05-16** - added to [paulirish/dotfiles](https://github.com/paulirish/dotfiles/commit/1ca1ff760832af558447145fa2a367046b1829d2)
- **2016-08-05** - released in standalone repo and published to npm
