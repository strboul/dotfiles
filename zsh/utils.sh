# Util functions
# reusable functions across sh scripts

utils__print_dashes() {
  printf -- "-%.0s" $(echo $(seq $1))
  echo
}


utils__timestamp() {
  date "+%Y-%m-%dT%H-%M-%S"
}


utils__color_msg() {
  # Example:
  # color_msg "red" "Oh no!" "Something went wrong."
  declare -A colors
  local colors=(["red"]="31" ["green"]="32" ["yellow"]="33")
  local selected_color="${colors["$1"]}"
  printf "\e["$selected_color"m%s\e[0m " "${@:2}"
  echo
}


utils__err_exit() {
  local msg=$(utils__color_msg "red" $(printf "Error: %s\n" "${1}"))
  echo >&2 "$msg"
  exit 1
}


utils__check_file_or_dir_exists() {
  # Check a file or folder exists. May be useful to call this before symlinks.
  # Example:
  # check_file_or_dir_exists ".git" "git not found"
  if [ ! -d "$1" ] && [ ! -f "$1" ]; then
    utils__err_exit "$2"
  fi
}


# Source: https://stackoverflow.com/a/27875395/
utils__user_prompt() {
  utils__color_msg "yellow" $(printf "%s [y/N]" "$@")
  local old_stty_cfg=$(stty -g)
  stty raw -echo
  local answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
  stty "$old_stty_cfg"
  if echo "$answer" | grep -iq "^y" ;then
    echo "$answer"
    : # do nothing. proceed to script.
  else
    echo "$answer"
    utils__err_exit "Aborted."
  fi
}
