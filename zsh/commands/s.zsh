if [[ $+commands[rg] && $+commands[fzf] ]]; then
  unalias sf
  function sf {
    if [ "$#" -lt 1 ]; then echo "Supply string to search for!"; return 1; fi
    printf -v search "%q" "$*"
    # include="yml,js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst"
    # exclude=".config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist"
    # rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" -g "*.{'$include'}" -g "!{'$exclude'}/*"'
    # files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}'`
    rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" 2> /dev/null'
    files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}' 2> /dev/null`
    [[ -n "$files" ]] && ${EDITOR:-vim} $files
  }
fi

