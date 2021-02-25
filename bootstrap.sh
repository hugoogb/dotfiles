#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

BOLD='\033[1m'
ITALIC='\033[3m'
NORMAL="\033[0m"

color_print() {
  if [ -t 1 ]; then
    echo -e "$@$NORMAL"
  else
    echo "$@" | sed "s/\\\033\[[0-9;]*m//g"
  fi
}

stderr_print() {
  color_print "$@" >&2
}

warn() {
  stderr_print "$YELLOW$1"
}

error() {
  stderr_print "$RED$1"
  exit 1
}

info() {
  color_print "$CYAN$1"
}

ok() {
  color_print "$GREEN$1"
}

program_exists() {
  command -v $1 &> /dev/null
}

ACTUAL_DIR=`pwd`
DOTDIR=$HOME/dotfiles
TEMP_DIR=$HOME/temp
CONFIG_DIR=$HOME/.config
LOCAL_BIN_DIR=$HOME/.local/bin

if [ ! -d $TEMP_DIR ]; then
  mkdir $TEMP_DIR
fi

if [ ! -d $CONFIG_DIR ]; then
  mkdir $CONFIG_DIR
fi

if [ ! -d $LOCAL_BIN_DIR ]; then
  mkdir -p $LOCAL_BIN_DIR
fi

ok "Welcome to @hugoogb dotfiles!!!"
info "Starting bootstrap process..."

sleep 1

if ! program_exists "git"; then
  error "ERROR: git is not installed"
fi

# Dotfiles update
update_dotfiles() {
  cd $DOTDIR
  info "Updating dotfiles..."
  git config --global pull.rebase false
  git pull origin master
  cd $ACTUAL_DIR
}

clone_dotfiles() {
  if [ -d $DOTDIR ]; then
    warn "WARNING: dotfiles directory already exists"
    update_dotfiles
  else
    info "Cloning dotfiles..."
    git clone https://github.com/hugoogb/dotfiles.git $DOTDIR
    update_dotfiles
  fi

  ok "Dotfiles cloned and updated"
}

clone_update_repo() {
  clone_dotfiles
}

# qtile setup
qtile_setup() {
  info "Setting up qtile..."

  # needed to show wifi widget
  pip install psutil

  # rm -rf $HOME/.config/qtile
  # ln -sv $HOME/dotfiles/.config/qtile $HOME/.config/qtile
  cp -rfv $HOME/dotfiles/.config/qtile $HOME/.config/
}

# Rofi setup
rofi_setup() {
  info "Setting up rofi..."

  git clone https://github.com/davatorium/rofi-themes.git $TEMP_DIR/rofi-themes
  sudo cp -fv $TEMP_DIR/rofi-themes/User\ Themes/onedark.rasi /usr/share/rofi/themes/

  sudo cp -fv $HOME/dotfiles/.local/themes/onedark.rasi /usr/share/rofi/themes/

  # rm -rf $HOME/.config/rofi
  # ln -sv $HOME/dotfiles/.config/rofi $HOME/.config/rofi
  cp -rfv $HOME/dotfiles/.config/rofi $HOME/.config/
}

# Ranger setup
ranger_setup() {
  info "Setting up ranger..."

  # rm -rf $HOME/.config/ranger
  # mkdir -p $HOME/.config/ranger
  # ln -sv $HOME/dotfiles/.config/ranger/rc.conf $HOME/.config/ranger/rc.conf
  cp -rfv $HOME/dotfiles/.config/ranger $HOME/.config/

  RANGER_PLUGIN_DIR=$HOME/.config/ranger/plugins

  if [ ! -d $RANGER_PLUGIN_DIR ]; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/.config/ranger/plugins
  else
    warn "WARNING: ranger plugins already installed"
  fi
}

