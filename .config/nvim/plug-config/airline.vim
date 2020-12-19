" AIRLINE
"---------

" don't show file encoding
let g:airline#extensions#default#layout = [
            \ [ 'a', 'b', 'c' ],
            \ [ 'x', 'z', 'error', 'warning' ]
            \ ]

" -> Airline tweaks
" Powerline symbols
let g:airline_powerline_fonts = 1

" Enable lsp
let g:airline#extensions#lsp#enabled = 1
let airline#extensions#lsp#error_symbol = 'E:'
let airline#extensions#lsp#warning_symbol = 'W:'

" Github extension to show branch and name
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
