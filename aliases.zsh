
man () {
  /usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less)
}


#clear and flush scrollback on putty
alias clear="clear && printf '\033[3J'"
alias pip-upgrade="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
#
### DOcker Func
beet(){
  sudo docker run --rm -it \
    -e PUID=$(id -u beets) -e PGID=$(getent group beets | cut -d: -f3) \
    -v /mnt/raid/Bittorrent/Music:/mnt/raid/Bittorrent/Music:ro \
    -v /mnt/raid/Music:/mnt/raid/Music \
    -v ~/.config/beets:/config \
    lugoues/beets "$@"
}

# Safety {{{
  if [[ ${OSTYPE} == linux* ]]; then
    alias chmod='chmod --preserve-root -v'
    alias chown='chown --preserve-root -v'
  fi

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

# Git {{{
  if (( ${+commands[hub]} )); then
    eval "$(hub alias -s)"
  fi
#}}}

# ncdu
  if [ $+commands[ncdu] ]; then
    alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
  fi

# dfc
  if [ $+commands[dfc] ]; then
    if [[ ${OSTYPE} == linux* ]]; then
      alias df="dfc -Wwd -t btrfs -p '-*docker*' 2> /dev/null"
    fi

    if [[ ${OSTYPE} == darwin* ]]; then
      alias df="dfc -Wwdl 2> /dev/null"
    fi
  fi

# prettyping
  if [ $+commands[prettyping] ]; then
    alias ping="prettyping --nolegend"
  fi

# Misc {{{
  alias sudoedit='sudo -e'

  mkcd() {
    [[ -n ${1} ]] && mkdir -p ${1} && builtin cd ${1}
  }

  lsswap(){
    for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | less
  }

  if (( ${+commands[dpkg]} )); then
    alias kclean="sudo apt-get remove $(dpkg -l|egrep '^ii  linux-(im|he)'|awk '{print $2}'|grep -v `uname -r`)"
  fi

  hr() {
    autoload -U colors # black, red, green, yellow, blue, magenta, cyan, and white
    colors
    fg_color=${1:-blue}
    printf "$fg[${1:-blue}]%0.s─$fg[default]" $(seq 1 $(tput cols))
  }
#}}}


# Jira {{{
  if (( ${+commands[jira]} )); then
    jwla() {
      jira worklog add --noedit -T "$2" -m "${3:=.}" $1
    }
    jwlay() {
      jira worklog add --noedit -T "$2" -m "${3:=.}" -S "$(date +%Y-%m-%dT%T.00%z --date='yesterday')" $1
    }
  fi
#}}}

# fkill - kill process
  if (( ${+commands[fzf]} )); then
    fkill() {
      local pid
      pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

      if [ "x$pid" != "x" ]
      then
        echo $pid | xargs kill -${1:-9}
      fi
    }
fi

