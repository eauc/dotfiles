#/usr/bin/env bash

echo "Installing apt packages"
sudo apt install -y \
  curl \
  git \
  build-essential \
  autotools-dev dh-autoreconf \
  fzf \
  libreadline-dev \
  wl-clipboard xsel

if ! command -v -- "kitty" > /dev/null 2>&1; then
  echo "Installing kitty"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi

echo "Installing mise"
if [ ! -f ~/.local/bin/mise ]; then
  curl https://mise.run | sh
fi

if [ ! -L ~/.bashrc ]; then
  echo "Linking bashrc"
  rm -f ~/.bashrc
  ln -s ~/dotfiles/.bashrc ~/.bashrc
fi

if [ ! -L ~/.gitconfig ]; then
  echo "Linking gitconfig"
  rm -f ~/.gitconfig
  ln -s ~/dotfiles/.gitconfig ~/.gitconfig
fi

if [ ! -L ~/.config/kitty ]; then
  echo "Linking kitty config"
  rm -rf ~/.config/kitty
  ln -s ~/dotfiles/kitty ~/.config/kitty
fi

if [ -d ~/.config/mise ]; then
  echo "Removing default mise config"
  rm -rf ~/.config/mise
fi

if [ ! -L ~/.config/nvim ]; then
  echo "Linking nvim config"
  rm -rf ~/.config/nvim
  ln -s ~/dotfiles/nvim ~/.config/nvim
fi

. ~/.bashrc

mise install
