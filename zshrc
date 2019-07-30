zconfig="${HOME}/.zsh"

# Emacs mode
bindkey -e

# Load zplug {{{
  source "${HOME}/.zplugin/bin/zplugin.zsh"
  autoload -Uz _zplugin
  (( ${+_comps} )) && _comps[zplugin]=_zplugin

  # Add ZIM to snippet shorthand
  ZPLG_1MAP+=("ZIM::" "https://github.com/zimfw/zimfw/trunk/")
  ZPLG_2MAP+=("ZIM::" "https://github.com/zimfw/zimfw/raw/master/")
#}}}

# Install zplugin Plugins {{{
  zplugin light chrissicool/zsh-256color
  zplugin light mafredri/zsh-async

  zplugin ice pick"async.zsh" src"pure.zsh"
  zplugin light sindresorhus/pure

  # zplugin light romkatv/powerlevel10k

  # zplugin ice pick".purepower" src".purepower"
  # zplugin light romkatv/dotfiles-public

  zplugin ice lucid wait"!0" pick"scripts/base16-tomorrow-night.sh" src"scripts/base16-tomorrow-night.sh" if"[[ $+ITERM_PROFILE ]]"
  zplugin light chriskempson/base16-shell

  zplugin ice lucid wait"0" pick"bash/base16-tomorrow-night.config" src"bash/base16-tomorrow-night.config" nocompile'!'
  zplugin light nicodebo/base16-fzf

  zplugin ice lucid wait"!0" atload"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit"
  zplugin light zdharma/fast-syntax-highlighting

  zplugin ice silent as"program" from"gh-r"
  zplugin light junegunn/fzf-bin

  zplugin ice lucid wait"1" as"command" pick"bin/fzf-tmux"
  zplugin light junegunn/fzf

  # Create and bind multiple widgets using fzf
  zplugin ice lucid wait"0" multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
  zplugin light junegunn/fzf

  # Load FASD - pregen the init script whent pulled and source it when loading
  zplugin ice lucid \
    wait"0" \
    as"command" \
    atclone"fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install > load_fasd.zsh" \
    atpull'%atclone' pick"load_fasd.zsh" src"load_fasd.zsh" nocompile'!'
  zplugin light whjvenyl/fasd

  zplugin ice atclone"./libexec/pyenv init - > zpyenv.zsh" \
              atinit'export PYENV_ROOT="$PWD"' atpull"%atclone" \
              as'command' pick'bin/pyenv' src"zpyenv.zsh" nocompile'!'
  zplugin light pyenv/pyenv

  zplugin ice atclone"PATH=./bin:$PATH pyenv virtualenv-init - > zpyenv.zsh" \
              atpull"%atclone" \
              as'command' pick"bin/*" src"zpyenv.zsh" nocompile'!'
  zplugin light pyenv/pyenv-virtualenv

  zplugin ice lucid wait'2' as"program" mv"docker* -> docker-compose" if'[[ "$commands[docker]" ]]'
  zplugin light docker/compose

  zplugin ice lucid wait"2" as"program" pick"bin/git-dsf"
  zplugin light zdharma/zsh-diff-so-fancy

  zplugin ice lucid wait"2" as"program" pick"$ZPFX/bin/git-now" make"prefix=$ZPFX install"
  zplugin light iwata/git-now

  zplugin ice lucid wait"2" as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX" nocompile
  zplugin light tj/git-extras

  zplugin ice lucid wait"2" as"program" atclone'perl Makefile.PL PREFIX=$ZPFX' atpull'%atclone' \
            make'install' pick"$ZPFX/bin/git-cal"
  zplugin light k4rthik/git-cal

  zplugin ice lucid wait'2' as'program'  from"gh-r" atclone"mkdir -p ./functions && ./kind completion zsh > ./functions/_kind" atpull'%atclone' mv'kind* -> kind' nocompile
  zplugin light kubernetes-sigs/kind

  # zplugin ice as"completion" if'[[ "$commands[docker]" ]]' atinit'zpcompinit; zpcdreplay'
  #OMZ
  zplugin ice lucid wait'1' svn if'[[ ${OSTYPE} = darwin* ]]'
  zplugin snippet OMZ::plugins/osx

  zplugin ice lucid wait'1' svn if'[[ ${OSTYPE} = darwin* ]]'
  zplugin snippet OMZ::plugins/brew

  zplugin ice lucid wait'1' svn if'[[ "$commands[pip]" ]]'
  zplugin snippet OMZ::plugins/pip

  zplugin ice lucid wait'1' svn if'[[ "$commands[tmux]" ]]'
  zplugin snippet OMZ::plugins/tmux

  zplugin ice lucid wait'1' svn if'[[ "$commands[mosh]" ]]'
  zplugin snippet OMZ::plugins/mosh

  #ZIM
  zplugin ice svn lucid wait'1'
  zplugin snippet ZIM::modules/ssh

  zplugin ice svn lucid wait'1'
  zplugin snippet ZIM::modules/environment

  zplugin ice svn lucid wait'1'
  zplugin snippet ZIM::modules/git

  zplugin ice svn lucid wait'1'
  zplugin snippet ZIM::modules/directory

  zplugin ice svn lucid wait'1'
  zplugin snippet ZIM::modules/input

  zplugin ice svn lucid wait'1'
  zplugin snippet ZIM::modules/utility

  zplugin ice svn
  zplugin snippet ZIM::modules/completion

  # Completions
  zplugin ice lucid wait"1" as"completion" if'[[ "$commands[docker]" ]]' atinit'zpcompinit; zpcdreplay'
  zplugin snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

  zplugin ice lucid wait"1" as"completion" if'[[ "$commands[docker]" ]]' atinit'zpcompinit; zpcdreplay'
  zplugin snippet https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose

  # Load Commands
  zplugin ice lucid wait"0" atinit'local i; for i in commands/*.zsh; do source $i; done'
  zplugin load ~/.zsh

  zplugin ice lucid wait"0"
  zplugin snippet "$HOME/.zsh/aliases.zsh"

  zpcompinit
