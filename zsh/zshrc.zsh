# disable the update prompt
DISABLE_UPDATE_PROMPT=true

# Private zsh file
# (e.g. for private aliases & env vars that are credentials)
[ -f "$HOME"/.zshrc_private ] && source "$HOME"/.zshrc_private

# ===== tmux =====
# Initialize tmux on zsh start-up if
# (1) tmux exists,
# (2) terminal emulator is alacritty.
if command -v tmux>/dev/null; then
  [ -z "$TMUX" ] && \
    [ "$TERM_PROGRAM" = "alacritty" ] && \
      # -u   is for UTF-8
      # -2   force tmux to assume the terminal supports 256 colours.
      exec tmux -2 -u
fi

# change the default term to TMUX that it can display 256 colors
export TERM=xterm-256color

# ===== oh-my-zsh =====
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="strboul"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker-compose
)

source $ZSH/oh-my-zsh.sh

# ===== paths =====
# See line by line:  echo "${PATH//:/$'\n'}"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

# golang path:
export PATH=$PATH:/usr/local/go/bin
# $GOPATH env variable
export PATH=$PATH:$(go env GOPATH)/bin

# ===== sources =====
source "$HOME"/dotfiles/zsh/keybindings.zsh

# ===== settings =====
export LANG=en_US.UTF-8
export EDITOR="nvim -u DEFAULTS"
export DISABLE_AUTO_TITLE="true"

# don't change dir without 'cd' command
unsetopt AUTO_CD
# don't use `less` pager for some commands, e.g. git
unset LESS
# save commands to history on type, not at shell exit
setopt INC_APPEND_HISTORY
# share history across zsh sessions
setopt SHARE_HISTORY
# ignore all duplicate entries in the zsh history (also good for fzf search)
setopt HIST_IGNORE_ALL_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# don't save commands starting with a space in history
setopt HIST_IGNORE_SPACE

# don't write these commands to the history
# TODO test this, <c-r> or history doesn't work but cat ~/.zsh_history works
HISTORY_IGNORE="(history|ls|cd|cd ..|pwd|clear|exit|cd|v)"

# ===== aliases =====

cdls() {
  # Custom cd (always ls when cd into a folder)
  # don't quote the param because cd should lead to home like default
  builtin cd "$@" && ls
}
alias cd="cdls"

alias cp="cp -iv" # 'cp' prompt and verbose
alias mv="mv -iv" # 'mv' prompt and verbose
alias ll="ls -l"
alias la="ls -al"

alias v="eval $(command -v nvim)"
alias v2="nvim -u $HOME/.config/nvim/lua/init.lua"
# https://github.com/randy3k/radian
alias r="eval $(command -v radian)"
# https://github.com/bpython/bpython
alias py="eval $(command -v bpython)"


# ===== configs =====

# https://github.com/BurntSushi/ripgrep/blob/0.8.0/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$HOME"/.ripgreprc
# https://github.com/sharkdp/bat#configuration-file
export BAT_CONFIG_PATH="$HOME"/.batconf
export PYTHONSTARTUP=$HOME/.pythonstartup

# pyenv (https://github.com/pyenv/pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# fzf (https://github.com/junegunn/fzf)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# use 'fd' in fzf, that's better for exclusion.
# (Source: https://github.com/junegunn/dotfiles/blob/ba5013726515e5185a2840b4b133991fe37b8827/bashrc#L369-L373)
if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git node_modules'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
else
  echo "fd not found. Install for a better fzf experience: https://github.com/sharkdp/fd"
fi
