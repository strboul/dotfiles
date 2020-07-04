
# Initialize tmux on zsh start-up if
# (1) tmux exists,
# (2) terminal emulator is alacritty.
if command -v tmux>/dev/null; then
  [ -z "$TMUX" ] && \
    [ "$TERM_EMU" = "alacritty" ] && \
      exec tmux -u # -u is for UTF-8
fi


# Private zsh file
# (mainly for private aliases & env vars that are credentials)
if [ -f "$HOME"/.zshrc_private ]; then
  source "$HOME"/.zshrc_private
fi


# Paths
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$HOME/dotfiles/bin"


# Settings
export VISUAL=vim
export LANG=en_US.UTF-8


## zsh plugins
source "$HOME"/dotfiles/zsh/plugins/fixls.zsh
source "$HOME"/dotfiles/zsh/plugins/oh-my-zsh/lib/history.zsh
source "$HOME"/dotfiles/zsh/plugins/oh-my-zsh/lib/key-bindings.zsh
source "$HOME"/dotfiles/zsh/plugins/oh-my-zsh/lib/completion.zsh
source "$HOME"/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$HOME"/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## more zsh customization
source "$HOME"/dotfiles/zsh/keybindings.sh
source "$HOME"/dotfiles/zsh/prompt.sh


# Vars
HISTFILE=~/.zsh_history
# To save every command before it is executed
setopt inc_append_history

setopt share_history

# avoid duplicate entries in the zsh history (also good for fzf search)
setopt HIST_IGNORE_ALL_DUPS


# don't save commands in history starting with a space
setopt HIST_IGNORE_SPACE

# Aliases
alias cp='cp -iv' # 'cp' prompt and verbose
alias mv='mv -iv' # 'mv' prompt and verbose
alias ll='ls -al'
alias la='ls -A'

alias v='eval $(command -v nvim)'
alias r='eval $(command -v radian)' # https://github.com/randy3k/radian


# Functions
# Custom cd (always ls when cd into a folder)
c() {
  # don't quote the param because cd should lead to home like default
  cd $1;
  ls;
}
alias cd="c"


# https://github.com/BurntSushi/ripgrep/blob/0.8.0/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$HOME"/.ripgreprc
# https://github.com/sharkdp/bat#configuration-file
export BAT_CONFIG_PATH="$HOME"/.batconf


## pyenv path
export PATH="$PATH:$HOME/.pyenv/bin"
if [ -x "$(command -v pyenv)" ]; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


export PYTHONSTARTUP=$HOME/.pythonstartup


# fzf (managed by fzf):
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

