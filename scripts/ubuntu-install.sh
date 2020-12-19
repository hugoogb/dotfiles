#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh

# Installing nvim, zsh, etc.
ubuntu_install() {
  echo "${PURPLE}Installing pkg...${RESTORE}"
  sudo apt update
  sudo add-apt-repository universe

  sudo apt install -y make cmake g++ tmux neofetch curl zsh fzf npm tree clang clangd python3-pip python2 silversearcher-ag ripgrep

  # Nodejs install
  curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
  sudo apt-get install -y nodejs

  # Neovim dependencies
  sudo apt install -y gettext libtool libtool-bin autoconf automake pkg-config unzip

  # ASCII art
  sudo apt install -y figlet lolcat

  # pip and npm setup
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py --user
  pip install --user --upgrade pip
  rm -rf get-pip.py

  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'

  npm i -g npm
}

# Installing neovim latest release
nvim_nightly() {
  echo "${PURPLE}Installing nvim-nightly...${RESTORE}"
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update
  sudo apt install neovim
}

# Installing tmux plugins
tmux_plugins() {
  echo "${PURPLE}Installing tmux plugins...${RESTORE}"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  # Link tmux configuration file
  rm -rf $HOME/.tmux.conf
  ln -sv $HOME/dotfiles/.config/tmux/.tmux.conf $HOME/.tmux.conf
}

# LSP things, vim plug, ohmyzsh and link dotfiles
general_install() {
  . $HOME/dotfiles/scripts/general-install.sh
}

# ALLDONE Message
all_done() {
  echo "${B_GREEN}Install and setup done succesfully!!!${RESTORE}"
}

main() {
  ubuntu_install
  nvim_nightly
  tmux_plugins
  general_install
  all_done
}

main
