" ALE settings
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'c': ['gcc'],
\   'cpp': ['gcc'],
\   'verilog': ['verilator'],
\   'systemverilog': ['verilator'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'c': ['clangtidy'],
\   'cpp': ['clangtidy'],
\}

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_fix_on_save = 0  " Set to 1 if you want automatic fixing

" ALE keymappings
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>

