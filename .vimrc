" ============================================================================
" Main vimrc file
" ============================================================================

" Create necessary directories if they don't exist
if !isdirectory(expand("~/.vim/plugin_configs"))
  call mkdir(expand("~/.vim/plugin_configs"), "p")
endif

if !isdirectory(expand("~/.vim/modules"))
  call mkdir(expand("~/.vim/modules"), "p")
endif

" Load plugins
if filereadable(expand("~/.vim/plugins.vim"))
  source ~/.vim/plugins.vim
endif

" ============================================================================
" Basic Settings {{{
" ============================================================================
set nocompatible              " Use Vim settings, rather than Vi settings
set encoding=utf-8            " Set default encoding
set fileformats=unix,dos,mac  " Use Unix as the standard file type

" Indentation and tabs
set autoindent                " Copy indent from current line when starting a new line
set cindent                   " Stricter rules for C programs
set expandtab                 " Use spaces instead of tabs
set smarttab                  " Be smart when using tabs
set shiftwidth=4              " Number of spaces to use for each step of (auto)indent
set softtabstop=4             " Number of spaces that a <Tab> counts for while editing
set tabstop=4                 " Number of spaces that a <Tab> in the file counts for

" UI Configuration
set cursorline                " Highlight the current line
set laststatus=2              " Always show the status line
set cmdheight=1               " Command bar height
set showcmd                   " Show incomplete commands
set showmatch                 " Show matching brackets
set number                    " Show line numbers
set ruler                     " Show current position
set wildmenu                  " Enhanced command line completion
set wildmode=list:longest     " Complete files like a shell
set scrolloff=7               " Minimum number of lines to keep above/below cursor
set noshowmode                " Don't show mode (using lightline instead)
set title                     " Set terminal title
set hidden                    " Allow buffer switching without saving
set virtualedit=block         " Allow cursor to move where there is no text in visual block mode
set signcolumn=yes            " Always show the signcolumn for git markers and LSP diagnostics

" Folding settings
set foldmethod=indent
set nofoldenable              " Start with all folds open
set foldlevel=2               " When folding is enabled, fold at depth 2+
" Enable folding with the spacebar
nnoremap <space> za
" }}}

" ============================================================================
" Search Settings {{{
" ============================================================================
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set ignorecase                " Case-insensitive search
set smartcase                 " Override ignorecase when search pattern has uppercase
" Clear search highlighting with Enter
nnoremap <CR> :nohlsearch<CR>/<BS><CR>
" }}}

" ============================================================================
" Syntax and Colors {{{
" ============================================================================
syntax on                     " Enable syntax highlighting
set background=dark           " Use dark background

" Configure true color support for terminal
if (empty($TMUX))
  if has('nvim') || has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    let g:onedark_terminal_italics = 0
    colorscheme onedark
    "colorscheme catppuccin_mocha
  else
    colorscheme jellybeans
  endif
endif

" Enable italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment cterm=italic gui=italic

" Highlight redundant whitespaces and tabs
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t\|\t/
" }}}

" ============================================================================
" Cursor Settings {{{
" ============================================================================
" Define cursor colors
hi bCursor guibg=#3498db
hi gCursor guibg=#2ecc71
hi pCursor guibg=#9240ea
hi rCursor guibg=#e74c3c
hi wCursor guibg=#e0e0e0
hi yCursor guibg=#ffe100

" Cursor shape configuration
set guicursor=
set guicursor+=c:blinkoff0-blinkon0-blinkwait0-hor20-gCursor
set guicursor+=ci:blinkoff500-blinkon500-blinkwait10-ver25-gCursor
set guicursor+=cr:blinkoff500-blinkon500-blinkwait10-block-yCursor
set guicursor+=i:blinkoff500-blinkon500-blinkwait10-ver25-pCursor
set guicursor+=n:blinkoff0-blinkon0-blinkwait0-block-yCursor
set guicursor+=o:blinkoff500-blinkon500-blinkwait10-hor20-bCursor
set guicursor+=r:blinkoff500-blinkon500-blinkwait10-block-yCursor
set guicursor+=sm:blinkoff500-blinkon500-blinkwait10-block-yCursor
set guicursor+=v:blinkoff500-blinkon500-blinkwait10-block-rCursor
set guicursor+=ve:blinkoff500-blinkon500-blinkwait10-block-rCursor

" Restore normal cursor style on exit
augroup fix_cursor
    au!
    au VimLeave * set guicursor=a:hor20-yCursor-blinkoff500-blinkon500-blinkwait10
augroup END

" Terminal cursor shape
let &t_SI = "\<Esc>[6 q"  " Insert mode - vertical bar
let &t_SR = "\<Esc>[4 q"  " Replace mode - underline
let &t_EI = "\<Esc>[2 q"  " Normal mode - block

" Mac-specific cursor settings
if has("mac")
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}

" ============================================================================
" File Type Detection and Settings {{{
" ============================================================================
" Enable filetype detection and plugins
filetype plugin indent on

