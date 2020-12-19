#!/bin/bash

# Bootstraping NVIM
nvim_bootstrap() {
  echo "${PURPLE}Bootstraping nVim...${RESTORE}"
  nvim --headless "+PlugUpgrade" "+PlugInstall" "+qall"
  nvim --headless "+PlugUpdate" "+PlugClean!" "+qall"
}

# Installing lsp servers
lsp_bootstrap() {
  echo
  echo "${PURPLE}Setting up lsp servers...${RESTORE}"
  nvim --headless "+LspInstall bashls" "+LspInstall vimls" "+LspInstall html" "+qall"
  nvim --headless "+LspInstall tsserver" "+LspInstall jsonls" "+qall"
  nvim --headless "+LspInstall cssls" "+LspInstall sumneko_lua" "+qall"

  # Listed here are installed manually
  # LspInstall pyls
  # LspInstall clangd
  # LspInstall rust_analyzer
  # LspInstall cmake-language-server
}

main() {
  nvim_bootstrap
  lsp_bootstrap
}

main
