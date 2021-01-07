" LUA COMPLETION
" ---------------

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

lua require'lspconfig'.bashls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.vimls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.html.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.cssls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.tsserver.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.jsonls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.pyls.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.clangd.setup{ on_attach=require'completion'.on_attach }
lua require'lspconfig'.cmake.setup{ on_attach=require'completion'.on_attach }

" Use completion-nvim in every buffer
" autocmd BufEnter * lua require'completion'.on_attach()

command Format execute 'lua vim.lsp.buf.formatting()'
autocmd BufWritePost *.cpp,CMakeLists.txt Format
