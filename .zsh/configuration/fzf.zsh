

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
    --color=fg:#d8dee9,hl:#81a1c1
    --color=fg+:#d8dee9,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
fi
