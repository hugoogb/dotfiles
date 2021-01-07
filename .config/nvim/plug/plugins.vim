" VIM-PLUG
"----------

call plug#begin('$HOME/.config/nvim/autoload/plugged')

" -> Themes
Plug 'gruvbox-community/gruvbox'

Plug 'vim-airline/vim-airline'
Plug 'Yggdroot/indentLine'

" -> LSP Plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'tjdevries/nlua.nvim'

" -> Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/telescope.nvim'

" -> IDE
Plug 'preservim/nerdtree' |
            \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight' |
            \ Plug 'ryanoasis/vim-devicons' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'machakann/vim-highlightedyank'
Plug 'sheerun/vim-polyglot'

" -> Commenmts
Plug 'preservim/nerdcommenter'

" -> Git
Plug 'tpope/vim-fugitive'

" -> Syntax
Plug 'octol/vim-cpp-enhanced-highlight'

" -> Auto pairs for '(' '[' '{''}])'
Plug 'jiangmiao/auto-pairs'

" -> Debugger Plugins
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

" -> WakaTime
" Plug 'wakatime/vim-wakatime'

call plug#end()
