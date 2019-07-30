
hr() {
  autoload -U colors # black, red, green, yellow, blue, magenta, cyan, and white
  colors
  fg_color=${1:-blue}
  printf "$fg[${1:-blue}]%0.s─$fg[default]" $(seq 1 $(tput cols))
}

