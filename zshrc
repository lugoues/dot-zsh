#
# User configuration sourced by interactive shells
#

# ZIM {{{
  if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
    source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
  fi
#}}}

# Fpath {{{
  fpath=(
    $HOME/.ellipsis/comp
    /usr/local/share/zsh-completions
    $fpath
)
  autoload -U compinit; compinit
# }}}

# Path {{{
# Load path_helper for OSX
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

path=(
  ~/.local/bin
  ~/.cargo/bin
  ~/.ellipsis/bin
  $(brew --prefix &> /dev/null && echo $(brew --prefix)/opt/coreutils/libexec/gnubin)
  $path
)
#}}}
[[ -s "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Settings {{{
  #set history to largest possible
  HISTSIZE=9999
  SAVEHIST=9999
  setopt extendedhistory
  setopt hist_save_no_dups
  setopt hist_ignore_all_dups
	setopt completeinword   # save each command's beginning timestamp and the duration to the history file
	setopt hash_list_all  # save each command's beginning timestamp and the duration to the history file

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
  export PURE_PROMPT_SYMBOL=λ
  zstyle ':vcs_info:git*' formats " `tput sitm`%b`tput ritm`" "x%R"
#}}}

# Aliases {{{
  if [[ -s ${ZDOTDIR:-${HOME}}/.aliases.zsh ]]; then
    source ${ZDOTDIR:-${HOME}}/.aliases.zsh
  fi
# }}}

#marker
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# Custom Term
alias ssh='TERM=xterm-256color ssh'
alias brew='TERM=xterm-256color brew'
alias cmus='cmus_tmux -n music cmus'
alias tmux='TERM=xterm-256color tmux'

alias pbdecrypt="pbpaste  | gpg2 -d | pbcopy"
alias pbencrypt="pbpaste | gpg2 -e --armor | pbcopy"
#jira
alias jwla='jira worklogadd '
alias jwlay='jira worklogadd -s $(/bin/date -v-1d +%m/%d/%y) '

alias nv='nvim'
alias vim='nvim'

# AWS Helpers{{{
  aws-k () {
    local validkey;
    validkey=$(grep -l "^${argv[1]}$" ~/.aws/aws-keychain.list)
    if [[ -z $validkey ]]; then
      echo "You must pass in a valid aws keychain alias"
      echo "Take a look in ~/.aws/aws-keychain.list for valid options"
      echo "Or add your keychain via aws-keychain add"
      return
    fi
    aws-keychain exec $argv[1] aws ${argv:2}
  }


  aws-l () {
    aws-lpass exec $argv[1] aws ${argv:2}
  }
#}}}



# fzf {{{
  # [ -f ~/.fzf.bash ] && source ~/.fzf.bash
  # export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
  # bind -x '"\C-p": vim $(fzf);'
#}}}
#

# pyenv {{{
  export PYENV_ROOT=~/.local/share/pyenv
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  if (( $+commands[pyenv] )) ; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
#}}}


# rbenv {{{
  export rvm_path=~/.local/share/rvm
  export PATH="$PATH:$HOME/.rvm/bin"
  if (( $+commands[rvm] )) ; then
  fi
#}}}
