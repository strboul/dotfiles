#!/usr/bin/env bash

# git log alias
alias gg="git log --graph --pretty=format:'%C(blue)%h%Creset%C(magenta)%d%Creset %C(bold)%s%Creset %C(yellow)<%an> %C(cyan)(%ci)%Creset' --abbrev-commit --date=iso"

# Fzf git-log (interactive)
# Source: https://gist.github.com/junegunn/f4fca918e937e6bf5bad
ggshow() {
	if [ ! -d .git ];then
		echo >&2 "No git repository found."
		return 0
	fi
	gg |
	     fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
		     --bind "ctrl-m:execute:
		             (grep -o '[a-f0-9]\{7\}' | head -1 |
		              xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
		              {}
 				     FZF-EOF"
}

