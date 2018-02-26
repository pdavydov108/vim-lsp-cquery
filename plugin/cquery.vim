if exists('g:lsp_cquery_loaded')
    finish
endif
let g:lsp_cquery_loaded = 1

command! LspCqueryDerived call cquery#references#derived()
