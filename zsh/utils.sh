#!/usr/bin/env bash

# Reusable util functions for the dotfiles - aims to be POSIX compatible.

# --------------------------------------------------------------------------- #
# log ----
# --------------------------------------------------------------------------- #

utils__log__info() {
  utils__message__color_message "yellow" "[$(utils__timestamp)]" "$@"
}

utils__log__success() {
  utils__message__color_message "green" "[$(utils__timestamp)]" "$@"
}

utils__log__error() {
  utils__message__color_message "red" "[$(utils__timestamp)]" "$@"
}

# --------------------------------------------------------------------------- #
# message ----
# --------------------------------------------------------------------------- #

utils__message__color_message() {
  # Example:
  # color_msg "red" "Oh no!" "Something went wrong."
  local color_name="$1"
  local messages="${@:2}"

  declare -A colors
  local colors=(["red"]="31" ["green"]="32" ["yellow"]="33")

  local selected
  local selected="${colors["$color_name"]}"

  printf "\e[\"$selected\"m%s\e[0m " "$messages"
  echo
}

# --------------------------------------------------------------------------- #
# OS ----
# --------------------------------------------------------------------------- #

utils__os__get_ostype() {
  echo "$OSTYPE"
}

utils__os__get_distro_name() {
  grep "^NAME=" /etc/os-release | awk -F= '{print $2}' | tr -d '"'
}

# --------------------------------------------------------------------------- #
# git ----
# --------------------------------------------------------------------------- #

utils__git__is_repository() {
  local pat=$1
  git -C "$pat" rev-parse >/dev/null 2>&1 || return 1
}

utils__git__check_repository() {
  local pat=$1
  if ! utils__git__is_repository "$pat"; then
    utils__err_exit "not a git repository"
  fi
}

# --------------------------------------------------------------------------- #
# misc ----
# --------------------------------------------------------------------------- #

utils__print_dashes() {
  local num_dashes=$1
  printf -- "-%.0s" $(seq "$num_dashes")
  echo
}

utils__timestamp() {
  date "+%F %T"
}

utils__err_exit() {
  local msg
  msg=$(utils__message__color_message "red" "$(printf "Error: %s\n" "${1}")")
  echo >&2 "$msg"
  exit 1
}

utils__check_file_or_dir_exists() {
  # Check a file or folder exists. May be useful to call this before symlinks.
  # Example:
  # check_file_or_dir_exists ".git" "git not found"
  local file_dir=$1
  local msg=$2
  if [ ! -d "$file_dir" ] && [ ! -f "$file_dir" ]; then
    utils__err_exit "$msg"
  fi
}

# TODO doesn't work?
utils__check_variable_exists() {
  local var="$1"
  if [ -z "$var" ]; then echo true; else echo false; fi
}

utils__stop_if_variable_not_exist() {
  local var="$1"
  local msg="$2"
  if ! utils__check_variable_exists "$var"; then
    utils__err_exit "$msg"
  fi
}

utils__check_if_command_exists() {
  if [ -x "$(command -v "$1")" ]; then echo true; else echo false; fi
}

utils__stop_if_not_command_exists() {
  local cmd=$1
  local msg=$2
  [ "$(utils__check_if_command_exists "$cmd")" = false ] && utils__err_exit "$(printf "command \"%s\" not found. %s" "$cmd" "$msg")"
  : # proceed
}

utils__yesno_prompt() {
  local msg=$1
  while true; do
    read -r -p "$(utils__log__info "yellow" "${msg} [y/N]?")" answer
    case ${answer} in
      y) echo "y"; return 0 ;;
      N) echo "N"; return 1 ;;
      *) echo "Error: invalid option ${answer}. Try again [y/N]." ;;
    esac
  done
}
