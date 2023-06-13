if [ $commands[atuin] ]; then
   export ATUIN_NOBIND="true"
   eval "$(atuin init zsh)"
   bindkey "^r" _atuin_search_widget
   bindkey "^ " autosuggest-accept
   _zsh_autosuggest_strategy_atuin_top() {
       suggestion=$(atuin search --cmd-only --limit 1 --search-mode prefix $1)
   }
   export ZSH_AUTOSUGGEST_STRATEGY=atuin_top
fi
