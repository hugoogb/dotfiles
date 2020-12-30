#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh

# LSP Install
lsp_install() {
  echo "${PURPLE}Installing LSP servers and dependencies...${RESTORE}"

  mkdir $HOME/.npm-global
  npm config set prefix '~/.npm-global'

  npm i -g npm

  # Neovim providers
  npm install -g neovim
  pip install --upgrade pynvim

  # Python lang setup
  pip install jedi
  pip install 'python-language-server[all]'
  pip install -U setuptools

  # Rust lang setup
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
  curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer
  chmod +x ~/.local/bin/rust-analyzer

  # CMake setup
  pip install cmake-language-server

  # npm i -g bash-language-server
  # npm i -g vscode-css-languageserver-bin
  # npm i -g vscode-html-languageserver-bin
  # npm i -g vscode-json-languageserver
  # npm i -g typescript-language-server
}

# Installing oh-my-zsh
ohmyzsh_install() {
  echo "${PURPLE}Installing oh-my-zsh...${RESTORE}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "${PURPLE}Installing zsh plugins...${RESTORE}"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k

  echo "${PURPLE}Installing starship...${RESTORE}"
  curl -fsSL https://starship.rs/install.sh | bash
}

# Installing Vim-Plug
vimplug_install() {
  echo "${PURPLE}Installing nvim-plug...${RESTORE}"
  sh -c 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

# Linking dotfiles
link_dotfiles() {
  echo "${PURPLE}Linking dotfiles...${RESTORE}"
  # Link .bashrc
  rm -rf $HOME/.bashrc
  ln -sv $HOME/dotfiles/.bashrc $HOME/.bashrc

  # Link the zsh and starship prompt
  rm -rf $HOME/.zshrc
  ln -sv $HOME/dotfiles/.zshrc $HOME/.zshrc
  rm -rf $HOME/.config/starship/
  mkdir -pv $HOME/.config/starship
  ln -sv $HOME/dotfiles/.config/starship/starship.toml $HOME/.config/starship

  # Link neovim configuration
  rm -rf $HOME/.config/nvim/init.vim
  ln -sv $HOME/dotfiles/.config/nvim/init.vim $HOME/.config/nvim/init.vim
  rm -rf $HOME/.config/nvim/general
  ln -sv $HOME/dotfiles/.config/nvim/general $HOME/.config/nvim/general
  rm -rf $HOME/.config/nvim/keys
  ln -sv $HOME/dotfiles/.config/nvim/keys $HOME/.config/nvim/keys
  rm -rf $HOME/.config/nvim/colors
  ln -sv $HOME/dotfiles/.config/nvim/colors $HOME/.config/nvim/colors
  rm -rf $HOME/.config/nvim/lua
  ln -sv $HOME/dotfiles/.config/nvim/lua $HOME/.config/nvim/lua
  rm -rf $HOME/.config/nvim/plug-config
  ln -sv $HOME/dotfiles/.config/nvim/plug-config $HOME/.config/nvim/plug-config
  rm -rf $HOME/.config/nvim/vim-plug
  cp -rfv $HOME/dotfiles/.config/nvim/vim-plug $HOME/.config/nvim/vim-plug

  # Link ssh config
  mkdir $HOME/.ssh
  rm -rf $HOME/.ssh/config
  ln -sv $HOME/dotfiles/.local/.ssh/config $HOME/.ssh/config
}

nvim_setup() {
  . $HOME/dotfiles/scripts/nvim-bootstrap.sh
}

main() {
  lsp_install
  ohmyzsh_install
  vimplug_install
  link_dotfiles
  nvim_setup
}

main