# Alacritty
alacritty_setup() {
  info "Setting up alacritty..."

  # rm -rf $HOME/.config/alacritty
  # mkdir -p $HOME/.config/alacritty
  # ln -sv $HOME/dotfiles/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
  # ln -sv $HOME/dotfiles/.config/alacritty/fonts.yaml $HOME/.config/alacritty/fonts.yaml
  # ln -sv $HOME/dotfiles/.config/alacritty/themes $HOME/.config/alacritty/themes
  cp -rfv $HOME/dotfiles/.config/alacritty $HOME/.config/

  info "Installing pycritty..."

  # Pycritty
  pip install pycritty
}

# Openbox setup
openbox_setup() {
  info "Setting up openbox..."

  # rm -rf $HOME/.config/openbox
  # ln -sv $HOME/dotfiles/.config/openbox $HOME/.config/openbox
  cp -rfv $HOME/dotfiles/.config/openbox $HOME/.config/
  # rm -rf $HOME/.config/tint2
  # ln -sv $HOME/dotfiles/.config/tint2 $HOME/.config/tint2
  cp -rfv $HOME/dotfiles/.config/tint2 $HOME/.config/
}

arch_setup() {
  qtile_setup
  rofi_setup
  ranger_setup
  alacritty_setup
  openbox_setup
}

# LSP Install
lsp_dependencies() {
  info "Installing LSP dependencies..."

  # npm setup
  NPM_GLOBAL_DIR=$HOME/.npm-global

  if [ ! -d $NPM_GLOBAL_DIR ]; then
    mkdir $NPM_GLOBAL_DIR
  fi

  npm config set prefix '~/.npm-global'

  npm i -g npm

  # Neovim providers
  npm install -g neovim
  pip install pynvim
}

