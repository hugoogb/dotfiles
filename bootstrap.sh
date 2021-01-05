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
DOTDIR="$HOME/dotfiles"

ok "Welcome to @hugoogb dotfiles!!!"
info "Starting bootstrap process..."

if ! program_exists "git"; then
  error "Git is not installed"
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
    warn "WARNING: dotfiles dir already exists..."
    update_dotfiles
  else
    info "Cloning dotfiles..."
    git clone https://github.com/hugoogb/dotfiles.git $DOTDIR
    update_dotfiles
  fi

  ok "Dotfiles cloned and updated succesfully!!!"
}


clone_update_repo() {
  clone_dotfiles
}

# Installing
arch_pkg_install() {
  info "Installing pkg(s)..."

  # Install all pkgs of the list
  sudo pacman -S --needed --noconfirm - < $HOME/dotfiles/pkglist/pacman-pkglist.txt

  info "Setting up pkg(s)"

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
    git clone https://aur.archlinux.org/yay-git.git $HOME/.yay
    cd $HOME/.yay
    makepkg -si
    cd $ACTUAL_DIR
    rm -rf $HOME/.yay
  else
    warn "WARNING: yay already installed"
  fi
}

# Install all AUR packages
aur_pkg_install() {
  info "Installing AUR pkg(s)..."

  # Install all pkgs of the list
  yay -S --needed --noconfirm --nocleanmenu --nodiffmenu --noeditmenu --noupgrademenu - < $HOME/dotfiles/pkglist/yay-pkglist.txt

  # Bluetooth autoconnect trusted devices
  sudo systemctl enable bluetooth-autoconnect
}

arch_setup(){
  info "Configuring .xprofile..."

  mkdir -p $HOME/.config
  mkdir -p $HOME/.local/bin

  # .xprofile
  rm $HOME/.xprofile
  ln -sv $HOME/dotfiles/.xprofile $HOME/.xprofile

  info "Installing material black theme and custom mouse..."

  mkdir -p $HOME/temp
  cd $HOME/temp
  wget -L -i $HOME/dotfiles/.local/themes/url-themes.txt
  unzip Material-Black-Blueberry_1.9.1.zip
  unzip Material-Black-Blueberry-Suru_1.9.1.zip
  tar -xf 165371-Breeze.tar.gz
  sudo mv $HOME/temp/Material-Black-Blueberry /usr/share/themes
  sudo mv $HOME/temp/Material-Black-Blueberry-Suru /usr/share/icons
  sudo mv $HOME/temp/Breeze /usr/share/icons
  cd $ACTUAL_DIR
  rm -rf $HOME/temp

  sudo cp -fv $HOME/dotfiles/.local/themes/index.theme /usr/share/icons/default

  # ~/.gtkrc-2.0
  rm $HOME/.gtkrc-2.0
  ln -sv $HOME/dotfiles/.gtkrc-2.0 $HOME/.gtkrc-2.0
  # ~/.config/gtk-3.0/settings.ini
  rm -rf $HOME/.config/gtk-3.0
  ln -sv $HOME/dotfiles/.config/gtk-3.0 $HOME/.config/gtk-3.0

  # qt theme
  echo "export QT_STYLE_OVERRIDE=kvantum" >> $HOME/.profile
}

# lightdm setup
lightdm_setup() {
  info "Setting up lightdm..."

  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm.conf /etc/lightdm
  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm-webkit2-greeter.conf /etc/lightdm
}

# qtile setup
qtile_setup() {
  info "Setting up qtile..."

  # needed to show wifi widget
  pip install psutil

  rm -rf $HOME/.config/qtile
  ln -sv $HOME/dotfiles/.config/qtile $HOME/.config/qtile
}

# Rofi setup
rofi_setup() {
  info "Setting up rofi..."

  cd $HOME
  git clone https://github.com/davatorium/rofi-themes.git
  sudo cp -fv rofi-themes/User\ Themes/onedark.rasi /usr/share/rofi/themes
  cd $ACTUAL_DIR
  rm -rf $HOME/rofi-themes

  sudo cp -fv $HOME/dotfiles/.local/themes/onedark.rasi /usr/share/rofi/themes

  rm -rf $HOME/.config/rofi
  ln -sv $HOME/dotfiles/.config/rofi $HOME/.config/rofi
}

# Ranger setup
ranger_setup() {
  info "Setting up ranger..."

  git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/.config/ranger/plugins

  rm -rf $HOME/.config/ranger
  ln -sv $HOME/dotfiles/.config/ranger/rc.conf $HOME/.config/ranger/rc.conf
}

# Alacritty
alacritty_setup() {
  info "Setting up alacritty..."

  rm -rf $HOME/.config/alacritty
  mkdir -p $HOME/.config/alacritty
  ln -sv $HOME/dotfiles/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml
  ln -sv $HOME/dotfiles/.config/alacritty/fonts.yaml $HOME/.config/alacritty/fonts.yaml
  ln -sv $HOME/dotfiles/.config/alacritty/themes $HOME/.config/alacritty/themes

  info "Installing pycritty..."

  # Pycritty
  git clone https://github.com/antoniosarosi/pycritty $HOME/.config/alacritty
  ln -sf $HOME/.config/alacritty/pycritty/src/main.py $HOME/.local/bin/pycritty
  chmod 755 $HOME/.config/alacritty/pycritty/src/main.py
}

