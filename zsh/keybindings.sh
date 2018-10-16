
# git
# Source: https://github.com/Parth/dotfiles/blob/master/zsh/keybindings.sh
	git_prepare() {
		if [ -n "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -m \"$BUFFER\" && git push"
		fi

		if [ -z "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -v && git push"
		fi

		zle accept-line
	}
	zle -N git_prepare
	bindkey "^g" git_prepare

# ls
	ctrl_l() {
		BUFFER="ls"
		zle accept-line
	}
	zle -N ctrl_l
	bindkey "^l" ctrl_l

# git status
	git_stus() {
		BUFFER="git status"
		zle accept-line
	}
	zle -N git_stus
	bindkey "^s" git_stus
