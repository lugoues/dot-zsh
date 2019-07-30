
  if [ $commands[fasd] ]; then
    v() {
      local file
      file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && $EDITOR "${file}" || return 1
    }
  fi
