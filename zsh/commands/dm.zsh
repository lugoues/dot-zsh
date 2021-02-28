function vg() {
  pushd ~/.local/share/windows-docker-machine
  vagrant $*
  popd
}

