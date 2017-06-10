#
# User configuration sourced by interactive shells
#
# hack because people keep calling compinit when they shouldnt!
compinit() {

}

# SET ZSH Cache directory
ZSH_CACHE_DIR=$HOME/.zcache
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR


# zplug {{{
  export ZPLUG_HOME=$HOME/.zplug
  if [[ ! -f $ZPLUG_HOME/init.zsh ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
  fi

  source ~/.zplug/init.zsh

  zplug "zplug/zplug", hook-build:"zplug --self-manage"
  # zplug "b4b4r07/enhancd", use:init.sh
  zplug "zimframework/zim", \
    as:plugin, \
    use:"init.zsh", \
    hook-build:"ln -sf $ZPLUG_ROOT/repos/zimframework/zim ~/.zim"
  # zplug "changyuheng/fz"
  # zplug "rupa/z", use:z.sh
  zplug "mafredri/zsh-async"
  zplug "sindresorhus/pure", use:"pure.zsh", as:theme, hook-load:"_pure_loader"
  zplug "zsh-users/zsh-history-substring-search", defer:3
  # zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2

  zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"
  zplug "junegunn/fzf", as:plugin,  use:"shell/*.zsh", defer:3
  zplug "nicodebo/base16-fzf", use:"build_scheme/base16-tomorrow-night.config"
  zplug "jhawthorn/fzy", as:command, hook-build:"make"

  zplug "supercrabtree/k"
  # zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

  zplug "chriskempson/base16-shell", use:"scripts/base16-tomorrow-night.sh", defer:0, if:"[[ $+ITERM_PROFILE ]]"

  zplug "paulirish/git-open", as:plugin

#}}}

# Paths {{{
  fpath=(
    $HOME/.ellipsis/comp
    $( (( $+command[brew] )) && echo $(brew --prefix)/share/zsh/site-functions)
    $fpath
  )
  # autoload -U compinit; compinit

  path=(
    ~/.local/bin
    ~/.cargo/bin
    ~/.ellipsis/bin
    ~/.zplug/bin
    /usr/local/sbin
    /usr/local/bin
    $( (( $+command[brew] )) && echo $(brew --prefix)/opt/coreutils/libexec/gnubin)
    $([ -x /usr/libexec/path_helper ] && eval `/usr/libexec/path_helper -s | sed s/PATH/NPATH/g`; echo $NPATH);
    $path
  )
#}}}

[[ -s "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

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
  export EDITOR=nvim
  export CHEATCOLORS=true

  #disable auto correct
  unsetopt correct_all
#}}}

bindkey '^R' history-incremental-search-backward

# Borg {{{
  export BORG_RSH="ssh -x -i ~/.config/borg/borg_id_ed25519"
#}}}

# GPG {{{
  export GPG_TTY=$(tty)
#}}}

# fzf {{{
  # bind -x '"\C-p": vim $(fzf);'
  if [ $+commands[fzf] ]; then
    if [ $+command[rg] ]; then
      export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" 2> /dev/null'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    [[ $+command[bfs] ]] && \
      export FZF_ALT_C_COMMAND="bfs -type d -nohidden"

    export FZF_TMUX=true
    # funcs
    z() {
      local dir
      dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
    }
    v() {
      local file
      file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && $EDITOR "${file}" || return 1
    }

    # aliases
    alias j=z
    alias jj=zz
  fi
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
[[ -s "$HOME/.local/share/marker/marker.sh" ]] \
  && source "$HOME/.local/share/marker/marker.sh"

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

# Set function paths
  fpath=(
    $HOME/.ellipsis/comp
    $(brew --prefix)/share/zsh/site-functions
    $( (( $+commands[brew] )) && echo "$(brew --prefix)/share/zsh/site-functions")
    $fpath
  )

  unfunction compinit
  autoload -Uz compinit
  if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit -u ;
  else
    compinit -C;
  fi;
  # if [[ -n $${ZSH_CACHE_DIR}/zcompcache(#qN.mh+24) ]]; then
  #   compinit -d ${ZSH_CACHE_DIR}/zcompcache
  # else
  #   compinit -C -d ${ZSH_CACHE_DIR}/zcompcache
  # fi;
