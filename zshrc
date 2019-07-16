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
  # export ZPLUG_HOME=$HOME/.zplug
  # if [[ ! -f $ZPLUG_HOME/init.zsh ]]; then
    # git clone https://github.com/zplug/zplug $ZPLUG_HOME
  # fi

  source ~/.zplug/init.zsh
  # source ~/.purepower
    zstyle ':vcs_info:git*' formats " `tput sitm`%b`tput ritm`" "x%R"

  zplug "zplug/zplug", hook-build:"zplug --self-manage"
  # ZIM_HOME="$ZPLUG_REPOS/zimfw/zimfw"
  # zplug "zimfw/zimfw", depth:1
  zplug "whjvenyl/fasd", as:command
  zplug "mafredri/zsh-async"
  zplug "sindresorhus/pure", use:"pure.zsh", as:theme, hook-load:"_pure_loader"
  # zplug romkatv/powerlevel10k, use:powerlevel10k.zsh-theme
  # zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2

  zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/fzf"
  zplug "junegunn/fzf", as:plugin,  use:"shell/*.zsh", defer:3
  zplug "nicodebo/base16-fzf", use:"bash/base16-tomorrow-night.config"
  # zplug "jhawthorn/fzy", as:command, hook-build:"make"

  # zplug "changyuheng/fz", defer:1
  zplug "wookayin/fzf-fasd"


  zplug "supercrabtree/k"
  zplug "chriskempson/base16-shell", use:"scripts/base16-tomorrow-night.sh", defer:0, if:"[[ $+ITERM_PROFILE ]]"

  zplug "tarrasch/zsh-functional", as:plugin
  # zplug "Tarrasch/zsh-bd", as:plugin
  zplug "zdharma/fast-syntax-highlighting", as:plugin
  # zplug 'zdharma/fast-syntax-highlighting'
  # zplug "zdharma/fast-syntax-highlighting", defer:2
  zplug "zsh-users/zsh-history-substring-search", defer:3
  zplug "zsh-users/zsh-completions"

  # zplug "liangguohuan/fzf-marker", as:plugin, use: "fzf-marker.plugin.zsh"
#}}}


# Zim {{{
# zmodules=(
  # directory
  # environment
  # git
  # input -- this might be helpful?
  # utility
  # meta
  # custom
  # ssh
  # history
  # archive
  # spectrum
  # syntax-highlighting
  # history-substring-search
  # prompt
  # completion
  # )
#}}}


