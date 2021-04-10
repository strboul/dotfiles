#!/usr/bin/env bash

set -e

install__pyenv() {
  # pyenv: Simple Python version management
  # https://github.com/pyenv/pyenv
  #
  # pyenv commands | List all available commands
  # pyenv versions | See the installed versions
  # pyenv local    | Set a local python version into a .python-version file
  # pyenv global   | Set the global version of Python

  # https://github.com/pyenv/pyenv-installer
  if [ ! -x "$(command -v pyenv>/dev/null)" ]; then
    curl https://pyenv.run | bash
  fi

  # install the latest stable pyenv version
  # (Source: https://stackoverflow.com/a/33423958/)
  pyenv install "$(pyenv install --list | grep -v - | grep -v b | tail -1)"

  pyenv install 3.9.1
  pyenv install 3.8.0
  pyenv install 2.7.15 # some old version for legacy code
}

install__pyenv

"$(command -v pyenv)" global 3.8.0

PIP_INSTALL="python -m pip install --user"

$PIP_INSTALL virtualenv
$PIP_INSTALL pynvim        # python neovim modules. See `:h provider-python` in neovim
$PIP_INSTALL jupyter       # https://jupyter.org/install
$PIP_INSTALL pylint        # https://github.com/PyCQA/pylint
$PIP_INSTALL radian        # https://github.com/randy3k/radian
$PIP_INSTALL bpython       # https://github.com/bpython/bpython
$PIP_INSTALL pdbpp         # https://github.com/pdbpp/pdbpp (drop-in replacement for pdb)
$PIP_INSTALL git-substatus # https://github.com/strboul/git-substatus
$PIP_INSTALL tmuxp         # https://github.com/tmux-python/tmuxp
