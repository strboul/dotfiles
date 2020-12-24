#!/usr/bin/env bash

source "$HOME"/dotfiles/zsh/utils.sh

set -e

# --------------------------------------------------------------------------- #
# check ----
# --------------------------------------------------------------------------- #

check__dotfiles_in_home_dir() {
  if [[ ! -d "$HOME"/dotfiles ]]; then
    utils__err_exit "dotfiles/ not found in the home directory. Aborted."
  fi
}


check__curl_installed() {
  utils__stop_if_not_command_exists "curl" "Install cURL first https://curl.se/"
}


check__pkg_managers_installed() {
  echo "Checking OS package manager availability"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    utils__stop_if_not_command_exists "brew" "Install brew \"https://brew.sh\""
  elif [[ "$OSTYPE" == "linux"* ]]; then
    utils__stop_if_not_command_exists "apt-get" "Check Ubuntu page."
  else
    utils__err_exit "platform not supported."
  fi
}


# --------------------------------------------------------------------------- #
# install ----
# --------------------------------------------------------------------------- #

# Asks first and then installs by using (available) package managers
install__ask_install_with_pkg_manager() {
  echo "Checking to see whether [$1|$2] is installed"
  if [ ! -x "$(command -v "$1")" ]; then
    utils__user_prompt "\"$1\" not found. Would you like to install it?" >&2
    install__install_with_pkg_manager "$2"
  else
    echo "$1 : $2 is installed. Skipping."
  fi
}


# Installs with the built-in package manager
install__install_with_pkg_manager() {
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install "$1" -y
  elif [ -x "$(command -v brew)" ]; then
    brew install "$1"
  else
    echo "platform/pkg manager not supported."
  fi
}

### Languages installed first ###

install__python() {
  # TODO make it work
  source "$HOME"/dotfiles/install/python.sh
}


install__nodejs() {
  # FIXME
  install__install_with_pkg_manager "node" "nodejs"
}


### Programs & tools to install ###

install__zsh() {
  install__install_with_pkg_manager "zsh" "zsh"
}


install__neovim() {
  install_pynvim() {
    # python neovim modules. See `:h provider-python` in neovim
    "$(command -v python3)" -m pip install -U pynvim --user
  }
  install_pynvim
  # FIXME neovim and tmux have outdated versions in apt-get
  install__install_with_pkg_manager "nvim" "neovim"
}


install__tmux() {
  install__install_with_pkg_manager "tmux" "tmux"
  tic "$HOME"/dotfiles/tmux/tmux-256color.terminfo
  tic "$HOME"/dotfiles/tmux/xterm-256color-italic.terminfo
}


install__fzf() {
  # https://github.com/junegunn/fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install
}


install__ripgrep() {
  # https://github.com/BurntSushi/ripgrep
  # TODO fix the do_install_with_pkg_manager function definition file
  install__install_with_pkg_manager "rg" "ripgrep"
}


install__fd() {
  # FIXME
  # https://github.com/sharkdp/fd
  install__install_with_pkg_manager "fd" "fd"
}


install__bat() {
  # https://github.com/sharkdp/bat
  install__install_with_pkg_manager "bat" "bat"
}


install__universal_ctags() {
  # https://github.com/universal-ctags/ctags
  git clone https://github.com/universal-ctags/ctags.git /tmp/ctags && \
    pushd /tmp/ctags &&               \
    ./autogen.sh &&                   \
    ./configure --program-prefix=u && \
    make && make install &&           \
    popd &&                           \
    rm -rf /tmp/ctags/
}


install__vim_sensible() {
  # https://github.com/tpope/vim-sensible
  if [ ! -f "$HOME"/.vimrc ]; then
    wget -O \
    "$HOME"/.vimrc \
    https://raw.githubusercontent.com/tpope/vim-sensible/master/plugin/sensible.vim
  fi
}


install__htop() {
  install__install_with_pkg_manager "htop" "htop"
}


install__git_cola() {
  # https://github.com/git-cola/git-cola
  install__install_with_pkg_manager "git-cola" "git-cola"
}


install__git_substatus() {
  # https://github.com/strboul/git-substatus
  pip install git-substatus
}


install__shellcheck() {
  # https://github.com/koalaman/shellcheck
  install__install_with_pkg_manager "shellcheck" "shellcheck"
}


# --------------------------------------------------------------------------- #
# shell ----
# --------------------------------------------------------------------------- #

# Change the default shell to zsh.
shell__change_default_shell() {
  if [ -z "${SHELL##*zsh*}" ]; then
    echo "Default shell is zsh."
  else
    utils__user_prompt "
    Default shell is not \"zsh\".
    Do you want to \`chsh -s $(command -v zsh)\`?
    (Tip: leave the password prompt empty by pressing the <Enter> right away.)
    "
    chsh -s "$(command -v zsh)"
    echo "Success! Shell should be changed upon the next login."
  fi
}


shell__check_default_shell() {
  {
    shell__change_default_shell
  } || {
    utils__color_msg "red"                                                \
    "The configuration will not work properly without \"zsh\"."    \
    "\nTroubleshooting:"                                           \
    "If you received \"chsh: PAM: Authentication failure\" error," \
    "you can try to do the following actions:"                     \
    "Open file \`sudo vi /etc/pam.d/chsh\`"                        \
    "\`auth       required   pam_shells.so\` should be:"           \
    "\`auth       sufficient   pam_shells.so\`"
    utils__err_exit "Aborted."
  }
}

# --------------------------------------------------------------------------- #
# main ----
# --------------------------------------------------------------------------- #

main() {

  # main variables:
  num_dashes_to_print=79

  utils__print_dashes $num_dashes_to_print

  echo
  echo "Pulling latest changes from the remote..."
  (cd ~/dotfiles && git pull && git submodule update --init --recursive)
  echo

  # Pre-installation checks
  check__dotfiles_in_home_dir
  check__curl_installed
  check__pkg_managers_installed
  echo

  # Prompting user first time
  echo "Configure and install the dotfiles"
  echo "Installing: zsh, neovim, tmux"
  utils__user_prompt "Let's get started?"
  echo


  install__zsh

  install__neovim

  install__tmux


  # Link all files:
  source "$HOME"/dotfiles/zsh/link.sh
  echo


  # program installs:
  install__fzf
  install__ripgrep
  install__fd
  install__bat
  install__python
  install__nodejs
  install__universal_ctags
  install__vim_sensible
  install__htop
  install__git_substatus
  install__shellcheck


  shell__check_default_shell
  echo


  echo "Please log out and log back in for default shell to be initialized."

  utils__print_dashes $num_dashes_to_print
}

main
