# References:
# - https://github.com/Parth/dotfiles/blob/master/zsh/prompt.sh

# load zsh colors:
autoload -U colors && colors

setopt PROMPT_SUBST

# Path: https://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/#s7-current-directory
prompt__pwd() {
  PS1+="%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}"
}


prompt__status_code() {
  PS1+='%(?.., %{$fg[red]%}%?%{$reset_color%})'
}


prompt__git_status() {
  if git rev-parse --is-inside-work-tree 2> /dev/null | grep -q 'true' ; then
    PS1+=', '
    PS1+="%{$fg[blue]%}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)%{$reset_color%}"
    if [ $(git status --short | wc -l) -gt 0 ]; then
      PS1+="%{$fg[red]%}+$(git status --short | wc -l | awk '{$1=$1};1')%{$reset_color%}"
    fi
  fi
}


# https://stackoverflow.com/questions/2704635/is-there-a-way-to-find-the-running-time-of-the-last-executed-command-in-the-shel
prompt__timer () {
  if [[ $_elapsed[-1] -ne 0 ]]; then
    PS1+=', '
    PS1+="%{$fg[magenta]%}$_elapsed[-1]s%{$reset_color%}"
  fi
}


prompt__pid() {
  if [[ $! -ne 0 ]]; then
    PS1+=', '
    PS1+="%{$fg[yellow]%}PID:$!%{$reset_color%}"
  fi
}


# https://superuser.com/questions/195781/sudo-is-there-a-command-to-check-if-i-have-sudo-and-or-how-much-time-is-left
prompt__sudo() {
  CAN_I_RUN_SUDO=$(sudo -n uptime 2>&1|grep "load"|wc -l)
  if [ ${CAN_I_RUN_SUDO} -gt 0 ]
  then
    PS1+=', '
    PS1+="%{$fg_bold[red]%}SUDO%{$reset_color%}"
  fi
}


# https://stackoverflow.com/questions/10406926/how-do-i-change-the-default-virtualenv-prompt
prompt__virtualenv() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    PS1+=', '
    PS1+="%{$fg[cyan]%}(%{${VIRTUAL_ENV##*/}%})%{$reset_color%}"
  fi
}


set_prompt() {

  PS1="%{$fg[white]%}[%{$reset_color%}"

  prompt__pwd         $PS1
  prompt__status_code $PS1
  prompt__git_status  $PS1
  prompt__timer       $PS1
  prompt__pid         $PS1
  prompt__sudo        $PS1
  prompt__virtualenv  $PS1

  PS1+="%{$fg[white]%}]: %{$reset_color%}% "

}

precmd_functions+=set_prompt

preexec () {
  (( ${#_elapsed[@]} > 1000 )) && _elapsed=(${_elapsed[@]: -1000})
  _start=$SECONDS
}

precmd () {
  (( _start >= 0 )) && _elapsed+=($(( SECONDS-_start )))
  _start=-1
}
