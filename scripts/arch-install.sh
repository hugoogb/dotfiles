#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh

ACTUAL_DIR=`pwd`

# Installing
arch_install() {
  echo "${PURPLE}Installing pkg...${RESTORE}"

  # pacman -Qqen > pacman-pkglist.txt used to generate the file with all packages
  # Install all pkg of the list
  sudo pacman -S --needed - < $HOME/dotfiles/scripts/pacman-pkglist.txt

  # Internet
  # sudo pacman -S network-manager-applet

  # xorg and lightdm
  # sudo pacman -S xorg xorg-xinit
  # sudo pacman -S lightdm lightdm-gtk-greeter qtile firefox
  sudo systemctl enable lightdm

  # sudo pacman -S alacritty zsh rofi feh nitrogen
  # sudo pacman -S python-pip nodejs npm clang

  # Fonts
  # sudo pacman -S ttf-dejavu ttf-liberation noto-fonts

  # Audio
  # sudo pacman -S pulseaudio pavucontrol pamixer brightnessctl arandr

  # Storage
  # sudo pacman -S udiskie ntfs-3g

  # Icons
  # sudo pacman -S volumeicon cbatticon upower

  # Notifications
  # sudo pacman -S libnotify notification-daemon
  sudo cp -fv $HOME/dotfiles/.local/services/notifications/org.freedesktop.Notifications.service /usr/share/dbus-1/services/

  # Media transfer protocol
  # sudo pacman -S libmtp

  # File Manager
  # sudo pacman -S thunar ranger pcmanfm

  # Trash
  # sudo pacman -S glib2 gvfs

  # Cursor
  # sudo pacman -S xcb-util-cursor

  # Util
  # sudo pacman -S unzip tree cloc neofetch fzf the_silver_searcher ripgrep

  # Appearance and composer
  # sudo pacman -S lxappearance picom

  # Multimedia
  # sudo pacman -S geeqie vlc okular

  # Bluetooth
  # sudo pacman -S bluez bluez-utils blueman
  sudo systemctl enable bluetooth.service
  sudo cp -fv $HOME/dotfiles/.local/services/bluetooth/main.conf /etc/bluetooth/

  # ASCII art
  # sudo pacman -S figlet lolcat

  # SSH
  # sudo pacman -S openssh
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

  # Fonts
  # yay -S nerd-fonts-ubuntu-mono nerd-fonts-fira-code

  # Media transfer
  # yay -S simple-mtpfs

  # vlc dark theme
  # yay -S vlc-arc-dark-git

  # Visual studio code
  # yay -S visual-studio-code-bin

  # Brave browser
  # yay -S brave-bin
}

arch_setup(){
  echo "${PURPLE}Linking .xprofile...${RESTORE}"

  # .xprofile
  rm $HOME/.xprofile
  ln -sv $HOME/dotfiles/.xprofile $HOME/.xprofile

  echo "${PURPLE}Installing material black theme and custom mouse...${RESTORE}"

  sudo cp -rf $HOME/dotfiles/.local/themes/Material-Black-Blueberry /usr/share/themes
  sudo cp -rf $HOME/dotfiles/.local/themes/Material-Black-Blueberry-Suru /usr/share/icons
  sudo cp -rf $HOME/dotfiles/.local/themes/Breeze /usr/share/icons
  sudo cp -rf $HOME/dotfiles/.local/themes/index.theme /usr/share/icons/default

  # ~/.gtkrc-2.0
  rm -rf $HOME/.gtkrc-2.0
  ln -sv $HOME/dotfiles/.gtkrc-2.0 $HOME/.gtkrc-2.0
  # ~/.config/gtk-3.0/settings.ini
  rm -rf $HOME/.config/gtk-3.0
  mkdir -pv $HOME/.config/gtk-3.0
  ln -sv $HOME/dotfiles/.config/gtk-3.0 $HOME/.config/gtk-3.0
}

# lightdm setup
lightdm_setup() {
  echo "${PURPLE}Setting up lightdm...${RESTORE}"

  # sudo pacman -S lightdm-webkit2-greeter
  # yay -S lightdm-webkit-theme-aether

  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm.conf /etc/lightdm
  sudo cp -fv $HOME/dotfiles/.config/lightdm/lightdm-webkit2-greeter.conf /etc/lightdm
}

# qtile setup
qtile_setup() {
  echo "${PURPLE}Installing qtile...${RESTORE}"
  # sudo pacman -S qtile pacman-contrib

  rm -rf $HOME/.config/qtile
  ln -sv $HOME/dotfiles/.config/qtile $HOME/.config/qtile
}

# Rofi setup
rofi_setup() {
  echo "${PURPLE}Setting up rofi...${RESTORE}"

  # sudo pacman -S papirus-icon-theme

  cd $HOME
  git clone https://github.com/davatorium/rofi-themes.git
  sudo cp -fv rofi-themes/User\ Themes/onedark.rasi /usr/share/rofi/themes
  cd $ACTUAL_DIR

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
  ln -sv $HOME/dotfiles/.config/alacritty $HOME/.config/alacritty

  mkdir -pv $HOME/.local/bin
  ln -sv $HOME/.config/alacritty/pycritty/src/main.py $HOME/.local/bin/pycritty
  chmod 755 $HOME/.config/alacritty/pycritty/src/main.py
}

# Openbox setup
openbox_setup() {
  echo "${PURPLE}Setting up openbox...${RESTORE}"

  # sudo pacman -S openbox tint2

  rm -rf $HOME/.config/openbox
  ln -sv $HOME/dotfiles/.config/openbox $HOME/.config/openbox
  rm -rf $HOME/.config/tint2
  ln -sv $HOME/dotfiles/.config/tint2 $HOME/.config/tint2
}

# Xmonad setup
xmonad_setup() {
  echo "${PURPLE}Setting up xmonad...${RESTORE}"

  # sudo pacman -S xmonad xmonad-contrib xmobar trayer xdotool

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

  # yay -S neovim-nightly-git
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