# Paths {{{
  fpath=(
    $HOME/.ellipsis/comp
    $( (( $+command[brew] )) && echo $(brew --prefix)/share/zsh/site-functions)
    $fpath
  )
  # autoload -U compinit; compinit
  export GOPATH=$HOME/.local/share/go
  path=(
    ~/.local/bin
    ~/.local/share/go/bin
    ~/.cargo/bin
    ~/.ellipsis/bin
    ~/.zplug/bin
    ~/.local/share/pyenv/bin
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

# Theme {{{
  export PURE_PROMPT_SYMBOL=λ

  _pure_loader() {
    zstyle ':vcs_info:git*' formats " `tput sitm`%b`tput ritm`" "x%R"
  }
#}}}

bindkey '^R' history-incremental-search-backward


# zplug load {{{
  if ! zplug check --verbose; then
    echo; zplug install
  fi
  zplug load #--verbose
#}}}

[[ -s "/usr/libexec/java_home" ]] && export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

export GROOVY_HOME=/usr/local/opt/groovy/libexec
#}}}

[[ -s "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"


# Pager {{{
  if (( ${+commands[less]} )); then
    export PAGER=less
  else
    export PAGER=more
  fi
#}}}

# Borg {{{
  export BORG_RSH="ssh -x -i ~/.config/borg/borg_id_ed25519"
#}}}

# GPG {{{
  export GPG_TTY=$(tty)
#}}}

# fasd {{{
  if [ $commands[fasd] ]; then
    eval "$(fasd --init auto)"

    alias j="fasd_cd -d"
    unalias sf
    # unalias z
    # unalias j
  fi
#}}}

# fzf {{{
  # bind -x '"\C-p": vim $(fzf);'
  if [ $+commands[fzf] ]; then
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --height 40% --border"

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
      # jj() {
      #   local dir
      #   dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
      # }
      v() {
        local file
        file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && $EDITOR "${file}" || return 1
      }
      # j() {
      #   [ $# -gt 0 ] && fasd_cd -d "$*" && return
      #   local dir
      #   dir="$(fasd -Rdl "$1" | fzf  --bind 'shift-tab:up,tab:down' -1 -0 --no-sort +m)" && cd "${dir}" || return 1
      # }
    fi

    if [ $+command[rg] ]; then
      sf() {
        if [ "$#" -lt 1 ]; then echo "Supply string to search for!"; return 1; fi
        printf -v search "%q" "$*"
        # include="yml,js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst"
        # exclude=".config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist"
        # rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" -g "*.{'$include'}" -g "!{'$exclude'}/*"'
        # files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}'`
        rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" 2> /dev/null'
        files=`eval $rg_command $search | fzf --height 40% --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}' 2> /dev/null`
        [[ -n "$files" ]] && ${EDITOR:-vim} $files
      }
    fi

    function cdf {
      local file dir
      file=$(fzf-tmux --height 40% +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
    }

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




# Settings {{{
  # History Settings
  export HISTFILE=~/.zhistory

  HISTSIZE=10000000 # The maximum number of events stored in the internal history list and in the history file.
  SAVEHIST=10000000 # The maximum number of events stored in the internal history list and in the history file.

  setopt BANG_HIST # Perform textual history expansion, csh-style, treating the character ‘!’ specially.
  setopt SHARE_HISTORY # This option both imports new commands from the history file, and also causes your typed commands to be appended to the history file
  setopt HIST_IGNORE_DUPS # Do not enter command lines into the history list if they are duplicates of the previous event.
  setopt HIST_IGNORE_ALL_DUPS # If a new command line being added to the history list duplicates an older one, remove the older one
  setopt HIST_IGNORE_SPACE # Remove command lines from the history list when the first character on the line is a space
  setopt HIST_SAVE_NO_DUPS # When writing out the history file, older commands that duplicate newer ones are omitted.
  setopt HIST_VERIFY # show command with history expansion to user before running it
  setopt HIST_REDUCE_BLANKS
  setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
  setopt INC_APPEND_HISTORY     # add commands to HISTFILE in order of execution
  setopt COMPLETEINWORD   # save each commands beginning timestamp and the duration to the history file
  setopt HASH_LIST_ALL  # save each commands beginning timestamp and the duration to the history file
  setopt EXTENDEDHISTORY
  HISTORY_IGNORE="(bg|fg|cd*|rm*|clear|ls|pwd|history|exit|make*|* --help|ll|la|jrnl *)"

  export THEOS=~/.local/share/theos
  export CONCURRENCY_LEVEL=5
  export EDITOR=nvim
  export CHEATCOLORS=true
  # export XDG_CONFIG_HOME=~/.config

  #disable auto correct
  unsetopt correct_all

  # Directory Settings
  setopt AUTO_CD # If a command is issued that can’t be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory.
  setopt AUTO_PUSHD # Make cd push the old directory onto the directory stack.
  setopt PUSHD_IGNORE_DUPS # Don’t push multiple copies of the same directory onto the directory stack.
  setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.
  setopt PUSHD_TO_HOME # Have pushd with no arguments act like ‘pushd ${HOME}’.


  # Environment Settings
  # Use smart URL pasting and escaping.
  autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
  autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

  setopt AUTO_RESUME # Treat single word simple commands without redirection as candidates for resumption of an existing job.
  setopt INTERACTIVE_COMMENTS # Allow comments starting with `#` even in interactive shells.
  setopt LONG_LIST_JOBS # List jobs in the long format by default.
  setopt NOTIFY # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
  setopt NO_BG_NICE # Prevent runing all background jobs at a lower priority.

  # Prevent reporting the status of background and suspended jobs before exiting a shell with job control.
  # NO_CHECK_JOBS is best used only in combination with NO_HUP, else such jobs will be killed automatically.
  setopt NO_CHECK_JOBS

  setopt NO_HUP # Prevent sending the HUP signal to running jobs when the shell exits.

  # Remove path separtor from WORDCHARS.
  WORDCHARS=${WORDCHARS//[\/]}

  # Completion Settings
  setopt ALWAYS_TO_END # If a completion is performed with the cursor within a word, and a full completion is inserted, the cursor is moved to the end of the word.
  setopt PATH_DIRS # Perform a path search even on command names with slashes in them.
  setopt NO_CASE_GLOB # Make globbing (filename generation) not sensitive to case.
  setopt NO_LIST_BEEP # Don't beep on an ambiguous completion.


# Zsh Syntax Highlighting Settings {{{
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# zhighlighters=(main brackets pattern cursor)
#}}}

# Zsh Completion Settings {{{
  # group matches and describe.
  zstyle ':completion:*:*:*:*:*' menu select
  zstyle ':completion:*:matches' group yes
  zstyle ':completion:*:options' description yes
  zstyle ':completion:*:options' auto-description '%d'
  zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
  zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
  zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
  zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
  zstyle ':completion:*' format '%F{yellow}-- %d --%f'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

  # directories
  if (( ! ${+LS_COLORS} )); then
    # Locally use same LS_COLORS definition from utility module, in case it was not set
    local LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
  fi
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
  zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
  zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'expand'
  zstyle ':completion:*' squeeze-slashes true

  # enable caching
  zstyle ':completion::complete:*' use-cache on
  zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-${HOME}}/.zcompcache"

  # ignore useless commands and functions
  zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

  # completion sorting
  zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

  # Man
  zstyle ':completion:*:manuals' separate-sections true
  zstyle ':completion:*:manuals.(^1*)' insert-sections true

  # history
  zstyle ':completion:*:history-words' stop yes
  zstyle ':completion:*:history-words' remove-all-dups yes
  zstyle ':completion:*:history-words' list false
  zstyle ':completion:*:history-words' menu yes

  # ignore multiple entries.
  zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
  zstyle ':completion:*:rm:*' file-patterns '*:all-files'

  # If the _my_hosts function is defined, it will be called to add the ssh hosts
  # completion, otherwise _ssh_hosts will fall through and read the ~/.ssh/config
  zstyle -e ':completion:*:*:ssh:*:my-accounts' users-hosts \
    '[[ -f ${HOME}/.ssh/config && ${key} == hosts ]] && key=my_hosts reply=()'
#}}}

## Dircolors {{{
if (( $+commands[dircolors] )) ; then
  eval $(dircolors)
fi
#}}}

#
# Globbing and fds
#

# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.
# (An initial unquoted ‘~’ always produces named directory expansion.)
setopt EXTENDED_GLOB

# Perform implicit tees or cats when multiple redirections are attempted.
setopt MULTIOS

# Disallow ‘>’ redirection to overwrite existing files.
# ‘>|’ or ‘>!’ must be used to overwrite a file.
setopt NO_CLOBBER

#}}}

# Aliases {{{
  if [[ -s ${ZDOTDIR:-${HOME}}/.aliases.zsh ]]; then
    source ${ZDOTDIR:-${HOME}}/.aliases.zsh
  fi
#}}}

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

# autoload -U fzf-cd-widget
zle -N fzf-cd-widget
bindkey '^xc' fzf-cd-widget
bindkey '^x^s' fzf-cd-widget

# Set function paths
  fpath=(
    $HOME/.ellipsis/comp
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

# Input Settings {{{
  # Return if requirements are not found.
  if [[ ${TERM} == 'dumb' ]]; then
    return 1
  fi

  # Use human-friendly identifiers.
  zmodload -F zsh/terminfo +b:echoti +p:terminfo
  typeset -gA key_info
  key_info=(
    'Control'      '\C-'
    'ControlLeft'  '\e[1;5D \e[5D \e\e[D \eOd \eOD'
    'ControlRight' '\e[1;5C \e[5C \e\e[C \eOc \eOC'
    'Escape'       '\e'
    'Meta'         '\M-'
    'Backspace'    "${terminfo[kbs]}"
    'BackTab'      "${terminfo[kcbt]}"
    'Left'         "${terminfo[kcub1]}"
    'Down'         "${terminfo[kcud1]}"
    'Right'        "${terminfo[kcuf1]}"
    'Up'           "${terminfo[kcuu1]}"
    'Delete'       "${terminfo[kdch1]}"
    'End'          "${terminfo[kend]}"
    'F1'           "${terminfo[kf1]}"
    'F2'           "${terminfo[kf2]}"
    'F3'           "${terminfo[kf3]}"
    'F4'           "${terminfo[kf4]}"
    'F5'           "${terminfo[kf5]}"
    'F6'           "${terminfo[kf6]}"
    'F7'           "${terminfo[kf7]}"
    'F8'           "${terminfo[kf8]}"
    'F9'           "${terminfo[kf9]}"
    'F10'          "${terminfo[kf10]}"
    'F11'          "${terminfo[kf11]}"
    'F12'          "${terminfo[kf12]}"
    'Home'         "${terminfo[khome]}"
    'Insert'       "${terminfo[kich1]}"
    'PageDown'     "${terminfo[knp]}"
    'PageUp'       "${terminfo[kpp]}"
  )

  # Bind the keys

  local key
  for key (${(s: :)key_info[ControlLeft]}) bindkey ${key} backward-word
  for key (${(s: :)key_info[ControlRight]}) bindkey ${key} forward-word

  [[ -n ${key_info[Home]} ]] && bindkey ${key_info[Home]} beginning-of-line
  [[ -n ${key_info[End]} ]] && bindkey ${key_info[End]} end-of-line

  [[ -n ${key_info[PageUp]} ]] && bindkey ${key_info[PageUp]} up-line-or-history
  [[ -n ${key_info[PageDown]} ]] && bindkey ${key_info[PageDown]} down-line-or-history

  [[ -n ${key_info[Insert]} ]] && bindkey ${key_info[Insert]} overwrite-mode

  if [[ ${zdouble_dot_expand} == 'true' ]]; then
    double-dot-expand() {
      if [[ ${LBUFFER} == *.. ]]; then
        LBUFFER+='/..'
      else
        LBUFFER+='.'
      fi
    }
    zle -N double-dot-expand
    bindkey '.' double-dot-expand
  fi

  [[ -n ${key_info[Backspace]} ]] && bindkey ${key_info[Backspace]} backward-delete-char
  [[ -n ${key_info[Delete]} ]] && bindkey ${key_info[Delete]} delete-char

  [[ -n ${key_info[Left]} ]] && bindkey ${key_info[Left]} backward-char
  [[ -n ${key_info[Right]} ]] && bindkey ${key_info[Right]} forward-char

  # Expandpace.
  bindkey ' ' magic-space

  # Clear
  bindkey "${key_info[Control]}L" clear-screen

  # Bind Shift + Tab to go to the previous menu item.
  [[ -n ${key_info[BackTab]} ]] && bindkey ${key_info[BackTab]} reverse-menu-complete

  autoload -Uz is-at-least && if ! is-at-least 5.3; then
    # Redisplay after completing, and avoid blank prompt after <Tab><Tab><Ctrl-C>
    expand-or-complete-with-redisplay() {
      print -Pn '...'
      zle expand-or-complete
      zle redisplay
    }
    zle -N expand-or-complete-with-redisplay
    bindkey "${key_info[Control]}I" expand-or-complete-with-redisplay
  fi

  # Put into application mode and validate ${terminfo}
  zle-line-init() {
    (( ${+terminfo[smkx]} )) && echoti smkx
  }
  zle-line-finish() {
    (( ${+terminfo[rmkx]} )) && echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
#}}}



# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
