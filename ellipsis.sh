#!/usr/bin/env zsh
#
# lugoues/zsh ellipsis package

requires=(zsh git gawk)
ZPLUGIN_HOME=~/.zplugin

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

_install_zplugin() {
  echo "$(tput setaf 2)Installing zplugin.$(tput sgr0)"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh | zsh
}

_uninstall_zplugin() {
  rm $ZPLUG_HOME -Rf
}

pkg.install() {
  _check_requires || exit $?
  _install_zplugin
}

pkg.pull() {
  git.pull

  echo "$(tput setaf 2)Updating zplug.$(tput sgr0)"
  # zsh -c 'source $HOME/.zshrc ' 2> /dev/null
}

pkg.uninstall() {
  _uninstall_zplugin
}
