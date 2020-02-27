
## Initialize Zinit
  if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
      print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
      command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
      command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
          print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
          print -P "%F{160}▓▒░ The clone has failed.%f"
  fi
  source "$HOME/.zinit/bin/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
#}}}

# where do we store zsh config
ZCONFIG="${HOME}/.zsh"

# Install Plugins {{{

# Look / Feel
  [[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor

  zinit light mafredri/zsh-async

  zinit ice silent wait'1' atload'fast-theme $ZCONFIG/themes/fsh/nord.ini > /dev/null'
  zinit light zdharma/fast-syntax-highlighting

  zinit ice depth=1
  zinit light romkatv/powerlevel10k

  zinit ice atclone"dircolors -b src/dir_colors > c.zsh" \
              atpull'%atclone' \
              pick"c.zsh" \
              src'c.zsh' \
              nocompile'!'
  zinit light arcticicestudio/nord-dircolors

# Tooling
  zinit ice lucid as"program" from"gh-r"
  zinit light sharkdp/fd

  zinit ice lucid from"gh-r" as"program" bpick"*x86_64*" mv"bat* -> bat" pick"bat/bat"
  zinit light sharkdp/bat

  # zinit ice lucid as"program" pick"bin/git-dsf"
  # zinit light zdharma/zsh-diff-so-fancy

  zinit ice lucid from"gh-r" as"program" pick"delta*/delta"
  zinit light dandavison/delta

  zinit ice lucid from"gh-r" as"program" mv"exa* -> exa"
  zinit light ogham/exa

  zinit ice lucid \
    wait"1" \
    as"program" \
    atclone"fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install > load_fasd.zsh" \
    atpull'%atclone' \
    pick"load_fasd.zsh" \
    src"load_fasd.zsh" \
    nocompile'!'
  zinit light whjvenyl/fasd

  zinit ice lucid as"program" from"gh-r"
  zinit load junegunn/fzf-bin

  zinit ice lucid wait \
          id-as"junegunn/fzf_completions" \
          multisrc"shell/{completion,key-bindings}.zsh"
  zinit light junegunn/fzf

  zinit ice luicd wait
  zinit light andrewferrier/fzf-z

  zinit ice lucid as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX" nocompile
  zinit light tj/git-extras

  zinit ice lucid wait as"program" src"init.sh"
  zinit light b4b4r07/enhancd

  # zplugin ice has'pyenv' \
  #             id-as'pyenv-competion' \
  #             as'null' \
  #             atinit'eval "$(pyenv init - zsh --no-rehash)"' \
  #             src'completions/pyenv.zsh'
  #             wait silent nocompile run-atpull
  # zplugin light zdharma/null

  # zplugin ice lucid wait'1' \
  #             as'command' pick"bin/*" nocompile'!'
  # zplugin light zdharma/null



  # zinit light https://github.com/SidOfc/dotfiles/blob/d07fa3862ed065c2a5a7f1160ae98416bfe2e1ee/zsh/fp
  # # Todo - do we want this?
  # zinit ice lucid wait"1" as"program" \
  #             atclone'PIPENV_VENV_IN_PROJECT=1 pipenv run python setup.py install' \
  #             atpull'%atclone' \
  #             pick".venv/bin/git-revise" \
  #             has"pipenv"
  # zinit light mystor/git-revise

  # zinit ice lucid wait'1' \
  #           atinit'eval "$(pyenvFailed to select current timestamp init - zsh --no-rehash)"' \
  #           as'command' pick'bin/pyenv' src'completions/pyenv.zsh' nocompile'!' \
  #           has'pyenv' \
  #           id-as'pyenv'
  # zinit light zdharma/null

  # zinit ice lucid wait'1' \
  #             as'command' pick"bin/*" nocompile'!' \
  #             has'pyenv-virtualenv' \
  #             id'pyenv-virtualenv'
  # zinit light zdharma/null

  # zinit ice lucid wait'1' as'program' from"gh-r" atclone"mkdir -p ./functions && ./kind completion zsh > ./functions/_kind" atpull'%atclone' mv'kind* -> kind' nocompile
  # zinit light kubernetes-sigs/kind

# Completions
  zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-completions
  # Todo: this fails with 'can only be called from completion function'
  # zinit ice slient has'exa' as'completion'
  # zinit snippet https://github.com/ogham/exa/blob/master/contrib/completions.zsh

  # zinit ice slient has'docker' as'completion'
  # zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

  # zinit ice slient has'docker' as'completion'
  # zinit snippet https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose

# Generated Completions
  zplugin ice has'eksctl' \
              id-as'eksctl' \
              as"null" \
              atclone'eksctl completion zsh >! _eksctl' \
              atpull'%atclone' \
              wait silent nocompile run-atpull
  zplugin light zdharma/null

# Plugins
  #OMZ
  zinit ice lucid wait svn if'[[ ${OSTYPE} = darwin* ]]'
  zinit snippet OMZ::plugins/osx

  zinit ice lucid wait svn if'[[ ${OSTYPE} = darwin* ]]'
  zinit snippet OMZ::plugins/brew

  zinit ice lucid wait svn has'pip'
  zinit snippet OMZ::plugins/pip

  zinit ice lucid wait svn has'tmux'
  zinit snippet OMZ::plugins/tmux

  zinit ice lucid wait svn has'mosh'
  zinit snippet OMZ::plugins/mosh

# Load Configuration
  zinit ice lucid as'local-configuration' atinit'local i; for i in configuration/*.zsh; do source $i; done'
  zinit load ~/.zsh

# Load Commands
  zinit ice lucid as'local-commands' wait"1" atinit'local i; for i in commands/*.zsh; do source $i; done'
  zinit load ~/.zsh

# Reload Completions
  zinit ice silent wait"!1" atload"ZINIT[COMPINIT_OPTS]=-C; zpcompinit" #; zpcdreplay"
#}}}

# Paths {{{
  typeset -U fpath # make paths unique
  fpath=(
    $HOME/.ellipsis/comp
    $( (( $+command[brew] )) && echo $(brew --prefix)/share/zsh/site-functions)
    $fpath
  )
  export FPATH

  typeset -U path # make paths unique
  path=(
    ~/.local/bin
    ~/.cargo/bin
    ~/.ellipsis/bin
    /usr/local/sbin
    /usr/local/bin
    $( (( $+commands[brew] )) && \
      brew_prefix=$(brew --prefix) && \
      echo  ${brew_prefix}/opt/*/libexec/gnubin \
           "${brew_prefix}/opt/curl/bin" \
           "${brew_prefix}/opt/openssl/bin")
    $( (( $+commands[dotnet] )) && echo "${HOME}/.dotnet/tools");
    "$( [ -d "/Applications/Visual Studio Code.app" ] && echo "/Applications/Visual Studio Code.app/Contents/Resources/app/bin")"
    $path
  )
  export PATH #export caps path - both matter in zsh
#}}}

# Configuration {{{
  export CONCURRENCY_LEVEL=5
  export EDITOR=nvim
  export CHEATCOLORS=true
  export XDG_CONFIG_HOME=~/.config

# History
  HISTORY_IGNORE='(bg|fg|cd*|rm*|clear|l[alsh]#( *)#|pwd|history|exit|make*|* --help|jrnl*|dnote*)' # hide common or private commands from history
  zshaddhistory() {
    emulate -L zsh
    ## uncomment if HISTORY_IGNORE
    ## should use EXTENDED_GLOB syntax
    setopt extendedglob
    [[ $1 != ${~HISTORY_IGNORE} ]]
  }
  : ${HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory}
  HISTSIZE=99999
  SAVEHIST=99999
  setopt extended_history # record timestamp of command in HISTFILE
  setopt hist_ignore_all_dups # ignore duplicated commands history list
  setopt hist_expire_dups_first # delete dups first when reaching max history
  setopt completeinword   # save each commands beginning timestamp and the duration to the history file
  setopt hash_list_all  # save each commands beginning timestamp and the duration to the history file
  setopt inc_append_history     # add commands to HISTFILE in order of execution
  setopt share_history # share data between open sessions
  setopt hist_ignore_space      # ignore commands that start with space
  setopt hist_verify # Don't execute the command directly upon history expansion.
  # setopt hist_ignore_dups # Don't enter immediate duplicates into the history.
  # setopt hist_find_no_dups   # Don't display duplicates when searching the history.

# Terminal
  setopt auto_cd # Perform cd to a directory if the typed command is invalid, but is a directory.
  setopt auto_pushd # Make cd push the old directory to the directory stack.
  setopt pushd_ignore_dups # Don't push multiple copies of the same directory to the stack.
  setopt pushd_silent # Don't print the directory stack after pushd or popd.
  setopt pushd_to_home # Have pushd without arguments act like `pushd ${HOME}`.
  setopt extended_glob # Treat `#`, `~`, and `^` as patterns for filename globbing.
  unsetopt correct_all # disable auto correct

# Jobs
  setopt auto_resume # Resume an existing job before creating a new one.
  setopt long_list_jobs # List jobs in verbose format by default.
  setopt no_bg_nice # Prevent background jobs being given a lower priority.
  setopt no_hup # Prevent SIGHUP to jobs on shell exit.
  setopt no_check_jobs #Prevent reporting the status of background and suspended jobs before exiting a shell with job control.

# Input / Output
  setopt interactive_comments # Allow comments starting with `#` in the interactive shell.
  setopt no_clobber # Disallow `>` to overwrite existing files. Use `>|` or `>!` instead.

# GPG
  (( $+commands[gpg] )) && \
    export GPG_TTY=$(tty)
#}}}

# Local Config Settings {{{
  [[ -f "${HOME}/.zshrc.local" ]] && source ${HOME}/.zshrc.local
#}}}

