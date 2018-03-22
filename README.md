# vim-lsp-cquery

This plugin is an extension of [vim-lsp](https://github.com/prabirshrestha/vim-lsp) plugin that supports some additional methods provided by [cquery](https://github.com/cquery-project/cquery). For now, this methods are `$cquery/base`, `$cquery/derived` and `$cquery/vars`. More methods will be added in future.

## Installing

Use your plugin manager of choise. For example if you use [vim-plug](https://github.com/junegunn/vim-plug) add the following lines to your vimrc:

```viml
" First install vim-lsp, this plugin relies on it:
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'pdavydov108/vim-lsp-cquery'
```

Now follow the guide how to install cquery and add it to vim-lsp [here](https://github.com/prabirshrestha/vim-lsp/wiki/Servers-cquery).

## Commands

In addition to those commands defined by `vim-lsp` plugin, this one defines the following additional commands: 

1. `LspCqueryDerived` - when used on function, get a list of functions that override this one. When used on a class, get a list of classes that inherit from this one.
2. `LspCqueryBase` - get a base class (or a list of base classes) of this class.
3. `LspCqueryVars` - get a list of all variables that are instances of this user-defined type.
4. `LspCqueryCallers` - get a list of all callers of this function.

## Mappings

No mappings are defined by default. However, it is trivial to define your own. For example like so:

```viml
autocmd FileType c,cc,cpp,cxx,h,hpp nnoremap <leader>fv :LspCqueryDerived<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp nnoremap <leader>fc :LspCqueryCallers<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp nnoremap <leader>fb :LspCqueryBase<CR>
autocmd FileType c,cc,cpp,cxx,h,hpp nnoremap <leader>fi :LspCqueryVars<CR>
```

For the explanation, see [cquery FAQ](https://github.com/cquery-project/cquery/wiki/FAQ#references).
