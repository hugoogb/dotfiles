#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh
. $HOME/dotfiles/scripts/distro-detect.sh

echo

pacman_pkglist() {
  echo "${PURPLE}Generating ${ARCH_LINUX} package list...${RESTORE}"

  pacman -Qqen > $HOME/dotfiles/scripts/pacman-pkglist.txt
}

yay_pkglist() {
  echo "${PURPLE}Generating AUR package list...${RESTORE}"

  pacman -Qqem > $HOME/dotfiles/scripts/yay-pkglist.txt
}

select_distro() {
  if [[ "$DISTRO" == "$UBUNTU" ]]
  then
    # here goes pkglist ubuntu function
    echo "${YELLOW}Ubuntu not supported yet...${RESTORE}"
  elif [[ "$DISTRO" == "$ARCH_LINUX" ]]
  then
    pacman_pkglist
    yay_pkglist
  else
    echo "${RED}Impossible to generate pkglist (distro not supported)...${RESTORE}"
  fi
}

# ALLDONE Message
all_done() {
  echo "${GREEN}Package list generated succesfully!!!${RESTORE}"
}

main() {
  select_distro
  all_done
}

main

echo
