
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