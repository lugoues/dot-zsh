
# nvim {{{
if (( ${+commands[nvim]} )); then
  alias vim=nvim
fi
#}}}

# Safety {{{
  if (( ${+commands[safe-rm]} )); then
    alias rm='safe-rm'
  fi
#}}}


# Docker {{{
  if [[ `uname` == 'Linux' ]]
  then
    docker_prefix=sudo
  fi

  if type "docker" > /dev/null; then
    alias dlog="$prefix docker logs -f"
    alias dps="$prefix docker ps"
    alias dstart="$prefix docker start "
    alias dstop="$prefix docker stop -t 6000"
    alias drun="$prefix docker run --rm -it"
    dbash() { $prefix docker exec -it $1 bash; }
  fi
#}}}


# ls {{{
  # GNU
  # if [[ -s ${HOME}/.dir_colors ]]; then
    # eval "$(dircolors --sh ${HOME}/.dir_colors)"
  # else
    # eval "$(dircolors --sh)"
  # fi

  alias ls='ls --group-directories-first --color=auto'
  alias l='ls -lAh'         # all files, human-readable sizes
  alias lm="l | ${PAGER}"   # all files, human-readable sizes, use pager
  alias ll='ls -lh'         # human-readable sizes
  alias lr='ll -R'          # human-readable sizes, recursive
  alias lx='ll -XB'         # human-readable sizes, sort by extension (GNU only)
  alias lk='ll -Sr'         # human-readable sizes, largest last
  alias lt='ll -tr'         # human-readable sizes, most recent last
  alias lc='lt -c'          # human-readable sizes, most recent last, change time
#}}}

# exa {{
alias xtree='exa -lhT --git'
#}}}

# ncdu
if (( $+commands[ncdu] )); then
    alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
  fi

# dfc
if (( $+commands[dfc] )); then
  if [[ ${OSTYPE} == linux* ]]; then
    alias df="dfc -Wwd -t btrfs -p '-*docker*' 2> /dev/null"
  fi

  if [[ ${OSTYPE} == darwin* ]]; then
    alias df="dfc -Wwdl 2> /dev/null"
  fi
fi

# prettyping
if (( $+commands[prettyping] )); then
  alias ping="prettyping --nolegend"
fi

# Misc {{{
if (( ! ${+commands[sudoedit]} )); then
  alias sudoedit='sudo -e'
fi


# fkill - kill process
if (( $+commands[fzf] )); then
  fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
      echo $pid | xargs kill -${1:-9}
    fi
  }
fi

# psgrep -
alias psgrep="ps -ef | grep"


if (( ${+commands[dpkg]} )); then
  alias kclean="sudo apt-get remove $(dpkg -l|egrep '^ii  linux-(im|he)'|awk '{print $2}'|grep -v `uname -r`)"
fi
