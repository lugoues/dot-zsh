#!/usr/bin/env bash
#
# lugoues/zsh ellipsis package

pkg.install() {
  echo "$(tput setaf 2)Installing Zim.$(tput sgr0)"
  git clone --recursive https://github.com/Eriner/zim.git ${PKG_PATH}/zim
}

pkg.pull() {
  git.pull

  echo "$(tput setaf 2)Updating Zim.$(tput sgr0)"
  zsh ./zim/tools/zim_update
}