# Openbox setup
openbox_setup() {
  info "Setting up openbox..."

  rm -rf $HOME/.config/openbox
  ln -sv $HOME/dotfiles/.config/openbox $HOME/.config/openbox
  rm -rf $HOME/.config/tint2
  ln -sv $HOME/dotfiles/.config/tint2 $HOME/.config/tint2
}

arch_install_setup() {
  arch_pkg_install
  aur_helper
  aur_pkg_install
  arch_setup
  lightdm_setup
  qtile_setup
  rofi_setup
  ranger_setup
  alacritty_setup
  openbox_setup
}

# LSP Install
lsp_install() {
  info "Installing LSP servers (and dependencies)..."

  # Rust lang setup

  if ! program_exists "rustup"; then
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
  else
    warn "WARNING: rust already installed"
  fi

  if ! program_exists "rust-analyzer"; then
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer
    chmod +x ~/.local/bin/rust-analyzer
  else
    warn "WARNING: rust-analyzer already installed"
  fi

  # npm setup
  mkdir $HOME/.npm-global
  npm config set prefix '~/.npm-global'

  npm i -g npm

  # Neovim providers
  npm install -g neovim
  pip install pynvim

  # Python lang setup
  pip install jedi
  pip install 'python-language-server[all]'
  pip install setuptools

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
  info "Installing oh-my-zsh..."

  OH_MY_ZSH_DIR=$HOME/.oh-my-zsh

  if [ -d $OH_MY_ZSH_DIR ]; then
    warn "WARNING: oh-my-zsh already installed"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  info "Installing zsh plugins..."

  ZSH_SYNTAX_HIGHLIGHTING_PLUGIN=$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

  if [ -d $ZSH_SYNTAX_HIGHLIGHTING_PLUGIN ]; then
    warn "WARNING: oh-my-zsh plugin: zsh-syntax-highlighting already installed"
  else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  fi

  ZSH_K_PLUGIN=$HOME/.oh-my-zsh/custom/plugins/k

  if [ -d $ZSH_K_PLUGIN ]; then
    warn "WARNING: oh-my-zsh plugin: k already installed"
  else
    git clone https://github.com/supercrabtree/k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/k
  fi

  ZSH_AUTOSUGGESTIONS_PLUGIN=$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

  if [ -d $ZSH_AUTOSUGGESTIONS_PLUGIN ]; then
    warn "WARNING: oh-my-zsh plugin: zsh-autosuggestions already installed"
  else
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
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
  sh -c 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

# Linking dotfiles
link_dotfiles() {
  info "Linking dotfiles..."

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

  NEOVIM_PLUGINS_FILE=$HOME/.config/nvim/vim-plug/plugins.vim

  if [ -e $NEOVIM_PLUGINS_FILE ]; then
    warn "WARNING: neovim plugins file already exists, using existing file"
  else
    cp -rfv $HOME/dotfiles/.config/nvim/vim-plug $HOME/.config/nvim/vim-plug
  fi

  # ssh config
  SSH_CONFIG_FILE=$HOME/.ssh/config

  if [ -e $NEOVIM_PLUGINS_FILE ]; then
    warn "WARNING: ssh config file already exists, using existing file"
  else
    mkdir $HOME/.ssh
    cp -uv $HOME/dotfiles/.local/.ssh/config $HOME/.ssh/config
  fi
}

general_install() {
  lsp_install
  ohmyzsh_install
  vimplug_install
  link_dotfiles
}

# Bootstraping NVIM
nvim_bootstrap() {
  info "Bootstraping nVim..."
  nvim --headless "+PlugUpgrade" "+PlugInstall" "+qall"
  nvim --headless "+PlugUpdate" "+PlugClean!" "+qall"
}

# Installing lsp servers
lsp_bootstrap() {
  info "Setting up lsp servers..."
  nvim --headless "+LspInstall bashls" "+LspInstall vimls" "+LspInstall html" "+qall"
  nvim --headless "+LspInstall tsserver" "+LspInstall jsonls" "+qall"
  nvim --headless "+LspInstall cssls" "+LspInstall sumneko_lua" "+qall"

  # Listed here are installed manually
  # LspInstall pyls
  # LspInstall clangd
  # LspInstall rust_analyzer
  # LspInstall cmake-language-server
}

nvim_setup() {
  nvim_bootstrap
  lsp_bootstrap
}

main() {
  clone_update_repo
  arch_install_setup
  general_install
  nvim_setup
}

main

echo
ok "Dotfiles installed and setup done!!!"
warn "WARNING: don't forget to reboot in order to get everything working properly"
