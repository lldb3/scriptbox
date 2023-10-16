if [[ -f /etc/redhat-release ]]; then
  BASIC="git curl neovim util-linux-user ncdu exa bat fd-find tldr"
  DEV="golang python3 python3-virtualenvwrapper gcc clang"
  CONTAINER="podman podman-compose slirp4netns fuse-overlayfs"
  yum update -y
  yum install -y $BASIC $DEV $CONTAINER
fi

if [[ -f /etc/lsb-release ]]; then
  apt-get update -y
  BASIC="git curl neovim ncdu lsd bat fd-find tldr"
  DEV="golang python3 python3-virtualenvwrapper gcc clang"
  apt install -y $BASIC $DEV
fi
