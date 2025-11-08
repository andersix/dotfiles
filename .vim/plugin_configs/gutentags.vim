" Gutentags settings
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_cache_dir = expand('~/.cache/tags')

" SystemVerilog-specific ctags configuration
let g:gutentags_ctags_extra_args = [
      \ '--languages=Verilog',
      \ '--verilog-kinds=+mcfrtpePd',
      \ ]

let g:gutentags_file_list_command = {
    \ 'markers': {
        \ '.git': 'git ls-files',
        \ '.hg': 'hg files',
        \ },
    \ }

let g:gutentags_exclude_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git']

