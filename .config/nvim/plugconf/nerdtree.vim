" NERDTREE
"----------

" Useful config
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore=['.DS_Store']
let NERDTreeHighlightCursorline=1
let NERDTreeShowHidden=1

let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=30
let g:netrw_localrmdir='rm -r'

" Enable line numbers and relative numbers
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

" AutoOpen NERDTree if no files were specified
autocmd StdinreadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" AutoClose NERDTree if it is the only window left
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDTree Git plugin config
let g:NERDTreeGitStatusUseNerdFonts = 1

" sync open file with NERDTree
" " Check if NERDTree is open or active
" function! IsNERDTreeOpen()
  " return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
" endfunction
" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
" function! SyncTree()
  " if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    " NERDTreeFind
    " wincmd p
  " endif
" endfunction
" Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()
