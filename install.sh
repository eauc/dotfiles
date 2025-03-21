#/usr/bin/env bash

echo "Installing apt packages"
sudo apt install -y \
  curl \
  git \
  tree \
  build-essential \
  autotools-dev dh-autoreconf \
  fzf \
  libreadline-dev \
  wl-clipboard xsel

if ! command -v -- "kitty" > /dev/null 2>&1; then
  echo "Installing kitty"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
  # your system-wide PATH)
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
  # Place the kitty.desktop file somewhere it can be found by the OS
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  # Update the paths to the kitty and its icon in the kitty desktop file(s)
  sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
  # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
  echo 'kitty.desktop' > ~/.config/xdg-terminals.list
fi


if [ ! -f ~/.local/share/fonts/JetBrainsMono.zip ]; then
  echo "Installing Nerd fonts"
  mkdir -p ~/.local/share/fonts
  cd ~/.local/share/fonts
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
  unzip JetBrainsMono.zip
  cd -
fi

if ! command -v -- "nvim" > /dev/null 2>&1; then
  echo "Installing nvim"
  cd ~/Downloads
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  cd -
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
