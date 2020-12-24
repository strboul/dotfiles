# zsh keybindings

# ls
ctrl_l() {
  BUFFER="ls"
  zle accept-line
}
zle -N ctrl_l
bindkey "^l" ctrl_l


# git status
#
# If 'git status' command doesn't work (i.e. returning a status code of 128),
# call 'git-substatus' (https://github.com/strboul/git-substatus) instead.
ctrl_s() {

  if git status >/dev/null ; then
    BUFFER="git status"
  else
    if git-substatus >/dev/null ; then
      BUFFER="git-substatus"
    fi
  fi

  zle accept-line
}
zle -N ctrl_s
bindkey "^s" ctrl_s


# Add all git-tracked & commit & push
ctrl_g() {

  if [ -n "$BUFFER" ]; then
    BUFFER="git add -u; git commit -m \"$BUFFER\" && git push"
  fi

  if [ -z "$BUFFER" ]; then
    BUFFER="git add -u; git commit && git push"
  fi

  zle accept-line
}
zle -N ctrl_g
bindkey "^g" ctrl_g
