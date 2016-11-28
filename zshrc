#
# User configuration sourced by interactive shells
#

# ZIM {{{
  if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
    source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
  fi
#}}}

# Path {{{
path=(
  ~/.ellipsis/bin
  ~/.local/bin/
  $path
)
#}}}

# Settings {{{
  #set history to largest possible
  HISTSIZE=9999
  SAVEHIST=9999
  setopt extendedhistory

  export CONCURRENCY_LEVEL=5
  export EDITOR=vim
  export CHEATCOLORS=true

  #disable auto correct
  unsetopt correct_all
#}}}

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

# Aliases {{{
  if [[ -s ${ZDOTDIR:-${HOME}}/.aliases.zsh ]]; then
    source ${ZDOTDIR:-${HOME}}/.aliases.zsh
  fi
# }}}
