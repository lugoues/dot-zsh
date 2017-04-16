#
# User configuration sourced by interactive shells
#
# hack because people keep calling compinit when they shouldnt!
compinit() {

}

# zplug {{{
  export ZPLUG_HOME=$HOME/.zplug
  if [[ ! -f $ZPLUG_HOME/init.zsh ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
  fi

  source ~/.zplug/init.zsh

  zplug "zplug/zplug", hook-build:"zplug --self-manage"
  zplug "zimframework/zim", \
    as:plugin, \
    use:"init.zsh", \
    hook-build:"ln -sf $ZPLUG_ROOT/repos/zimframework/zim ~/.zim"
  zplug "rupa/z", use:z.sh
  zplug "changyuheng/fz"
  zplug "mafredri/zsh-async"
  zplug "sindresorhus/pure", use:"pure.zsh", as:theme, hook-load:"_pure_loader"
  zplug "zsh-users/zsh-history-substring-search", defer:3
  zplug "zsh-users/zsh-autosuggestions"
#}}}

# Paths {{{
  fpath=(
    $HOME/.ellipsis/comp
    $(brew --prefix)/share/zsh/site-functions
    $fpath
  )
  # autoload -U compinit; compinit

  path=(
    ~/.local/bin
    ~/.cargo/bin
    ~/.ellipsis/bin
    /usr/local/sbin
    /usr/local/bin
    $(brew --prefix &> /dev/null && echo $(brew --prefix)/opt/coreutils/libexec/gnubin)
    $([ -x /usr/libexec/path_helper ] && eval `/usr/libexec/path_helper -s | sed s/PATH/NPATH/g`; echo $NPATH);
    $path
  )
#}}}

[[ -s "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
[[ -f "~/.zshrc.local" ]] && source "$HOME/.zshrc.local"

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

# Borg {{{
  export BORG_RSH="ssh -x -i ~/.config/borg/borg_id_ed25519"
#}}}

# GPG {{{
  export GPG_TTY=$(tty)
#}}}

# FASD {{{
  # eval "$(fasd --init auto)"
  # alias j='fasd_cd -i'
#}}}

# Theme {{{
  export PURE_PROMPT_SYMBOL=λ

  _pure_loader() {
    zstyle ':vcs_info:git*' formats " `tput sitm`%b`tput ritm`" "x%R"
  }
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
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
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

# zplug load {{{
  if ! zplug check --verbose; then
    echo; zplug install
  fi
  zplug load #--verbose
#}}}

  fpath=(
    $HOME/.ellipsis/comp
    $(brew --prefix)/share/zsh/site-functions
    $fpath
  )


  unfunction compinit
  autoload -Uz compinit
  if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
  else
    compinit -C;
  fi;
