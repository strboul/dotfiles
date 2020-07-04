
# Source: https://github.com/Parth/dotfiles/blob/master/zsh/keybindings.sh

# Add all & commit & push
ctrl_g() {
	if [ -n "$BUFFER" ]; then
		BUFFER="git add -A; git commit -m \"$BUFFER\" && git push"
	fi

	if [ -z "$BUFFER" ]; then
		BUFFER="git add -A; git commit -v && git push"
	fi

	zle accept-line
}
zle -N ctrl_g
bindkey "^g" ctrl_g

# ls
ctrl_l() {
	BUFFER="ls"
	zle accept-line
}
zle -N ctrl_l
bindkey "^l" ctrl_l


# git status
## if 'git status' command fails (i.e. returns a status
## code 128), call 'git-substatus' instead.
## 'git-substatus' project: https://github.com/strboul/git-substatus
ctrl_s() {
	if git status >/dev/null ; then
		BUFFER="git status"
	else
		BUFFER="git-substatus"
	fi
	zle accept-line
}
zle -N ctrl_s
bindkey "^s" ctrl_s


