# lugoues/zsh
Just a bunch of dotfiles.

## Install
Clone and symlink or install with [ellipsis][ellipsis]:

```
$ ellipsis install lugoues/zsh
```

[ellipsis]: http://ellipsis.sh


Plugins

<ctrl-g> - fuzzy search dir history (fzf-z)[https://github.com/andrewferrier/fzf-z]


<j> <path text>  https://github.com/whjvenyl/fasd

Aliases

sf <query text> - search tree for files with query text then provide fuzzy matching file name
kill [-1-9] <tab> - fuzzy search process list and kill
cd --   - open a fuzzy search of your last 20 paths
cd ...  - open a fuzy search of all parent directories
