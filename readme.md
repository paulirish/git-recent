# git-recent

Type `git recent` to see your latest local git branches

## Usage

    git recent


Optionally, add `-n<int>` to see the most recent `<n>` branches

    git recent -n5

![git-recent screenshot](https://cloud.githubusercontent.com/assets/39191/17446638/039d4cee-5aff-11e6-9e11-4294f0020513.png)

If you're a Windows user, you need to use [Git Bash](https://git-scm.com/downloads) or similar shell in order to effectively use this utility.

### Installation

You can add the `git-recent` location to your path (e.g. add the directory to your `PATH` environment
or copy `git-recent` into an existing included path like `/usr/local/bin` or `~/bin/`).

You can use also `npm` to install the global binary:

    npm install --global git-recent

On Mac, you can install with homebrew:

    brew install git-recent

## If you like this you may also be interested in...

- [`git open`](https://github.com/paulirish/git-open) - Open the repo website in your browser
- [`diff-so-fancy`](https://github.com/so-fancy/diff-so-fancy/) - Making the output of `git diff` so fancy

## License

Copyright Paul Irish. Licensed under MIT.


## Changelog

- **2016-05-16** - added to [paulirish/dotfiles](https://github.com/paulirish/dotfiles/commit/1ca1ff760832af558447145fa2a367046b1829d2)
- **2016-08-05** - released in standalone repo and published to npm
