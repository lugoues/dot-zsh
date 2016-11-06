

#
# User configuration sourced by interactive shells
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

source ~/.aliases
path=(
  ~/.ellipsis/bin
  ~/.local/bin/
  $path
)

export GPG_TTY=$(tty)

eval "$(fasd --init auto)"

# Aliases
alias j='fasd_cd -i'


# Prompt
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL=λ
prompt pure
