" GENERAL NVIM SETTINGS
"-----------------------

" Leader key
let mapleader = " "
let g:mapleader = " "

syntax on
filetype plugin indent on

set nocompatible

set signcolumn=yes
set termguicolors
set mouse=a
set clipboard+=unnamedplus
set showcmd
set cmdheight=2
set hidden
set number
set numberwidth=1
set ruler
set relativenumber
set cursorline
set encoding=utf-8
set showmatch
set nowrap
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set noshowmode
set title
set scrolloff=8
set nohlsearch
set incsearch
set ignorecase
set smartcase
set autoindent
set smartindent
set autoread
set splitright
set noswapfile
set completeopt=menuone,noinsert,noselect
set pumheight=20
set shortmess+=c
set updatetime=50
set colorcolumn=80

" Disables automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:python3_host_prog='/usr/bin/python3'

com! W w
com! Wq wq
com! WQ wq
com! Qa qa

if executable('rg')
    let g:rg_derive_root='true'
endif
