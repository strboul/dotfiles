#!/usr/bin/env bash

# Symbolic link the files (config, tools etc.) so that they are always git
# controlled.

source "$HOME"/dotfiles/zsh/utils.sh


do_link() {

  utils__check_file_or_dir_exists \
    "$2" \
    "$(printf "file or folder not exist in dotfiles: \"%s\"" "$2")"

  mkdir -p "${1%/*}"

  if [[ -h "$1" ]]; then
    printf "symlink already exists in: \"%s\" -> \"%s\"\n" "$2" "$1"
  else
    utils__color_msg "green" "$(printf "Linking: \"%s\" -> \"%s\"\n" "$2" "$1")"
    ln -sfn "$2" "$1"
  fi

}


# Essentials
do_link "$HOME"/.zshrc                          "$HOME"/dotfiles/zsh/zshrc.zsh
do_link "$HOME"/.tmux.conf                      "$HOME"/dotfiles/tmux/tmux.conf
do_link "$HOME"/.config/alacritty/alacritty.yml "$HOME"/dotfiles/tools/alacritty/alacritty.yml


# Editors
do_link "$HOME"/.R/snippets/r.snippets "$HOME"/dotfiles/editors/rstudio/r_rstudio.snippets


# nvim
do_link "$HOME"/.config/nvim/init.vim          "$HOME"/dotfiles/nvim/init.vim
do_link "$HOME"/.config/nvim/lua               "$HOME"/dotfiles/nvim/lua/
do_link "$HOME"/.config/nvim/coc-settings.json "$HOME"/dotfiles/nvim/plugins/coc/coc-settings.json
do_link "$HOME"/.config/nvim/UltiSnips         "$HOME"/dotfiles/nvim/snippets/


# Languages
do_link "$HOME"/.Rprofile      "$HOME"/dotfiles/languages/R/Rprofile.R
do_link "$HOME"/.lintr         "$HOME"/dotfiles/languages/R/lintr
do_link "$HOME"/.pythonstartup "$HOME"/dotfiles/languages/python/pythonstartup.py


# Tools
do_link "$HOME"/.ripgreprc        "$HOME"/dotfiles/tools/ripgreprc
do_link "$HOME"/.batconf          "$HOME"/dotfiles/tools/batconf
do_link "$HOME"/.config/grv/grvrc "$HOME"/dotfiles/tools/grvrc
do_link "$HOME"/.lldbinit         "$HOME"/dotfiles/tools/lldbinit

do_link "$HOME"/.local/share/fonts "$HOME"/dotfiles/tools/fonts/JetBrainsMono/


do_link "$HOME"/.gitconfig "$HOME"/dotfiles/tools/git/gitconfig
do_link "$HOME"/.gitignore "$HOME"/dotfiles/tools/git/gitignore

