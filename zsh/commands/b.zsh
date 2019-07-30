
beet(){
  docker run --rm -it \
    -e PUID=$(id -u beets) -e PGID=$(getent group beets | cut -d: -f3) \
    -v /mnt/raid/Bittorrent/Music:/mnt/raid/Bittorrent/Music:ro \
    -v /mnt/raid/Music:/mnt/raid/Music \
    -v ~/.config/beets:/config \
    lugoues/beets "$@"
}

