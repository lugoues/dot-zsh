

if [ $commands[fzf] ]; then
  (( $+commands[bfs] )) && \
    export FZF_ALT_C_COMMAND="bfs -type d -nohidden"

  (( $+commands[fd] )) && \
    export FZF_ALT_C_COMMAND="fd -t d ."

  export FZF_TMUX=true

  if [ $+commands[rg] ]; then
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" 2> /dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  if [ $+commands[bat] ]; then
    export FZF_CTRL_T_OPTS="--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
  fi


  export FZF_DEFAULT_OPTS='
    --color=fg:#b4b7b4,bg:#1a1a1a,hl:#111f2b
    --color=fg+:#e0e0e0,bg+:#282a2e,hl+:#88abc9
    --color=info:#f0c674,prompt:#f0c674,pointer:#8abeb7
    --color=marker:#a3be8b,spinner:#8abeb7,header:#81a2be'
fi