" File-specific settings
augroup file_types
    autocmd!
    " Verilog/SystemVerilog
    autocmd BufRead,BufNewFile *.v,*.vh,*.sv,*.svi,*.svh set filetype=verilog_systemverilog
    autocmd BufRead,BufNewFile *.v,*.vh,*.sv,*.svi,*.svh set expandtab tabstop=4 softtabstop=2 shiftwidth=2

    " Liberty .lib files
    autocmd BufRead,BufNewFile *.lib set filetype=verilog_systemverilog

    " TCL
    autocmd BufRead,BufNewFile *.do,*.tcl set filetype=tcl

    " DFT stuff in STIL syntax
    autocmd BufRead,BufNewFile *.spf,*.stil,*.ctl set filetype=verilog

    " LEF/DEF
    autocmd BufRead,BufNewFile *.lef,*.LEF so ~/.vim/syntax/lef.vim
    autocmd BufRead,BufNewFile *.def so ~/.vim/syntax/def.vim
    autocmd BufRead,BufNewFile *.lef,*.LEF set filetype=lef
    autocmd BufRead,BufNewFile *.def set filetype=def

    " SPICE
    autocmd BufRead,BufNewFile *.cdl,*.sp,*.spice set filetype=spice

    " Shell aliases files
    autocmd BufNewFile,BufRead .*aliases* set ft=sh

    " Makefiles (keep tabs)
    autocmd FileType make setlocal noexpandtab

    " Python PEP8 style
    autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

    " C/C++ style
    autocmd FileType c,cpp set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

" Show relative line numbers in normal mode, absolute in insert mode
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Only show cursor line in active buffer
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" Auto-resize splits when Vim gets resized
autocmd VimResized * wincmd =
" }}}

" ============================================================================
" Key Mappings {{{
" ============================================================================
" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Make p in Visual mode replace the selected text with the "" register
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Delete all trailing whitespace with F5
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Quick save with leader w
nnoremap <leader>w :w<CR>

" Quick quit with leader q
nnoremap <leader>q :q<CR>

" Quick buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Center the screen after searching
nnoremap n nzz
nnoremap N Nzz
" }}}

" ============================================================================
" Custom Functions {{{
" ============================================================================
" Function to clean up text
function! CleanText()
    let curcol = col(".")
    let curline = line(".")
    exe ":retab"
    exe ":%s/\r$//ge"
    exe ":%s/\r/ /ge"
    exe ":%s/ \+$//e"
    call cursor(curline, curcol)
endfunction

" Diff options
if !has('mac')
  set diffopt+=iwhite " ignore whitespace for vimdiff
endif
set diffexpr=DiffW()
function! DiffW()
  let opt = ""
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-w " " swapped vim's -b with -w
   endif
   silent execute "!diff -a --binary " . opt .
     \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction

" Add all TODO items to the quickfix list
function! s:todo() abort
  let entries = []
  for cmd in ['git grep -niIw -e TODO -e FIXME 2> /dev/null',
            \ 'grep -rniIw -e TODO -e FIXME . 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor
  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()

" Insert a date/time entry
command! -nargs=* Entry call s:RunEntry()
function! s:RunEntry()
  let s:tm = "\n---" . strftime("%d/%m/%y %H:%M:%S") . "----------------------\n"
  execute "normal! i" . s:tm
  call feedkeys("i")
endfunction
" }}}

" ============================================================================
" GUI Settings {{{
" ============================================================================
" GUI options - remove scrollbars and toolbar
if has('gui_running')
  set guioptions=aegimt

  " Set GUI font based on OS
  if has("gui_gtk2") || has("gui_gtk3")
    set guifont=Fira\ Code\ weight=450\ 11
  elseif has("gui_macvim")
    set guifont=SourceCodePro-Regular:h12
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

" Set paper size from system configuration if available
try
  if filereadable('/etc/paper.config')
    let s:papersize = matchstr(system('/bin/cat /etc/paper.config'), '\p*')
    if strlen(s:papersize)
      let &printoptions = "paper:" . s:papersize
    endif
    unlet! s:papersize
  endif
catch /E145/
endtry
" }}}

" ============================================================================
" Plugin Configurations {{{
" ============================================================================
" Load all plugin-specific configurations
for f in split(glob('~/.vim/plugin_configs/*.vim'), '\n')
  exe 'source' f
endfor
" }}}

" ============================================================================
" Module Loading {{{
" ============================================================================
" Command to load specific modules on-demand
" Type :LoadModule then tab for module list completion
command! -nargs=1 -complete=custom,ListModules LoadModule execute 'source ~/.vim/modules/' . <q-args> . '.vim'

function! ListModules(A, L, P)
  let modules = glob('~/.vim/modules/*.vim', 0, 1)
  let module_names = []
  for module in modules
    let name = fnamemodify(module, ':t:r')
    call add(module_names, name)
  endfor
  return join(module_names, "\n")
endfunction

" Uncomment the line below to always load the ASIC module
" source ~/.vim/modules/asic.vim
" Or, run :LoadModule asic when you need ASIC functionality, without having it loaded all the time.
" }}}

" vim: set foldmethod=marker foldlevel=0 ts=2 sts=2 sw=2 noet :
