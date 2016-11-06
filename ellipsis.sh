#!/usr/bin/env bash
#
# lugoues/zsh ellipsis package

# The following hooks can be defined to customize behavior of your package:
# pkg.install() {
#     fs.link_files $PKG_PATH
# }

# pkg.push() {
#     git.push
# }

# pkg.pull() {
#     git.pull
# }

# pkg.installed() {
#     git.status
# }
#
# pkg.status() {
#     git.diffstat
# }

pkg.install() {
  echo "Installing Zim"
  git clone --recursive https://github.com/Eriner/zim.git ${PKG_PATH}/zim
}
