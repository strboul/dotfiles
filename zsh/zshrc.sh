
# How can I set my default shell to start up tmux https://unix.stackexchange.com/a/113768
if command -v tmux>/dev/null; then
	[ -z "$TMUX" ] && exec tmux
else
	echo "tmux not installed. Run ./deploy to configure dependencies"
fi

# Settings
export VISUAL=vim
export LANG=en_US.UTF-8

source ~/dotfiles/zsh/plugins/fixls.zsh

source ~/dotfiles/zsh/plugins/oh-my-zsh/lib/history.zsh
source ~/dotfiles/zsh/plugins/oh-my-zsh/lib/key-bindings.zsh
source ~/dotfiles/zsh/plugins/oh-my-zsh/lib/completion.zsh
source ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source ~/dotfiles/zsh/keybindings.sh
source ~/dotfiles/zsh/prompt.sh

# add home/bin path
export "PATH=$HOME/bin:$PATH"

# Vars
HISTFILE=~/.zsh_history
setopt inc_append_history # To save every command before it is executed
setopt share_history # setopt inc_append_history

# avoid duplicate entries in the zsh history (also good for fzf search)
setopt HIST_IGNORE_ALL_DUPS

# Aliases
alias v='eval $(command -v nvim)'
alias cp='cp -iv' # 'cp' prompt and verbose
alias mv='mv -iv' # 'mv' prompt and verbose
alias ll='ls -al'
alias la='ls -A'

mkdir -p /tmp/log

# Functions
# Custom cd (always ls when into a folder)
c() {
	cd $1;
	ls;
}
alias cd="c"

# Distraction free vim (Goyo plugin) with tmux window:
vg() {
	if [[ ! -z "$@" ]]; then
		tmux new-window -n "$@" nvim "$@" -c ":GoyoMode"
	else
		tmux new-window nvim -c ":GoyoMode"
	fi
	}


# ripgrep config file defined as an environment variable
# Source: https://github.com/BurntSushi/ripgrep/blob/0.8.0/GUIDE.md#configuration-file
export RIPGREP_CONFIG_PATH="$HOME"/.ripgreprc
# https://github.com/sharkdp/bat#configuration-file
export BAT_CONFIG_PATH="$HOME"/.batconf

# fzf (managed by fzf):
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Google Cloud platform (managed by the Google Cloud SDK)
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

