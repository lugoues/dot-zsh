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
  zplug "zimframework/zim", \
    as:plugin, \
    use:"init.zsh", \
    hook-build:"ln -sf $ZPLUG_ROOT/repos/zimframework/zim ~/.zim"
  # zplug "changyuheng/fz"
  # zplug "rupa/z", use:z.sh
  zplug "whjvenyl/fasd", as:command
  zplug "mafredri/zsh-async"
  zplug "sindresorhus/pure", use:"pure.zsh", as:theme, hook-load:"_pure_loader"
  zplug "zsh-users/zsh-history-substring-search", defer:3
  # zplug "zsh-users/zsh-autosuggestions"
  # zplug "zsh-users/zsh-syntax-highlighting", defer:2

  zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"
  # zplug "junegunn/fzf-bin", as:command, from:gh-r, file:fzf, of:"*${(L)$(uname -s)}*amd64*"
  zplug "junegunn/fzf", as:plugin,  use:"shell/*.zsh", defer:3
  zplug "nicodebo/base16-fzf", use:"bash/base16-tomorrow-night.config"
  zplug "jhawthorn/fzy", as:command, hook-build:"make"

  zplug "supercrabtree/k"
  zplug "chriskempson/base16-shell", use:"scripts/base16-tomorrow-night.sh", defer:0, if:"[[ $+ITERM_PROFILE ]]"

  zplug "tarrasch/zsh-functional", as:plugin
  zplug "Tarrasch/zsh-bd", as:plugin
  zplug "zdharma/fast-syntax-highlighting", as:plugin

  # zplug "liangguohuan/fzf-marker", as:plugin, use: "fzf-marker.plugin.zsh"
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
    /usr/local/opt/curl/bin
    /usr/local/opt/openssl/bin
    /usr/local/sbin
    /usr/local/bin
    # $(brew --prefix)/opt/coreutils/libexec/gnubin
    $( (( $+commands[brew] )) && echo "$(brew --prefix)/opt/coreutils/libexec/gnubin")
    $([ -x /usr/libexec/path_helper ] && eval `/usr/libexec/path_helper -s | sed s/PATH/NPATH/g`; echo $NPATH);
    /Applications/Visual Studio Code.app/Contents/Resources/app/bin
    $path
  )

export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export GROOVY_HOME=/usr/local/opt/groovy/libexec
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
  setopt completeinword   # save each commands beginning timestamp and the duration to the history file
  setopt hash_list_all  # save each commands beginning timestamp and the duration to the history file

  export CONCURRENCY_LEVEL=5
  export EDITOR=nvim
  export CHEATCOLORS=true
  # export XDG_CONFIG_HOME=~/.config
  export HISTORY_IGNORE="(bg|fg|cd*|rm*|clear|ls|pwd|history|exit|make*|* --help|ll|la|jrnl *)"

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

