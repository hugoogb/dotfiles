#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh

DOTDIR="$HOME/dotfiles"

# Dotfiles update
update_dotfiles() {
  ACTUAL_DIR=`pwd`
  cd $DOTDIR
  git pull origin master
  cd $ACTUAL_DIR
}

clone_dotfiles() {
  if [ -d $DOTDIR ]
  then
    echo "${YELLOW}WARNING: dotfiles dir already exists...${RESTORE}"
    echo "${PURPLE}Updating dotfiles...${RESTORE}"
    update_dotfiles
  else
    echo "${PURPLE}Cloning dotfiles...${RESTORE}"
    git clone https://github.com/hugoogb/dotfiles.git $DOTDIR
  fi
}

# ALLDONE Message
all_done() {
  echo "${B_GREEN}Dotfiles ready to install and setup!!!${RESTORE}"
}

main() {
  clone_dotfiles
  all_done
}

main
