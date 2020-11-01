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


# Private zsh file
# (mainly for private aliases & env vars that are credentials)
if [ -f "$HOME"/.zshrc_private ]; then
  source "$HOME"/.zshrc_private
fi


# ---------- Paths ----------
# See line by line:  echo "${PATH//:/$'\n'}"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

# golang path:
export PATH=$PATH:/usr/local/go/bin
# $GOPATH env variable
export PATH=$PATH:$(go env GOPATH)/bin


# ---------- zsh plugins ----------
source "$HOME"/dotfiles/zsh/plugins/fixls.zsh
source "$HOME"/dotfiles/zsh/plugins/oh-my-zsh/lib/history.zsh
source "$HOME"/dotfiles/zsh/plugins/oh-my-zsh/lib/key-bindings.zsh
source "$HOME"/dotfiles/zsh/plugins/oh-my-zsh/lib/completion.zsh
source "$HOME"/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$HOME"/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh customization
source "$HOME"/dotfiles/zsh/keybindings.zsh
source "$HOME"/dotfiles/zsh/prompt.zsh


# ---------- Settings ----------
export VISUAL=vim
export LANG=en_US.UTF-8
HISTFILE=~/.zsh_history

# don't write these commands to the history
# TODO test this, <c-r> or history doesn't work but cat ~/.zsh_history works
HISTORY_IGNORE='(history|ls|cd|cd ..|pwd|clear|exit|cd|v)'

# To save every command before it is executed
setopt INC_APPEND_HISTORY

setopt SHARE_HISTORY

# avoid duplicate entries in the zsh history (also good for fzf search)
setopt HIST_IGNORE_ALL_DUPS

# don't save commands starting with a space in history
setopt HIST_IGNORE_SPACE


# ---------- Aliases ----------
alias cp='cp -iv' # 'cp' prompt and verbose
alias mv='mv -iv' # 'mv' prompt and verbose
alias l='ls -al'
alias la='ls -A'

c() {
  # Custom cd (always ls when cd into a folder)
  # don't quote the param because cd should lead to home like default
  cd $1 && ls
}
alias cd="c"


# ---------- Commands ----------
alias python=python3
alias pip=pip3

alias v='eval $(command -v nvim)'
# https://github.com/randy3k/radian
alias r='eval $(command -v radian)'
# https://github.com/bpython/bpython
alias py='eval $(command -v bpython)'


# ---------- Configuration ----------

# https://github.com/BurntSushi/ripgrep/blob/0.8.0/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$HOME"/.ripgreprc
# https://github.com/sharkdp/bat#configuration-file
export BAT_CONFIG_PATH="$HOME"/.batconf
export PYTHONSTARTUP=$HOME/.pythonstartup

# https://github.com/pyenv/pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# fzf (https://github.com/junegunn/fzf)

# use 'fd' in fzf, that's better for exclusion
# (Source: https://github.com/junegunn/dotfiles/blob/ba5013726515e5185a2840b4b133991fe37b8827/bashrc#L369-L373)
if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git node_modules'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
else
  echo "fd not found. Install for a better fzf experience: https://github.com/sharkdp/fd"
fi


# the line below is managed by fzf:
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
