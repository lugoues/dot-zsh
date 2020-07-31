# sf: search all files recurrisvely for search string. Provide interactive view of results.

# if [[ ${+commands[rg]} && ${+commands[fzf]} ]]; then
    # unalias sf > /dev/null 2>&1

  function sf {
    [[ -z ${+commands[rg]} ]] && echo "Ripgrep is required"
    [[ -z ${+commands[fzf]} ]] && echo "FZF is required"
    [[ "$#" -lt 1 ]] && echo 'Supply string to search for!' && return 1;
    printf -v search "%q" "$*"

    local margin=20 # number of lines above and below search result.
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
# fi
