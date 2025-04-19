" clang-format settings
let g:clang_format#style_options = {
    \ "AllowShortIfStatementsOnASingleLine" : "true",
    \ "AlwaysBreakTemplateDeclarations" : "true",
    \ "BasedOnStyle" : "Google",
    \ "IndentWidth" : 2,
    \ "ColumnLimit" : 100,
    \ "Standard" : "C++11"}
augroup clang_format
    autocmd!
    autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
    autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
augroup END

