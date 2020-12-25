#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh

ACTUAL_DIR=`pwd`

# Installing
arch_install() {
  echo "${PURPLE}Installing pkg...${RESTORE}"

  # pacman -Qqen > pacman-pkglist.txt used to generate the file with all packages
  # Install all pkg of the list
  sudo pacman -S --needed - < $HOME/dotfiles/scripts/pacman-pkglist.txt

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
  echo "${PURPLE}Installing yay...${RESTORE}"

  # sudo pacman -S base-devel git

  git clone https://aur.archlinux.org/yay-git.git $HOME/.yay
  cd $HOME/.yay
  makepkg -si
  cd $ACTUAL_DIR
}

# Install all AUR packages
yay_install() {
  echo "${PURPLE}Installing yay pkg...${RESTORE}"

  # pacman -Qqem > yay-pkglist.txt used to generate the file with all AUR packages installed
  # Install all pkg of the list
  yay -S --needed - < $HOME/dotfiles/scripts/yay-pkglist.txt
}

arch_setup(){
  echo "${PURPLE}Linking .xprofile...${RESTORE}"

  # .xprofile
  rm $HOME/.xprofile
  ln -sv $HOME/dotfiles/.xprofile $HOME/.xprofile

  echo "${PURPLE}Installing material black theme and custom mouse...${RESTORE}"

  mkdir -v $HOME/temp
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
  mkdir -pv $HOME/.config/gtk-3.0
  ln -sv $HOME/dotfiles/.config/gtk-3.0 $HOME/.config/gtk-3.0
}

# lightdm setup
lightdm_setup() {
  echo "${PURPLE}Setting up lightdm...${RESTORE}"

  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm.conf /etc/lightdm
  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm-webkit2-greeter.conf /etc/lightdm
}

# qtile setup
qtile_setup() {
  echo "${PURPLE}Installing qtile...${RESTORE}"

  # needed to show wifi widget
  pip install psutil

  rm -rf $HOME/.config/qtile
  ln -sv $HOME/dotfiles/.config/qtile $HOME/.config/qtile
}

# Rofi setup
rofi_setup() {
  echo "${PURPLE}Setting up rofi...${RESTORE}"

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
  echo "${PURPLE}Setting up qtile...${RESTORE}"

  . $HOME/dotfiles/ranger/install-plugs.sh

  rm -rf $HOME/.config/ranger
  ln -sv $HOME/dotfiles/.config/ranger/rc.conf $HOME/.config/ranger/rc.conf
}

# Alacritty
alacritty_setup() {
  echo "${PURPLE}Setting up alacritty...${RESTORE}"

  rm -rf $HOME/.config/alacritty
  mkdir -p $HoME/.config/alacritty
  ln -sv $HOME/dotfiles/.config/alacritty/alacritty.yaml $HOME/.config/alacritty/alacritty.yaml
  ln -sv $HOME/dotfiles/.config/alacritty/fonts.yaml $HOME/.config/alacritty/fonts.yaml
  cp -fv $HOME/dotfiles/.config/themes $HOME/.config/alacritty/themes

  # Pycritty
  curl -sL "https://raw.githubusercontent.com/antoniosarosi/pycritty/master/install.sh" | bash -s [fonts]
}

# Openbox setup
openbox_setup() {
  echo "${PURPLE}Setting up openbox...${RESTORE}"

  rm -rf $HOME/.config/openbox
  ln -sv $HOME/dotfiles/.config/openbox $HOME/.config/openbox
  rm -rf $HOME/.config/tint2
  ln -sv $HOME/dotfiles/.config/tint2 $HOME/.config/tint2
}

# Xmonad setup
xmonad_setup() {
  echo "${PURPLE}Setting up xmonad...${RESTORE}"

  rm -rf $HOME/.config/xmonad
  ln -sv $HOME/dotfiles/.config/xmonad $HOME/.config/xmonad
  rm -rf $HOME/.config/xmobar
  ln -sv $HOME/dotfiles/.config/xmobar $HOME/.config/xmobar

  cp -fv $HOME/dotfiles/.local/bin/battery $HOME/.local/bin
  cp -fv $HOME/dotfiles/.local/bin/brightness $HOME/.local/bin
  cp -fv $HOME/dotfiles/.local/bin/percentage $HOME/.local/bin
  cp -fv $HOME/dotfiles/.local/bin/volume $HOME/.local/bin
}

# Installing neovim latest release
nvim_nightly() {
  echo "${PURPLE}Installing nvim-nightly...${RESTORE}"
}

# LSP things, vim plug, ohmyzsh and link dotfiles
general_install() {
  . $HOME/dotfiles/scripts/general-install.sh
}

# ALLDONE Message
all_done() {
  echo
  echo "${B_L_GREEN}Install and setup done succesfully!!!${RESTORE}"
}

main() {
  arch_install
  aur_helper
  yay_install
  arch_setup
  lightdm_setup
  qtile_setup
  rofi_setup
  ranger_setup
  alacritty_setup
  openbox_setup
  xmonad_setup
  nvim_nightly
  general_install
  all_done
}

main
