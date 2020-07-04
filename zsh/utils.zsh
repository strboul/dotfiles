# utils.zsh
# reusable functions across sh scripts

color_msg() {
  # Example:
  # color_msg "red" "Oh no!" "Something went wrong."
  declare -A colors
  local colors=( ["red"]="31" ["green"]="32" ["yellow"]="33")
  local selected_color="${colors["$1"]}"
  printf "\e["$selected_color"m%s\e[0m " "${@:2}"
  echo
}


err_exit() {
  local msg=$(color_msg "red" $(printf "Error: %s\n" "${1}"))
  echo >&2 "$msg"
  exit 1
}


check_file_or_dir_exists() {
  # Check a file or folder exists. May be useful to call this before symlinks.
  # Example:
  # check_file_or_dir_exists ".git" "git not found"
  if [ ! -d "$1" ] && [ ! -f "$1" ]; then
    err_exit "$2"
  fi
}