# Installing oh-my-zsh
ohmyzsh_install() {
  info "Installing oh-my-zsh..."

  OH_MY_ZSH_DIR=$HOME/.oh-my-zsh

  if [ ! -d $OH_MY_ZSH_DIR ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    warn "WARNING: oh-my-zsh already installed"
  fi

  info "Installing zsh plugins..."

  ZSH_SYNTAX_HIGHLIGHTING_PLUGIN=$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

  if [ ! -d $ZSH_SYNTAX_HIGHLIGHTING_PLUGIN ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  else
    warn "WARNING: oh-my-zsh plugin: zsh-syntax-highlighting already installed"
  fi

  ZSH_K_PLUGIN=$HOME/.oh-my-zsh/custom/plugins/k

  if [ ! -d $ZSH_K_PLUGIN ]; then
    git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k
  else
    warn "WARNING: oh-my-zsh plugin: k already installed"
  fi

  ZSH_AUTOSUGGESTIONS_PLUGIN=$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

  if [ ! -d $ZSH_AUTOSUGGESTIONS_PLUGIN ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  else
    warn "WARNING: oh-my-zsh plugin: zsh-autosuggestions already installed"
  fi

  info "Installing starship..."

  if ! program_exists "starship"; then
    curl -fsSL https://starship.rs/install.sh | bash
  else
    warn "WARNING: starship already installed"
  fi
}

# Installing Vim-Plug
vimplug_install() {
  info "Installing vim-plug..."

  VIM_PLUG_FILE=$HOME/.config/nvim/autoload/plug.vim

  if [ ! -e $VIM_PLUG_FILE ]; then
    sh -c 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  else
    warn "WARNING: vim-plug already installed"
  fi
}

# Linking dotfiles
dotfiles_setup() {
  info "Setting up dotfiles (bash,zsh,starship,etc)..."

  # Link .bashrc
  # rm -rf $HOME/.bashrc
  # ln -sv $HOME/dotfiles/.bashrc $HOME/.bashrc
  cp -fv $HOME/dotfiles/.bashrc $HOME/

  # Link the zsh and starship prompt
  # rm -rf $HOME/.zshrc
  # ln -sv $HOME/dotfiles/.zshrc $HOME/.zshrc
  cp -fv $HOME/dotfiles/.zshrc $HOME/
  # rm -rf $HOME/.config/starship/
  # mkdir -p $HOME/.config/starship
  # ln -sv $HOME/dotfiles/.config/starship/starship.toml $HOME/.config/starship/starship.toml
  cp -rfv $HOME/dotfiles/.config/starship $HOME/.config/

  info "Copying (neo)vim plugins file..."

  NEOVIM_DIR=$HOME/.config/nvim

  if [ ! -d $NEOVIM_DIR ]; then
    mkdir -p $HOME/.config/nvim
  fi

  NEOVIM_PLUGINS_FILE=$HOME/.config/nvim/plug/plugins.vim

  if [ ! -e $NEOVIM_PLUGINS_FILE ]; then
    cp -rfv $HOME/dotfiles/.config/nvim/plug $HOME/.config/nvim/
  else
    warn "WARNING: neovim plugins file already exists, using existing file"
  fi
}

general_install() {
  lsp_dependencies
  ohmyzsh_install
  vimplug_install
  dotfiles_setup
}

# Bootstraping NVIM
nvim_bootstrap() {
  info "Bootstraping nVim..."

  nvim --headless "+PlugUpgrade" "+PlugInstall" "+qall"
  warn "WARNING: not performing :PlugUpdate and :PlugClean, do it manually"
}

nvim_copy_setup_files() {
  # Link neovim configuration
  info "Setting up (neo)vim config..."

  # rm -rf $HOME/.config/nvim/init.vim
  # ln -sv $HOME/dotfiles/.config/nvim/init.vim $HOME/.config/nvim/init.vim
  cp -fv $HOME/dotfiles/.config/nvim/init.vim $HOME/.config/nvim/
  # rm -rf $HOME/.config/nvim/general
  # ln -sv $HOME/dotfiles/.config/nvim/general $HOME/.config/nvim/general
  cp -rfv $HOME/dotfiles/.config/nvim/general $HOME/.config/nvim/
  # rm -rf $HOME/.config/nvim/keys
  # ln -sv $HOME/dotfiles/.config/nvim/keys $HOME/.config/nvim/keys
  cp -rfv $HOME/dotfiles/.config/nvim/keys $HOME/.config/nvim/
  # rm -rf $HOME/.config/nvim/colors
  # ln -sv $HOME/dotfiles/.config/nvim/colors $HOME/.config/nvim/colors
  cp -rfv $HOME/dotfiles/.config/nvim/theme $HOME/.config/nvim/
  # rm -rf $HOME/.config/nvim/lua
  # ln -sv $HOME/dotfiles/.config/nvim/lua $HOME/.config/nvim/lua
  cp -rfv $HOME/dotfiles/.config/nvim/lua $HOME/.config/nvim/
  # rm -rf $HOME/.config/nvim/plug-config
  # ln -sv $HOME/dotfiles/.config/nvim/plug-config $HOME/.config/nvim/plug-config
  cp -rfv $HOME/dotfiles/.config/nvim/plugconf $HOME/.config/nvim/
}

# Installing lsp servers
lsp_bootstrap() {
  info "Setting up lsp servers..."

  # LspInstall vimls
  npm install -g vim-language-server

  # LspInstall bashls
  npm install -g bash-language-server

  # LspInstall pyls
  pip install jedi
  pip install 'python-language-server[all]'
  pip install setuptools

  # LspInstall html
  npm install -g vscode-html-languageserver-bin

  # LspInstall cssls
  npm install -g vscode-css-languageserver-bin

  # LspInstall jsonls
  npm install -g vscode-json-languageserver

  # LspInstall tsserver
  npm install -g typescript typescript-language-server

  # LspInstall clangd
  # LspInstall cmake-language-server
  pip install cmake-language-server
}

nvim_setup() {
  nvim_bootstrap
  nvim_copy_setup_files
  lsp_bootstrap
}

main() {
  clone_update_repo
  arch_setup
  general_install
  nvim_setup
}

main

rm -rf $TEMP_DIR

ok "Dotfiles setup done!!!"
warn "WARNING: don't forget to reboot in order to get everything working properly"
