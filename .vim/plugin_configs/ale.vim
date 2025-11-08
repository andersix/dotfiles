" ALE settings
" LSP handles linting for Python, C, C++ - ALE focuses on Verilog and formatting
let g:ale_linters = {
\   'python': [],
\   'c': [],
\   'cpp': [],
\   'verilog': ['verilator'],
\   'systemverilog': ['verilator'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\}

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_fix_on_save = 0  " Set to 1 if you want automatic fixing

" ALE keymappings
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>

