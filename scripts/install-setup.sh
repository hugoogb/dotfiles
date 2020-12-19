#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh
. $HOME/dotfiles/scripts/distro-detect.sh

select_distro() {
  if [[ "$DISTRO" == "$UBUNTU" ]]
  then
    # Ubuntu script
    . $HOME/dotfiles/scripts/ubuntu-install.sh
  elif [[ "$DISTRO" == "$ARCH_LINUX" ]]
  then
    # Arch Linux script
    . $HOME/dotfiles/scripts/arch-install.sh
  else
    echo "${RED}Distro not supported...${RESTORE}"
  fi
}

main() {
  select_distro
}

main
