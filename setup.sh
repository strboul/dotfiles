#!/usr/bin/env bash

source "$HOME"/dotfiles/zsh/utils.zsh

set -e

echo_dashes() {
  printf -- "-%.0s" $(seq 49)
  echo
}


check_dotfiles_in_home_dir() {
  if [[ ! -d "$HOME"/dotfiles ]]; then
    err_exit "dotfiles/ not found in the home directory. Aborted."
  fi
}


pkg_manager_check() {
  echo "Checking whether package manager is present in this OS"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ ! -x "$(command -v brew)" ]; then
      err_exit "brew not found. Install brew \"https://brew.sh\""
    fi
  elif [[ "$OSTYPE" == "linux"* ]]; then
    if [ ! -x "$(command -v apt-get)" ]; then
      err_exit "apt not found in the system."
    fi
  else
    err_exit "platform not supported."
  fi
}


# Source: https://stackoverflow.com/a/27875395/
user_prompt() {
  color_msg "yellow" "$@"
  local old_stty_cfg=$(stty -g)
  stty raw -echo
  local answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
  stty "$old_stty_cfg"
  if echo "$answer" | grep -iq "^y" ;then
    echo "$answer"
    : # do nothing. proceed to script.
  else
    echo "$answer"
    err_exit "Aborted."
  fi
}


check_install_with_pkg_manager() {
  echo "Checking to see whether [$1|$2] is installed"
  if [ ! -x "$(command -v "$1")" ]; then
    user_prompt "\"$1\" not found. Would you like to install it? [y/N]" >&2
    do_install_with_pkg_manager "$2"
  else
    echo "$1 : $2 is installed."
  fi
}


do_install_with_pkg_manager() {
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install "$1" -y
  elif [ -x "$(command -v brew)" ]; then
    brew install "$1"
  else
    echo "platform/pkg manager not supported."
  fi
}


# Change the default shell to zsh.
change_default_shell() {
  if [ -z "${SHELL##*zsh*}" ]; then
    echo "Default shell is zsh."
  else
    user_prompt "
    Default shell is not \"zsh\".
    Do you want to \`chsh -s $(command -v zsh)\`? [y/N]
    (Tip: leave the password prompt empty by pressing the <Enter> right away.)
    "
    chsh -s "$(command -v zsh)"
    echo "Success! Shell should be changed upon the next login."
  fi
}


check_default_shell() {
  {
    change_default_shell
  } || {
    color_msg "red" \
    "The configuration will not work properly without \"zsh\"." \
    "\nTroubleshooting:" \
    "If you received \"chsh: PAM: Authentication failure\" error," \
    "you can try to do the following actions:" \
    "Open file \`sudo vi /etc/pam.d/chsh\`" \
    "\`auth       required   pam_shells.so\` should be:" \
    "\`auth       sufficient   pam_shells.so\`"
    err_exit "Aborted."
  }
}


check_curl_installed() {
  if [ ! -x "$(command -v curl)" ]; then
    echo "curl not found. Install cURL first."
    err_exit "Aborted."
  fi
}


### ---------------------------------------------- ###
### -------------------- MAIN -------------------- ###
### ---------------------------------------------- ###

# Pre-checks
check_dotfiles_in_home_dir
check_curl_installed

echo "Pulling latest changes from the upstream..."
(cd ~/dotfiles && git pull && git submodule update --init --recursive)

# Start prompting user
echo_dashes
echo "Configure and install the dotfiles"
echo
echo "Installing: zsh, neovim, tmux"
echo
user_prompt "Let's get started? [y/N]"
pkg_manager_check
echo
check_install_with_pkg_manager zsh zsh
echo
check_install_with_pkg_manager nvim neovim
echo
check_install_with_pkg_manager tmux tmux


# Link all files:
source "$HOME"/dotfiles/zsh/link.sh
echo

# Install tooling
echo "Installing: \
  fzf, \
  ripgrep, \
  universal-ctags, \
  vim-sensible, \
  git-substatus, \
  nodejs, \
  htop
  "
user_prompt "Do you want to install the (extra) tooling? [y/N]"
source "$HOME"/dotfiles/zsh/install-extra-libs.sh
install_fzf
install_ripgrep
install_universal_ctags
install_vim_sensible
install_git_substatus
install_nodejs
check_install_with_pkg_manager htop htop


echo
echo "Please log out and log back in for default shell to be initialized."

# vim: set ts=2 sw=2 expandtab