# fasd {{{
  if [ $commands[fasd] ]; then
    eval "$(fasd --init auto)"

    alias j=z
    unalias sf
  fi
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

    [[ $+command[fd] ]] && \
      export FZF_ALT_C_COMMAND="fd -t d ."
    export FZF_TMUX=true

    if [ $commands[fasd] ]; then
      jj() {
        local dir
        dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
      }
      v() {
        local file
        file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && $EDITOR "${file}" || return 1
      }
    fi

    if [ $+command[rg] ]; then
      sf() {
        if [ "$#" -lt 1 ]; then echo "Supply string to search for!"; return 1; fi
        printf -v search "%q" "$*"
        # include="yml,js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst"
        # exclude=".config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist"
        # rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" -g "*.{'$include'}" -g "!{'$exclude'}/*"'
        # files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}'`
        rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always"'
        files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}'`
        [[ -n "$files" ]] && ${EDITOR:-vim} $files
      }
    fi

    # if [ $+commands[marker] ]; then
    #   _fzf_marker_main_widget() {
    #     if echo "$BUFFER" | grep -q -P "{{"; then
    #       _fzf_marker_placeholder
    #     else
    #       local selected
    #       if selected=$(cat ${FZF_MARKER_CONF_DIR:-~/.local/share/marker}/*.txt |
    #         sed -e "s/\(^[a-zA-Z0-9_-]\+\)\s/${FZF_MARKER_COMMAND_COLOR:-\x1b[38;5;255m}\1\x1b[0m /" \
    #             -e "s/\s*\(#\+\)\(.*\)/${FZF_MARKER_COMMENT_COLOR:-\x1b[38;5;8m}  \1\2\x1b[0m/" |
    #         fzf --bind 'tab:down,btab:up' --height=80% --ansi -q "$LBUFFER"); then
    #         LBUFFER=$(echo $selected | sed 's/\s*#.*//')
    #       fi
    #       zle redisplay
    #     fi
    #   }

    #   _fzf_marker_placeholder() {
    #     local strp pos placeholder
    #     strp=$(echo $BUFFER | grep -Z -P -b -o "\{\{[\w]+\}\}")
    #     strp=$(echo "$strp" | head -1)
    #     pos=$(echo $strp | cut -d ":" -f1)
    #     placeholder=$(echo $strp | cut -d ":" -f2)
    #     if [[ -n "$1" ]]; then
    #       BUFFER=$(echo $BUFFER | sed -e "s/{{//" -e "s/}}//")
    #       CURSOR=$(($pos + ${#placeholder} - 4))
    #     else
    #       BUFFER=$(echo $BUFFER | sed "s/$placeholder//")
    #       CURSOR=pos
    #     fi
    #   }

    #   _fzf_marker_placeholder_widget() { _fzf_marker_placeholder "defval" }

    #   zle -N _fzf_marker_main_widget
    #   zle -N _fzf_marker_placeholder_widget
    #   bindkey "${FZF_MARKER_MAIN_KEY:-\C-@}" _fzf_marker_main_widget
    #   bindkey "${FZF_MARKER_PLACEHOLDER_KEY:-\C-v}" _fzf_marker_placeholder_widget
    # fi
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
# [[ -s "$HOME/.local/share/marker/marker.sh" ]] \
#   && source "$HOME/.local/share/marker/marker.sh"

# Custom Term
alias ssh='TERM=xterm-256color ssh'
alias brew='TERM=xterm-256color brew'
alias cmus='cmus_tmux -n music cmus'
alias tmux='TERM=xterm-256color tmux'

alias pbdecrypt="pbpaste  | gpg -d | pbcopy"
alias pbencrypt="pbpaste | gpg -e --armor | pbcopy"
#jira
# alias jwla='jira worklogadd '
# alias jwlay='jira worklogadd -s $(/bin/date -v-1d +%m/%d/%y) '

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

customize_vcs_info() {
  zstyle ':vcs_info:git*' formats " `tput sitm`%b`tput ritm`" "x%R"
}

# prompt_pure_async_vcs_info() {
#   setopt localoptions noshwordsplit
#   builtin cd -q $1 2>/dev/null


#   user_vcs_info
#   command echo "testinside"
#   vcs_info

#   local -A info
#   info[top]=$vcs_info_msg_1_
#   info[branch]=$vcs_info_msg_0_

#   print -r - ${(@kvq)info}
# }

# prompt_pure_async_tasks() {
#   setopt localoptions noshwordsplit

#   # initialize async worker
#   ((!${prompt_pure_async_init:-0})) && {
#     async_start_worker "prompt_pure" -u -n
#     async_register_callback "prompt_pure" prompt_pure_async_callback
#     prompt_pure_async_init=1
#   }

#   typeset -gA prompt_pure_vcs_info

#   local -H MATCH
#   if ! [[ $PWD =~ ^$prompt_pure_vcs_info[pwd] ]]; then
#     # stop any running async jobs
#     async_flush_jobs "prompt_pure"

#     # reset git preprompt variables, switching working tree
#     unset prompt_pure_git_dirty
#     unset prompt_pure_git_last_dirty_check_timestamp
#     unset prompt_pure_git_arrows
#     unset prompt_pure_git_fetch_pattern
#     prompt_pure_vcs_info[branch]=
#     prompt_pure_vcs_info[top]=
#   fi
#   unset MATCH

#   async_job "prompt_pure" prompt_pure_async_vcs_info $PWD

#   # # only perform tasks inside git working tree
#   [[ -n $prompt_pure_vcs_info[top] ]] || return

#   prompt_pure_async_refresh
# }
