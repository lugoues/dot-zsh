# zconfig="${HOME}/.zsh"

# # Emacs mode
# bindkey -e

# # Load zplug {{{
#   source "${HOME}/.zplugin/bin/zplugin.zsh"
#   autoload -Uz _zplugin
#   (( ${+_comps} )) && _comps[zplugin]=_zplugin

#   # # Add ZIM to snippet shorthand
#   # ZPLG_1MAP+=("ZIM::" "https://github.com/zimfw/zimfw/trunk/")
#   # ZPLG_2MAP+=("ZIM::" "https://github.com/zimfw/zimfw/raw/master/")
# #}}}

# # Install zplugin Plugins {{{



  # zplugin ice lucid wait"!0" pick"scripts/base16-tomorrow-night.sh" src"scripts/base16-tomorrow-night.sh" if"[[ $+ITERM_PROFILE ]]"
  # zplugin light chriskempson/base16-shell

  # zplugin ice lucid wait"0" pick"bash/base16-tomorrow-night.config" src"bash/base16-tomorrow-night.config" nocompile'!'
  # zplugin light nicodebo/base16-fzf

  # zplugin ice lucid wait"!0" atload"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit"
  # zplugin light zdharma/fast-syntax-highlighting




  # # Create and bind multiple widgets using fzf
  # zplugin ice lucid wait"0" multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"
  # zplugin light junegunn/fzf


  # Load FASD - pregen the init script whent pulled and source it when loading




# MichaelAquilina/zsh-autoswitch-virtualenv


  # zplugin ice lucid wait'1' as"program" mv"docker* -> docker-compose" has'docker'
  # zplugin light docker/compose

  # zplugin ice lucid wait'1' as"program" pick"bin/git-dsf"
  # zplugin light zdharma/zsh-diff-so-fancy

  # zplugin ice lucid wait'1' as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX" nocompile
  # zplugin light tj/git-extras

  # zplugin ice lucid wait"1" as"program" atclone'perl Makefile.PL PREFIX=$ZPFX' atpull'%atclone' \
  #           make'install' pick"$ZPFX/bin/git-cal"
  # zplugin light k4rthik/git-cal





  zplugin ice silent wait"1" as"program" from"gh-r" mv'k3sup* -> k3sup' nocompile
  zplugin light alexellis/k3sup


# # Generated Completions {{{
#   zplugin ice has'eksctl' \
#               id-as'eksctl' \
#               as"null" \
#               atclone'eksctl completion zsh >! _eksctl' \
#               atpull'%atclone' \
#               wait silent nocompile run-atpull
#   zplugin light zdharma/null



#}}}
  # zplugin ice as"completion" if'[[ "$commands[docker]" ]]' atinit'zpcompinit; zpcdreplay'
  #OMZ
  # zplugin ice lucid wait'1' svn if'[[ ${OSTYPE} = darwin* ]]'
  # zplugin snippet OMZ::plugins/osx

  # zplugin ice lucid wait'1' svn if'[[ ${OSTYPE} = darwin* ]]'
  # zplugin snippet OMZ::plugins/brew

  # zplugin ice lucid wait'1' svn has'pip'
  # zplugin snippet OMZ::plugins/pip

  # zplugin ice lucid wait'1' svn has'tmux'
  # zplugin snippet OMZ::plugins/tmux

  # zplugin ice lucid wait'1' svn has'mosh'
  # zplugin snippet OMZ::plugins/mosh

  #ZIM
  # zplugin ice svn lucid wait'1'
  # zplugin snippet ZIM::modules/environment

  # zplugin ice svn lucid wait'1'
  # zplugin snippet ZIM::modules/git

  # zplugin ice svn lucid wait'1'
  # zplugin snippet ZIM::modules/directory

  # zplugin ice svn lucid wait'1'
  # zplugin snippet ZIM::modules/input

  # zplugin ice svn lucid wait'1'
  # zplugin snippet ZIM::modules/utility

  # zplugin ice svn lucid wait'1' atinit'zpcompinit; zpcdreplay'
  # zplugin snippet ZIM::modules/completion

  # Completions
  # zplugin ice lucid wait"1" as"completion" has'docker' atinit'zpcompinit; zpcdreplay'
  # zplugin snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker


  # zplugin ice slient wait as"completion" # atinit'zpcompinit; zpcdreplay'
  # zplugin snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh




  # # Load Commands
  # zplugin ice lucid wait"2" atinit'local i; for i in commands/*.zsh; do source $i; done'
  # zplugin load ~/.zsh

  # zplugin ice lucid wait"1"
  # zplugin snippet "$HOME/.zsh/aliases.zsh"

  # Reload any turbo configurations
  zplugin ice wait lucid atload"zicompinit; zicdreplay" blockf

  zpcompinit
#}}}

# Theming {{{
  export PURE_PROMPT_SYMBOL=λ
#}}}

# Paths {{{
  fpath=(
    $HOME/.ellipsis/comp
    $zconfig/functions
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
    $( (( $+commands[dotnet] )) && echo "${HOME}/.dotnet/tools");
    /Applications/Visual Studio Code.app/Contents/Resources/app/bin
    $path
  )
#}}}


# History {{{

#}}}


# Lpass Cli  {{{
  # export LPASS_HOME="${HOME}/.local/etc/lpass"
# }}}

# Configuration {{{
  # export CONCURRENCY_LEVEL=5
  # export EDITOR=nvim
  # export CHEATCOLORS=true
  # export XDG_CONFIG_HOME=~/.config

  #disable auto correct
  # unsetopt correct_all

  # Prevent reporting the status of background and suspended jobs before exiting a shell with job control.
  # NO_CHECK_JOBS is best used only in combination with NO_HUP, else such jobs will be killed automatically.
  # setopt NO_CHECK_JOBS
#}}}

# FZF Configuration {{{

#}}}

# PyEnv {{{
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
#}}}

# GPG {{{
# (( $+commands[gpg] )) && \
#   export GPG_TTY=$(tty)
#}}}

# Fzf Ctl-T aware {{
# export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion
#}}

# meta-e to edit command in editor
autoload edit-command-line && zle -N edit-command-line
bindkey '\ee' edit-command-line
