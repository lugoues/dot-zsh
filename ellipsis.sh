#!/usr/bin/env zsh
#
# lugoues/zsh ellipsis package

requires=(zsh git gawk svn unzip wget)

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

_uninstall_zplugin() {
  rm -fR $HOME/.zinit
}

pkg.install() {
  _check_requires || exit $?

  tic -x $PKG_PATH/.terminfo/xterm-256color-italic.terminfo
  tic -x $PKG_PATH/.terminfo/tmux.terminfo
}

pkg.pull() {
  git.pull
}

pkg.uninstall() {
  _uninstall_zplugin
}
