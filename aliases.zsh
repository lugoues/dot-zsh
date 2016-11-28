
man () {
  /usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less)
}


#clear and flush scrollback on putty
alias clear="clear && printf '\033[3J'"

alias pip-upgrade="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

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
  if type "docker" > /dev/null; then
    alias dlog="sudo docker logs -f"
    alias dps="sudo docker ps"
    alias dstart="sudo docker start "
    alias dstop="sudo docker stop -t 6000"
    dbash() { sudo docker exec -it $1 bash; }
  fi
#}}}

# ls {{{
  # GNU
  if [[ -s ${HOME}/.dir_colors ]]; then
    eval "$(dircolors --sh ${HOME}/.dir_colors)"
  else
    eval "$(dircolors --sh)"
  fi

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

# Git {{{
  if (( ${+commands[hub]} )); then
    eval "$(hub alias -s)"
  fi
#}}}


# Misc {{{
  alias du='du -kh'

  mkcd() {
    [[ -n ${1} ]] && mkdir -p ${1} && builtin cd ${1}
  }

  lsswap(){
    for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | less
  }

  if (( ${+commands[dpkg]} )); then
    alias kclean="sudo apt-get remove $(dpkg -l|egrep '^ii  linux-(im|he)'|awk '{print $2}'|grep -v `uname -r`)"
  fi

  if (( ${+commands[dfc]} )); then
    alias df="dfc -Wwd -t btrfs -p '-*docker*' 2> /dev/null"
  fi
#}}}
