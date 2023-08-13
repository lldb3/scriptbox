if [[ -f /etc/redhat-release ]]; then
  BASIC="git curl neovim util-linux-user ncdu exa bat fd-find tldr"
  DEV="golang python3 python3-virtualenvwrapper gcc clang"
  CONTAINER="podman podman-compose slirp4netns fuse-overlayfs"
  yum update -y
  yum install -y $BASIC $DEV $CONTAINER
fi

if [[ -f /etc/lsb-release ]]; then
  apt-get update -y
  apt-get install -y git curl zsh neovim ncdu batcat exa docker golang python3 python3-virtualenvwrapper
fi

if [[ ! -e ~/.antigen ]]; then
  git clone https://github.com/zsh-users/antigen.git ~/.antigen
fi

echo "Updating $HOME/.zshrc, saving old to .old"

if [[ -e ~/.zshrc && -f ~/.zshrc ]]; then
  mv ~/.zshrc{,.old}
fi

cp zshrc $HOME/.zshrc

chsh -s /usr/bin/zsh

echo "----------"
echo "-- Done --"
