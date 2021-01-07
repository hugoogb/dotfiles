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

# check if running in laptop or desktop
laptop_or_desktop() {
  info "Checking if you are in laptop or desktop..."

  POWER_DIR=/sys/class/power_supply

  if [ "$(ls -A $POWER_DIR)" ]; then
    ok "Running in LAPTOP"
  else
    ok "Running in DESKTOP"
  fi
}

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
  laptop_or_desktop
  clone_dotfiles
}

# Installing
arch_pkg_install() {
  info "Installing pkg(s)..."

  # Install all pkgs of the list
  sudo pacman -S --needed --noconfirm - < $HOME/dotfiles/pkglist/pacman-pkglist.txt

  info "Setting up pkg(s)..."

  # lightdm
  sudo systemctl enable lightdm

  # Notifications
  sudo cp -fv $HOME/dotfiles/.local/services/notifications/org.freedesktop.Notifications.service /usr/share/dbus-1/services/

  # Bluetooth
  sudo systemctl enable bluetooth.service
  sudo cp -fv $HOME/dotfiles/.local/services/bluetooth/main.conf /etc/bluetooth/

  # SSH
  sudo systemctl enable sshd
}

# AUR helper (yay) install
aur_helper() {
  info "Installing AUR helper (yay)..."

  if ! program_exists "yay"; then
    git clone https://aur.archlinux.org/yay-git.git $TEMP_DIR/yay
    cd $TEMP_DIR/yay
    makepkg -si
    cd $ACTUAL_DIR
  else
    warn "WARNING: yay already installed"
  fi

  if ! program_exists "yay"; then
    error "ERROR: yay is not installed, rerun script or install manually"
  fi
}

# Install all AUR packages
aur_pkg_install() {
  info "Installing AUR pkg(s)..."

  # Install all pkgs of the list
  yay -S --needed --nocleanmenu --nodiffmenu --noeditmenu --noupgrademenu - < $HOME/dotfiles/pkglist/yay-pkglist.txt

  # Bluetooth autoconnect trusted devices
  sudo systemctl enable bluetooth-autoconnect
}

arch_setup(){
  info "Setting up .xprofile..."

  # rm $HOME/.xprofile
  # ln -sv $HOME/dotfiles/.xprofile $HOME/.xprofile
  cp -fv $HOME/dotfiles/.xprofile $HOME/

  info "Downloading material black blueberry theme and custom mouse..."

  mkdir $TEMP_DIR/themes
  cd $TEMP_DIR/themes

  THEME=/usr/share/themes/Material-Black-Blueberry
  ICON_THEME=/usr/share/icons/Material-Black-Blueberry-Suru
  CURSOR_THEME=/usr/share/icons/Breeze

  if [ ! -d $THEME ]; then
    curl https://raw.githubusercontent.com/hugoogb/themes/master/Material-Black-Blueberry_1.9.1.zip -o Material-Black-Blueberry.zip
    unzip -q Material-Black-Blueberry.zip
    sudo cp -rf $TEMP_DIR/themes/Material-Black-Blueberry /usr/share/themes/
  else
    warn "WARNING: Material Black Blueberry theme already downloaded"
  fi

  if [ ! -d $ICON_THEME ]; then
    curl https://raw.githubusercontent.com/hugoogb/themes/master/Material-Black-Blueberry-Suru_1.9.1.zip -o Material-Black-Blueberry-Suru.zip
    unzip -q Material-Black-Blueberry-Suru.zip
    sudo cp -rf $TEMP_DIR/themes/Material-Black-Blueberry-Suru /usr/share/icons/
  else
    warn "WARNING: Material Black Blueberry Suru icon theme already downloaded"
  fi

  if [ ! -d $CURSOR_THEME ]; then
    curl https://raw.githubusercontent.com/hugoogb/themes/master/165371-Breeze.tar.gz -o Breeze.tar.gz
    tar -xf Breeze.tar.gz
    sudo cp -rf $TEMP_DIR/themes/Breeze /usr/share/icons/
  else
    warn "WARNING: Breeze cursor theme already downloaded"
  fi

  cd $ACTUAL_DIR

  sudo cp -fv $HOME/dotfiles/.local/themes/index.theme /usr/share/icons/default/

  # rm $HOME/.gtkrc-2.0
  # ln -sv $HOME/dotfiles/.gtkrc-2.0 $HOME/.gtkrc-2.0
  cp -fv $HOME/dotfiles/.gtkrc-2.0 $HOME/
  # rm -rf $HOME/.config/gtk-3.0
  # ln -sv $HOME/dotfiles/.config/gtk-3.0 $HOME/.config/gtk-3.0
  cp -rfv $HOME/dotfiles/.config/gtk-3.0 $HOME/.config/
}

# grub themes installation, configure them with grub-customizer
grub_themes_install() {
  info "Downloading vimix grub theme..."

  GRUB_THEME_DIR=/boot/grub/themes/

  GRUB_VIMIX_THEME_DIR=/boot/grub/themes/Vimix
  VIMIX_CLONE_DIR=$TEMP_DIR/grub2-theme-vimix

  if [ ! -d $GRUB_VIMIX_THEME_DIR ]; then
    git clone https://github.com/Se7endAY/grub2-theme-vimix.git $VIMIX_CLONE_DIR
    sudo cp -rf $VIMIX_CLONE_DIR/Vimix $GRUB_THEME_DIR
  else
    warn "WARNING: Vimix grub theme already downloaded"
  fi
}

# lightdm setup
lightdm_setup() {
  info "Setting up lightdm..."

  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm.conf /etc/lightdm/
  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm-webkit2-greeter.conf /etc/lightdm/
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
  if ! program_exists "pycritty"; then
    git clone https://github.com/antoniosarosi/pycritty $HOME/.config/alacritty/pycritty
    ln -sf $HOME/.config/alacritty/pycritty/src/main.py $HOME/.local/bin/pycritty
    chmod 755 $HOME/.config/alacritty/pycritty/src/main.py
  else
    warn "WARNING: pycritty already installed"
  fi
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

arch_install_setup() {
  arch_pkg_install
  aur_helper
  aur_pkg_install
  arch_setup
  grub_themes_install
  lightdm_setup
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

  NEOVIM_PLUGINS_FILE=$HOME/.config/nvim/plug/plugins.vim

  if [ ! -e $NEOVIM_PLUGINS_FILE ]; then
    cp -rfv $HOME/dotfiles/.config/nvim/plug $HOME/.config/nvim/
  else
    mkdir $HOME/.config/nvim
    warn "WARNING: neovim plugins file already exists, using existing file"
  fi

  # ssh config
  SSH_CONFIG_FILE=$HOME/.ssh/config

  if [ ! -d $SSH_DIR ]; then
    mkdir $HOME/.ssh
  elif [ ! -e $SSH_CONFIG_FILE ]; then
    cp -fv $HOME/dotfiles/.local/.ssh/config $HOME/.ssh/
  else
    warn "WARNING: ssh config file already exists, using existing file"
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
  arch_install_setup
  general_install
  nvim_setup
}

main

rm -rf $TEMP_DIR

ok "Dotfiles installed and setup done!!!"
warn "WARNING: don't forget to reboot in order to get everything working properly"
