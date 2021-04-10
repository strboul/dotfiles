#!/usr/bin/env bash

source "$HOME"/dotfiles/zsh/utils.sh

# --------------------------------------------------------------------------- #
# checks ----
# --------------------------------------------------------------------------- #

check__dotfiles_in_home_dir() {
  if [[ ! -d "$HOME"/dotfiles ]]; then
    utils__err_exit "/dotfiles not found in the home directory. Aborted."
  fi
}

check__dotfiles_in_home_dir

# --------------------------------------------------------------------------- #
# installs ----
# --------------------------------------------------------------------------- #

get_package_manager() {
  local ostype
  ostype="$(utils__get_ostype)"
  if [[ "$ostype" == "darwin"* ]]; then
    utils__stop_if_not_command_exists "brew" "Install brew [ https://brew.sh ]"
    echo "brew"
  elif [[ "$ostype" == "linux"* ]]; then
    local distro_name
    distro_name="$(utils__get_distro_name)"
      if [[ "$distro_name" == "Debian" ]]; then
        utils__stop_if_not_command_exists "apt-get" "Check the Ubuntu website."
        echo "apt"
      elif [[ "$distro_name" == "Manjaro"* || "$distro_name" == "Arch"* ]]; then
        utils__stop_if_not_command_exists "yay" "Install yay [ https://github.com/Jguer/yay ]"
        echo "yay"
      else
        utils__err_exit "unknown linux distro"
      fi
  else
    utils__err_exit "platform not supported"
  fi
}

get_package_manager_inst_prefix() {
  local package_manager="$1"
  declare -A installation_prefix=(
    ["brew"]="brew install"
    ["apt"]="apt-get -y install"
    ["yay"]="yay -Sy"
  )
  echo "${installation_prefix["$package_manager"]}"
}

PKG_MAN=$(get_package_manager)
PKG_MAN_INST_PREFIX="$(get_package_manager_inst_prefix "$PKG_MAN")"

install_if_command_not_exist() {
  local command="$1"
  local fun="$2"
  if [ "$(utils__check_if_command_exists "$command")" = false ]; then
    utils__color_msg "yellow" "\"$command\" not found on local. Installing..."
    "$fun"
  else
    utils__color_msg "yellow" "\"$command\" is already installed. Skipping."
    echo
  fi
}

install__install_with_pkg_manager() {
  local command="$1"
  local -n package_arr=$2
  install_with_pkg_manager() {
    utils__color_msg "green" "installing \"$command\" via the package manager"
    local package_name
    package_name="${package_arr[$PKG_MAN]}"
    [ -z "$package_name" ] && package_name="${package_arr["all"]}"
    $PKG_MAN_INST_PREFIX "$package_name"
  }
  install_if_command_not_exist "$command" install_with_pkg_manager
}

install__install_custom() {
  local command="$1"
  local inst_fun="$2"
  install_custom() {
    utils__color_msg "green" "installing \"$command\" via custom script"
    "$inst_fun"
  }
  install_if_command_not_exist "$command" install_custom
}


# The data structure designed around that if the package version doesn't exist,
# the 'all' key is looked in the array. That way, I don't have to list the
# names in all.
{
  declare -A pkg_zsh=( ["all"]="zsh" )
  install__install_with_pkg_manager "zsh" "pkg_zsh"
}
{
  declare -A pkg_tmux=( ["all"]="tmux" )
  install__install_with_pkg_manager "tmux" "pkg_tmux"
  # extra terminfo run for tmux:
  tic "$HOME"/dotfiles/tmux/tmux-256color.terminfo
  tic "$HOME"/dotfiles/tmux/xterm-256color-italic.terminfo
}
{
  # https://github.com/neovim/neovim
  declare -A pkg_neovim=( ["brew"]="nvim" ["apt"]="nvim" ["yay"]="neovim" )
  install__install_with_pkg_manager "nvim" "pkg_neovim"
}
{
  # https://github.com/BurntSushi/ripgrep
  declare -A pkg_ripgrep=( ["all"]="ripgrep" )
  install__install_with_pkg_manager "rg" "pkg_ripgrep"
}
{
  # https://github.com/sharkdp/fd
  declare -A pkg_fd=( ["all"]="fd" )
  install__install_with_pkg_manager "fd" "pkg_fd"
}
{
  # https://github.com/sharkdp/bat
  declare -A pkg_bat=( ["all"]="bat" )
  install__install_with_pkg_manager "bat" "pkg_bat"
}
{
  # https://github.com/stedolan/jq
  declare -A pkg_jq=( ["all"]="jq" )
  install__install_with_pkg_manager "jq" "pkg_jq"
}
{
  # https://github.com/koalaman/shellcheck
  declare -A pkg_shellcheck=( ["all"]="shellcheck" )
  install__install_with_pkg_manager "shellcheck" "pkg_shellcheck"
}
{
  # https://github.com/jesseduffield/lazygit
  declare -A pkg_lazygit=( ["all"]="lazygit" )
  install__install_with_pkg_manager "lazygit" "pkg_lazygit"
}
{
  # https://github.com/universal-ctags/ctags
  declare -A pkg_ctags=( ["brew"]="--HEAD universal-ctags/universal-ctags/universal-ctags" ["yay"]="ctags" )
  install__install_with_pkg_manager "ctags" "pkg_ctags"
}
{
  declare -A pkg_nodejs=( ["all"]="nodejs" )
  install__install_with_pkg_manager "node" "pkg_nodejs"
}
{
  # https://github.com/junegunn/fzf
  install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
      ~/.fzf/install
  }
  install__install_custom "fzf" install_fzf
}

install__install_ohmyzsh() {

  local ohmyzsh_exists
  ohmyzsh_exists="$(utils__check_variable_exists "$ZSH")"

  if [ "$ohmyzsh_exists" ]; then
    utils__color_msg "yellow" "\"ohmyzsh\" is already installed. Skipping."
    echo
    return 1
  fi

  utils__color_msg "yellow" "Installing \"ohmyzsh\" and plugins"

  install_ohmyzsh() {
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  }

  install_plugin_autosuggestions() {
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
      "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  }

  install_plugin_syntax_highlighting() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  }

  install_plugin_autosuggestions
  install_plugin_syntax_highlighting
}

install__install_ohmyzsh

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
    Do you want to \`sudo chsh -s $(command -v zsh)\`?
    (Tip: leave the password prompt empty by pressing the <Enter> right away.)
    "
    utils__stop_if_not_command_exists "sudo"
    sudo chsh -s "$(command -v zsh)"
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
  }
}

change_default_shell="$(utils__yesno_prompt "Do you want to change the default shell to zsh?")"
if [ "${change_default_shell}" == "y" ]; then
  shell__check_default_shell
fi

link_files="$(utils__yesno_prompt "Do you want to link the files?")"
if [ "${link_files}" == "y" ]; then
  source "$HOME"/dotfiles/zsh/link.sh
fi

echo
echo "-----------"
echo "Setup done."
echo "-----------"
