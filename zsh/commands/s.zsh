if [[ $+commands[rg] && $+commands[fzf] ]]; then
  unalias sf

  function sf {
    [[ "$#" -lt 1 ]] && echo 'Supply string to search for!' && return 1;
    printf -v search "%q" "$*"

    local margin=5 # number of lines above and below search result.
    local preview_cmd='search={};file=$(echo $search | cut -d':' -f 1 );'
    preview_cmd+="margin=$margin;" # Inject value into scope.
    preview_cmd+='line=$(echo $search | cut -d':' -f 2 ); ext=$(echo $file(:e));'
    preview_cmd+='tail -n +$(( $(( $line - $margin )) > 0 ? $(($line-$margin)) : 0)) $file | head -n $(($margin*2+1)) |'
    preview_cmd+='bat --paging=never --color=always --style=plain --language=$ext --highlight-line $(($margin+1))'

    local rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" 2> /dev/null'
    local full=$(eval $rg_command $search| fzf --ansi --select-1 --exit-0 --height=60%  --preview $preview_cmd --reverse)

    local file="$(echo $full | awk -F: '{print $1}')"
    local line="$(echo $full | awk -F: '{print $2}')"
    [[ -n "$file" ]] && ${EDITOR:-vim} "${file}" +$line
  }
  # function sf {
  #   if [ "$#" -lt 1 ]; then echo "Supply string to search for!"; return 1; fi
  #   printf -v search "%q" "$*"
  #   # include="yml,js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst"
  #   # exclude=".config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist"
  #   # rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always" -g "*.{'$include'}" -g "!{'$exclude'}/*"'
  #   # files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}'`
  #   rg_command='rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" 2> /dev/null'
  #   files=`eval $rg_command $search | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}' 2> /dev/null`
  #   [[ -n "$files" ]] && ${EDITOR:-vim} $files
  # }
fi