#}}}

# Theming {{{
  export PURE_PROMPT_SYMBOL=λ
#}}}

# Paths {{{
  fpath=(
    $HOME/.ellipsis/comp
    $( (( $+command[brew] )) && echo $(brew --prefix)/share/zsh/site-functions)
    $fpath
  )

path=(
    ~/.local/bin
    ~/.cargo/bin
    ~/.ellipsis/bin
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
#}}}


# History {{{
  HISTORY_IGNORE="(bg|fg|cd*|rm*|clear|ls|pwd|history|exit|make*|* --help|ll|la|jrnl *)"
  HISTFILE=~/.zhistory
  HISTSIZE=99999
  SAVEHIST=99999
  setopt extendedhistory
  setopt hist_save_no_dups
  setopt hist_ignore_all_dups
  setopt completeinword   # save each commands beginning timestamp and the duration to the history file
  setopt hash_list_all  # save each commands beginning timestamp and the duration to the history file
  setopt inc_append_history     # add commands to HISTFILE in order of execution
#}}}

# Configuration {{{
  export CONCURRENCY_LEVEL=5
  export EDITOR=nvim
  export CHEATCOLORS=true
  # export XDG_CONFIG_HOME=~/.config

  #disable auto correct
  unsetopt correct_all
#}}}

# FZF Configuration {{{
(( $+commands[bfs] )) && \
  export FZF_ALT_C_COMMAND="bfs -type d -nohidden"
(( $+commands[fd] )) && \
  export FZF_ALT_C_COMMAND="fd -t d ."

  export FZF_TMUX=true

  if [ $+command[rg] ]; then
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" 2> /dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
#}}}

# PyEnv {{{
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
#}}}

# GPG {{{
(( $+commands[gpg] )) && \
  export GPG_TTY=$(tty)
#}}}


# meta-e to edit command in editor
autoload edit-command-line && zle -N edit-command-line
bindkey '\ee' edit-command-line
