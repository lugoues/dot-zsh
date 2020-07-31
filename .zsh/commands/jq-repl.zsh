function jq-repl { echo '' | fzf --preview "jq {q} ${1} | bat -l json --paging=never --color=always --style=plain --theme=TwoDark" }
