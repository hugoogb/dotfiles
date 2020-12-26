#!/bin/bash

. $HOME/dotfiles/scripts/colors.sh

echo "${B_L_CYAN}Welcome to @hugoogb dotfiles!!!${RESTORE}"

echo "${B_PURPLE}Starting...${RESTORE}"

git config --global pull.rebase false

. $HOME/dotfiles/scripts/clone-update-repo.sh
. $HOME/dotfiles/scripts/install-setup.sh

echo "${L_RED}Don't forget to restart to get everything working properly!!!${RESTORE}"
