# ToDo:
#  - z-a-rust
#  - add custom configuration for p10k lean theme so it can actually be updated without overwriting custom changes

## Initialize Zinit {{{
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

#HACK - i don't want these aliases
unalias zpl
unalias zplg
unalias zi


# where do we store zsh config
ZCONFIG="${HOME}/.zsh"

# Install Plugins {{{
# Look / Feel
  [[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor

  zinit lucid from:'gh' \
              depth=1 \
              light-mode \
              for @romkatv/powerlevel10k

  zinit lucid from:'gh' \
              atload:'fast-theme $ZCONFIG/themes/fsh/nord.ini > /dev/null' \
              light-mode \
              for @zdharma/fast-syntax-highlighting

  zinit lucid atclone:'dircolors -b src/dir_colors > c.zsh' \
              atpull:'%atclone' \
              pick:'c.zsh' \
              src:'c.zsh' \
              nocompile:'!' \
              wait light-mode \
              for @arcticicestudio/nord-dircolors

# Tooling
  zinit lucid from:'gh-r' \
              as:'program' \
              atclone:'chmod go-w ./* -R' \
              atpull:'%atclone%' \
              light-mode \
              for @sharkdp/fd

  zinit lucid from:'gh-r' \
              as:'program' \
              bpick:'*x86_64*' \
              mv:'bat* -> bat' \
              pick:'bat/bat' \
              light-mode \
              for @sharkdp/bat

  zinit lucid from:'gh-r' \
              as:'program' \
              pick:'delta*/delta' \
              light-mode \
              for @dandavison/delta

  zinit lucid from:'gh-r' \
              as:'program' \
              mv:'exa* -> exa' \
              light-mode \
              for @ogham/exa

  # can't wait because of loading issues
  zinit lucid from:'gh-r' \
              as:'program' \
              mv:'zoxide* -> zoxide' \
              atload:'!eval "$(zoxide init zsh)"' \
              atload:'export _ZO_DATA_DIR=$HOME/.local/share' \
              light-mode \
              for @ajeetdsouza/zoxide

  # zinit lucid from:'gh' \
  #             as:'plugin' \
  #             wait light-mode \
  #             for @marlonrichert/zsh-autocomplete

  zinit lucid from:'gh-r' \
              as:'program' \
              pick:'navi' \
              atclone:'navi widget zsh >! znavi.zsh' \
              atpull:'%atclone' \
              src:'znavi.zsh' \
              wait light-mode \
              for @denisidoro/navi
              # atload:'export NAVI_PATH="$HOME/Library/Application Support/navi/cheats:$HOME/.zsh/cheats:$HOME/.local/share/navi/cheats"' \

  zinit lucid from:'gh' \
              as:'program' \
              src:'init.sh' \
              wait nocompletions light-mode \
              for @b4b4r07/enhancd

  zinit ice lucid as"program" from"gh-r"
  zinit load junegunn/fzf-bin

  zinit ice lucid \
          id-as"junegunn/fzf_completions" \
          multisrc"shell/{completion,key-bindings}.zsh"
  zinit light junegunn/fzf

# Generated Completions
  zinit ice has:'nodenv' \
            id-as:'nodev-setup' \
            as:'null' \
            atload:'eval "$(nodenv init - --no-rehash zsh)"' \
            wait silent nocompile
  zinit light zdharma/null

  zinit ice has:'pyenv' \
              id-as:'pyenv-setup' \
              as:'null' \
              atload:'eval "$(pyenv init - --no-rehash zsh)"' \
              wait silent nocompile'!'
  zinit light zdharma/null

  zinit ice has:'pyenv-virtualenv' \
            id-as:'pyenv-virtualenv-setup' \
            as:'null' \
            atload:'eval "$(pyenv virtualenv-init - --no-rehash zsh)"' \
            wait silent nocompile
  zinit light zdharma/null

  zinit ice has:'broot' \
            id-as:'broot-setup' \
            as:'null' \
            atload:'eval "$(broot --print-shell-function zsh)"' \
            wait silent nocompile
  zinit light zdharma/null

  zinit ice has'eksctl' \
            id-as'eksctl-setup' \
            as"completion" \
            atclone'eksctl completion zsh >! _eksctl' \
            atpull'%atclone' \
            wait'1' silent nocompile run-atpull
  zinit light zdharma/null

# Completions
  # zinit wait'1' lucid atload"zicompinit; zicdreplay" blockf for \
  # zsh-users/zsh-completions
  # Todo: this fails with 'can only be called from completion function'
  # zinit ice slient has'exa' as'completion'
  # zinit snippet https://github.com/ogham/exa/blob/master/contrib/completions.zsh

  # zinit ice slient has'docker' as'completion'
  # zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

  # zinit ice slient has'docker' as'completion'
  # zinit snippet https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose

  # zinit ice slient has'pyenv' as'completion'
  # zinit snippet https://github.com/pyenv/pyenv/blob/master/completions/pyenv.zsh

# Plugins
  #OMZ
  zinit lucid wait svn is-snippet for \
    if:'[[ ${OSTYPE} = darwin* ]]' OMZ::plugins/osx \
    has:'brew'      OMZ::plugins/brew \
    has:'pip'       OMZ::plugins/pip \
    has:'tmux'      OMZ::plugins/tmux \
    has:'gpg-agent' OMZ::plugins/gpg-agent \
    has:'mosh'      OMZ::plugins/mosh

# Load Configuration
  zinit ice lucid as'local-configuration' atinit'local i; for i in configuration/*.zsh; do source $i; done'
  zinit load ~/.zsh

# Load Commands
  zinit ice lucid as'local-commands' wait atinit'local i; for i in commands/*.zsh; do source $i; done'
  zinit load ~/.zsh

# Reload Completions
  zinit ice silent wait"!1" atload"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" #; zpcdreplay"
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
  HISTORY_IGNORE='(bg|fg|cd*|rm*|clear|l[alsh]#( *)#|pwd|history|exit|make*|* --help|jrnl*|dnote*|nj*)' # hide common or private commands from history
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

## GPG
#  (( $+commands[gpg] )) && \
#    export GPG_TTY=$(tty)
##}}}

# Local Config Settings {{{
  [[ -f "${HOME}/.zshrc.local" ]] && source ${HOME}/.zshrc.local
#}}}
