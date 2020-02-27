
alias df='df -h'
alias du='du -h'

# If GNU
if (( ${+commands[dircolors]} )); then
# Always wear a condom
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
fi

# safe-rm
if (( ${+commands[safe-rm]} && ! ${+commands[safe-rmdir]} )); then
  alias rm='safe-rm'
fi

# sudoedit
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

# prettyping
if (( $+commands[prettyping] )); then
  alias ping="prettyping --nolegend"
fi

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

# nvim {{{
if (( ${+commands[nvim]} )); then
  alias vim=nvim
fi
#}}}

# GPG Clipboard {{{
  alias pbdecrypt="pbpaste  | gpg -d | pbcopy"
  alias pbencrypt="pbpaste | gpg -e --armor | pbcopy"
#}}}

function hr {
  autoload -U colors # black, red, green, yellow, blue, magenta, cyan, and white
  colors
  fg_color=${1:-blue}
  printf "$fg[${1:-blue}]%0.s─$fg[default]" $(seq 1 $(tput cols))
}

if [ $commands[fasd] ]; then
  alias j="fasd_cd -d"
fi

lsswap(){
  for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | less
}

man () {
  /usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less)
}

mkcd() {
  [[ -n ${1} ]] && mkdir -p ${1} && builtin cd ${1}
}


  if [ $commands[fasd] ]; then
    v() {
      local file
      file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && $EDITOR "${file}" || return 1
    }
  fi

# Set pager
if (( ! ${+PAGER} )); then
  if (( ${+commands[less]} )); then
    export PAGER=less
  else
    export PAGER=more
  fi
fi

# exa {{{
  if [ $commands[exa] ]; then
    alias ls='exa'                                                         # ls
    alias l='exa -lbF --git'                                               # list, size, type, git
    alias ll='exa -lbF --git'                                              # long list
    alias llm='exa -lbGF --git --sort=modified'                            # long list, modified date sort
    alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
    alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

    # speciality views
    alias lS='exa -1'                                                       # one column, just names
    alias lt='exa --tree --level=2'
    alias xtree='exa -lhT --git --color always | less -r'
  fi
#}}}

# Properly clear in dawrwin
if [[ ${OSTYPE} == darwin* ]]; then
  function clear { /usr/bin/clear && printf '\e[3J'; }
fi