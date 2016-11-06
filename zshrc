#
# User configuration sourced by interactive shells
#

# ZIM {{{
  if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
    source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
  fi
#}}}

source ~/.aliases
path=(
  ~/.ellipsis/bin
  ~/.local/bin/
  $path
)

# GPG {{{
  export GPG_TTY=$(tty)
#}}}

# FASD {{{
  eval "$(fasd --init auto)"
  alias j='fasd_cd -i'
#}}}

# Prompt {{{
  # Make branch italic
  zstyle ':vcs_info:git*' formats " `tput sitm`%b`tput ritm`" "x%R"
#}}}
