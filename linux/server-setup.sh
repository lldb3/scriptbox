if [[ -f /etc/redhat-release ]]; then
  BASIC="git curl neovim util-linux-user ncdu exa bat fd-find tldr"
  DEV="golang python3 python3-virtualenvwrapper"
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

cat >~/.zshrc <<EOF
HISTCONTROL=erasedups:ignorespace

################ PATHs ################
export PATH=$PATH:$HOME/.local/bin/

## Go path
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

## Cargo
export PATH="$HOME/.cargo/bin:$PATH"

################ Virtualenvwrapper  ################
export WORKON_HOME=$HOME/.venvs
if [[ -f /etc/redhat-release ]]; then
  source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
else if [[ -f /etc/lsb-release ]]; then
  source /usr/bin/virtualenvwrapper.sh
fi

# export MANPATH="/usr/local/man:$MANPATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

################ ANTIGEN ################
source ~/.antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle colored-man-pages
antigen bundle git
antigen bundle rsync
antigen bundle zsh-256color

## Themes
antigen theme gentoo
antigen apply

################ Aliases ################

alias dc="docker compose"

##### Optional aliases
alias ls="exa"
alias l="exa -laag"
alias cat="bat -p"

phan() {
  docker run -v $PWD:/mnt/src --rm -u "$(id -u):$(id -g)" phanphp/phan:latest $@
  return $?
}
EOF

chsh -s /usr/bin/zsh

echo "----------"
echo "-- Done --"
