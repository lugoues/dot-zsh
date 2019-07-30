
man () {
  /usr/bin/man $@ || (help $@ 2> /dev/null && help $@ | less)
}

mkcd() {
  [[ -n ${1} ]] && mkdir -p ${1} && builtin cd ${1}
}
