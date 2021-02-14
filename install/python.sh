#!/usr/bin/env bash

PIP="$(command -v pip)"


install_pyenv() {
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

  pyenv install 3.8.0
  pyenv install 3.7.5
  pyenv install 2.7.15 # some old version for legacy code

}


install_jupyter() {
  # https://jupyter.org/install
  "$PIP" install jupyter
}


install_jedi() {
  # Python autocomplete engine
  # https://github.com/davidhalter/jedi
  "$PIP" install jedi
}


install_radian() {
  # https://github.com/randy3k/radian
  "$PIP" install -U radian --user
}


install_bpython() {
  # https://github.com/bpython/bpython
  "$PIP" install bpython
}


install_pdbpp() {
  # pdb++, a drop-in replacement for pdb
  # https://github.com/pdbpp/pdbpp
  "$PIP" install pdbpp
}


install_pyenv
install_jupyter
install_jedi
install_radian
install_bpython
install_pdbpp
