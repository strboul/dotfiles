#!/usr/bin/env bash

# Symbolic link the files (config, tools etc.) so that they are always git
# controlled.

source "$HOME"/dotfiles/zsh/utils.sh

do_link() {
  utils__check_file_or_dir_exists \
    "$1" \
    "$(printf "file or folder not exist in dotfiles: \"%s\"" "$1")"
  mkdir -p "${2%/*}"
  if [[ -h "$2" ]]; then
    printf "symlink already exists in: \"%s\" -> \"%s\"\n" "$1" "$2"
  else
    utils__color_msg "green" "$(printf "Linking: \"%s\" -> \"%s\"\n" "$1" "$2")"
    ln -sfn "$1" "$2"
  fi
}

# zsh
do_link "$HOME"/dotfiles/zsh/zshrc.zsh "$HOME"/.zshrc
do_link "$HOME"/dotfiles/zsh/strboul-theme.zsh "$ZSH"/themes/strboul.zsh-theme

# tmux
do_link "$HOME"/dotfiles/tmux/tmux.conf "$HOME"/.tmux.conf

# nvim
do_link "$HOME"/dotfiles/nvim/init.vim "$HOME"/.config/nvim/init.vim
do_link "$HOME"/dotfiles/nvim/lua/ "$HOME"/.config/nvim/lua
do_link "$HOME"/dotfiles/nvim/plugins/coc/coc-settings.json "$HOME"/.config/nvim/coc-settings.json
do_link "$HOME"/dotfiles/nvim/snippets/ "$HOME"/.config/nvim/UltiSnips

# lang
do_link "$HOME"/dotfiles/lang/R/Rprofile.R "$HOME"/.Rprofile
do_link "$HOME"/dotfiles/lang/python/pythonstartup.py "$HOME"/.pythonstartup

# tools
do_link "$HOME"/dotfiles/tools/alacritty/alacritty.yml "$HOME"/.config/alacritty/alacritty.yml
do_link "$HOME"/dotfiles/tools/ripgreprc "$HOME"/.ripgreprc
do_link "$HOME"/dotfiles/tools/batconf "$HOME"/.batconf
do_link "$HOME"/dotfiles/tools/fonts/JetBrainsMono/ "$HOME"/.local/share/fonts

do_link "$HOME"/dotfiles/tools/git/gitconfig "$HOME"/.gitconfig
do_link "$HOME"/dotfiles/tools/git/gitignore_global "$HOME"/.gitignore

# editors
do_link "$HOME"/dotfiles/editors/rstudio/r_rstudio.snippets "$HOME"/.R/snippets/r.snippets
