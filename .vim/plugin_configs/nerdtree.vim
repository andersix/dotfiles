" NERDTree settings
let g:NERDTreeShowHidden = 1  " Show hidden files
let g:NERDTreeMinimalUI = 1   " Minimal UI
let g:NERDTreeAutoDeleteBuffer = 1  " Auto delete buffer when file is deleted
let g:NERDTreeQuitOnOpen = 0  " Don't quit NERDTree when opening a file

" Toggle NERDTree with Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>

" Find current file in NERDTree
nnoremap <leader>nf :NERDTreeFind<CR>
