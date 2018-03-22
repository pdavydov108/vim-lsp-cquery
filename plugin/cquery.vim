if exists('g:lsp_cquery_loaded')
    finish
endif
let g:lsp_cquery_loaded = 1

command! LspCqueryDerived call cquery#references#derived()
command! LspCqueryBase call cquery#references#base()
command! LspCqueryVars call cquery#references#vars()
command! LspCqueryCallers call cquery#references#callers()
