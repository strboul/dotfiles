# See more at `man zshmisc` (look under 'SIMPLE PROMPT ESCAPES')
#
# Test print stuff with e.g. `print -P %T`
#
# setopt prompt_subst

PROMPT=''

turquoise='%F{81}'
gray4='%F{240}'

{
  prompt__abspath() {
    # show absolute path with tilde
    echo "%B%{$turquoise%}%~%{$reset_color%}"
  }
  PROMPT+='$(prompt__abspath)'
}

{
  prompt__sudo() {
    # https://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
    local CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1 | grep "load" | wc -l)
    if [ ${CAN_I_RUN_SUDO} -gt 0 ]; then
      echo ", %{$fg_bold[red]%}SUDO%{$reset_color%}"
    else
      echo ""
    fi
  }
  PROMPT+='$(prompt__sudo)'
}

{
  prompt__status_code() {
    # return status code if it's non zero
    echo "%(?.., %{$fg[red]%}%?%{$reset_color%})"
  }
  PROMPT+='$(prompt__status_code)'
}

{
  prompt__git_info() {
    if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q "true" ; then
      echo -ne ", %{$fg[blue]%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{$reset_color%}"
      if [ "$(git status --short | wc -l)" -gt 0 ]; then
        echo -ne "%{$fg[yellow]%}+$(git status --short | wc -l | awk '{$1=$1};1')%{$reset_color%}"
      fi
      if [ "$(git stash list 2> /dev/null)" ]; then
        echo -ne "%{$fg[cyan]%}+$(git rev-list --walk-reflogs --count refs/stash)%{$reset_color%}"
      fi
    fi
  }
  PROMPT+='$(prompt__git_info)'
}

{
  prompt__timer () {
    # https://stackoverflow.com/questions/2704635/is-there-a-way-to-find-the-running-time-of-the-last-executed-command-in-the-shel
    if [[ $_elapsed[-1] -ne 0 ]]; then
      echo ", %{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
    fi
  }
  PROMPT+='$(prompt__timer)'
}

# end arrow
PROMPT+=' %{$gray4%}➜  %{$reset_color%}'
