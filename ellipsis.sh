#!/usr/bin/env zsh
#
# lugoues/zsh ellipsis package

requires=(zsh git gawk)
ZPLUG_HOME=~/.zplug

_check_requires() {
  echo "$(tput setaf 2)Checking dependencies...$(tput sgr0)"
  for i in "${requires[@]}"
  do
    if ! utils.cmd_exists $i; then
      log.fail "Unmet dependency '$i'"
      return 1
    fi
  done
}

_install_zplug() {
  echo "$(tput setaf 2)Installing zplug.$(tput sgr0)"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
}

_uninstall_zplug() {
  rm $ZPLUG_HOME -Rf
}

pkg.install() {
  _check_requires
  _install_zplug
}

pkg.pull() {
  git.pull

  echo "$(tput setaf 2)Updating zplug.$(tput sgr0)"
  zsh -c 'source $HOME/.zshrc && zplug update && zplug clean && zplug clear' 2> /dev/null
}

pkg.uninstall() {
  _uninstall_zplug
}
