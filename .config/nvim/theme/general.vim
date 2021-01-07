" GENERAL COLORS CONFIG
"-----------------------

" -> Functions
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

fun! Hugoogb_LspHighlighter()
    lua package.loaded['my_lspconfig'] = nil
    lua require('my_lspconfig')
endfun

com! SetLspVirtualText call Hugoogb_LspHighlighter()

" -> Inlay hints
augroup HUGOOGB
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}

    au BufEnter github.com_*.txt set filetype=markdown
    au BufEnter txti.es_*.txt set filetype=typescript
augroup END
