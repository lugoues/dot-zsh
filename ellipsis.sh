#!/usr/bin/env zsh
#
# lugoues/zsh ellipsis package

requires=(zsh git fzf)

_check_requires() {
  for i in "${requires[@]}"
  do
    if ! utils.cmd_exists $i; then
      log.fail "Unmet dependency '$i'"
      return 1
    fi
  done
}


pkg.install() {
  echo "$(tput setaf 2)Installing Zim.$(tput sgr0)"
  # check if git,zsh,fzf installed

  _check_requires
}

pkg.pull() {
  git.pull

  echo "$(tput setaf 2)Updating zplug.$(tput sgr0)"
  zsh -c 'source $HOME/.zshrc && zplug update && zplug clean && zplug clear' 2> /dev/null
}
