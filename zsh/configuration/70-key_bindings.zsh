# meta-e to edit command in editor
autoload edit-command-line && zle -N edit-command-line
bindkey '\ee' edit-command-line

# Make Alt-Backspace respect directory paths
backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

bindkey '\ep' push-line-or-edit

# emacs mode
bindkey -e
