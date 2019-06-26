set nocompatible
set autoread
set encoding=utf-8

" vim-plug {{{
" First make sure plug.vim is there. If not, get and install it:
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
if empty(glob('~/.vim-plugged'))
  silent !mkdir ~/.vim-plugged
endif
" Note, a Plug with no URL assumes 'https://github.com/', and no '.git' at the end
call plug#begin('~/.vim-plugged')
Plug 'vhda/verilog_systemverilog.vim'
Plug 'hdima/python-syntax'
Plug 'zhuzhzh/verilog_emacsauto.vim', {'for': ['verilog', 'systemverilog'] }
Plug 'vimtaku/hl_matchit.vim'
"Plug 'jlfwong/vim-mercenary'
Plug 'ludovicchabant/vim-lawrencium'
"Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'git://repo.or.cz/vcscommand'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'nanotech/jellybeans.vim'
Plug 'altercation/vim-colors-solarized'
if has('mac')
  Plug 'junegunn/vim-xmark'
endif
call plug#end()
" }}}

""" hl_matchit plugin {{{
"" If this variable is set, augroup is defined, and start highlighting.
let g:hl_matchit_enable_on_vim_startup = 1
"" you can specify highlight group. see :highlight
let g:hl_matchit_hl_groupname = 'Search'
"" I recomend  g:hl_matchit_speed_level = 1 because highlight is
"" just an addition.
"" If 1 is set, sometimes do not highlight.
let g:hl_matchit_speed_level = 1 " or 2
"" you can specify use hl_matchit filetype.
"let g:hl_matchit_allow_ft = 'html,vim,sh' " blah..blah..

if exists('loaded_matchit')
let b:match_ignorecase=0
let b:match_words=
  \ '\<begin\>:\<end\>,' .
  \ '\<if\>:\<else\>,' .
  \ '\<module\>:\<endmodule\>,' .
  \ '\<class\>:\<endclass\>,' .
  \ '\<program\>:\<endprogram\>,' .
  \ '\<clocking\>:\<endclocking\>,' .
  \ '\<property\>:\<endproperty\>,' .
  \ '\<sequence\>:\<endsequence\>,' .
  \ '\<package\>:\<endpackage\>,' .
  \ '\<covergroup\>:\<endgroup\>,' .
  \ '\<primitive\>:\<endprimitive\>,' .
  \ '\<specify\>:\<endspecify\>,' .
  \ '\<generate\>:\<endgenerate\>,' .
  \ '\<interface\>:\<endinterface\>,' .
  \ '\<function\>:\<endfunction\>,' .
  \ '\<task\>:\<endtask\>,' .
  \ '\<case\>\|\<casex\>\|\<casez\>:\<endcase\>,' .
  \ '\<fork\>:\<join\>\|\<join_any\>\|\<join_none\>,' .
  \ '`ifdef\>:`else\>:`endif\>,'
endif
" use the % key to jump between matching keywords
runtime macros/matchit.vim
" }}}

" set to on enables syntax highlighting.
let python_highlight_all=1
syntax on

" my terminal is white on black
set background=dark
"set background=light

"let g:zenburn_high_Contrast=1
"colors zenburn

"let g:solarized_termcolors=256
"colors solarized

colorscheme jellybeans

"highlight Comment ctermbg=blue
"highlight Comment ctermfg=black
"highlight Comment cterm=italic

" Highlight redundant whitespaces and tabs.
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

" for "gvim" remove annoying left/right scroll bars and the toolbar.
set guioptions=aegimt

filetype on            " enables filetype detection

" use 4 spaces instead of tabs
"set wrap
"set wrapmargin=1
set tabstop=4     " tabs are at proper location
set expandtab     " don't use actual tab character (ctrl-v)
set smarttab
set shiftwidth=4  " indenting is 4 spaces
set softtabstop=4
set autoindent    " turns it on
set cindent       " stricter rules for C programs
"set smartindent     " smart indent (deprecated in favor of cindent)
filetype indent on
set diffopt+=iwhite " ignore whitespace for vimdiff
set diffexpr=DiffW()
function DiffW()
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


" more powerful backspacing
set backspace=indent,eol,start

" always show ^M in DOS files
"set fileformats=unix

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" caseinsensitive incremental search
set ignorecase
set hlsearch
set incsearch

set nostartofline   " don't jump to first character when paging

" Show matching brackets
set showmatch

" start in paste mode by default (cancel with [ESC]:nopaste)
set paste

" always show line and col number and the current command, and line number
set ruler
set showcmd

set autowrite      " Automatically save before commands like :next and :make

set viminfo='20,\"50    " read/write a .viminfo file, don't store more than
            " 50 lines of registers
set history=50      " keep 50 lines of command line history


if has("autocmd")
 " Enabled file type detection
 " Use the default filetype settings. If you also want to load indent files
 " to automatically do language-dependent indenting add 'indent' as well.
 filetype plugin on
 "autocmd BufRead,BufNewFile *.v,*.vh setfiletype verilog
 autocmd BufRead,BufNewFile *.v,*.vh set filetype=verilog_systemverilog
 autocmd BufRead,BufNewFile *.v,*.vh set expandtab tabstop=4 softtabstop=2 shiftwidth=2
 autocmd BufRead,BufNewFile *.sv,*.svi,*.svh set filetype=verilog_systemverilog
 autocmd BufRead,BufNewFile *.sv,*.svi,*.svh set expandtab tabstop=4 softtabstop=2 shiftwidth=2
endif " has ("autocmd")

" function to cleanup a text -> mapped to F5
fun CleanText()
    let curcol = col(".")
    let curline = line(".")
    exe ":retab"
    exe ":%s/^M$//ge"
    exe ":%s/^M/ /ge"
    exe ":%s/ \\+$//e"
    call cursor(curline, curcol)
endfun
map <F5> :call CleanText()<CR>

" Clears search highlighting by just hitting a return.
" The <BS> clears the command line.
" (From Zdenek Sekera [zs@sgi.com]  on the vim list.)
" I added the final <cr> to restore the standard behaviour of
" <cr> to go to the next line
:nnoremap <CR> :nohlsearch<CR>/<BS><CR>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"
" Press F5 to delete all trailing whitespace
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Set paper size from /etc/papersize if available (Debian-specific)
" Set paper size from /etc/paper.config if available (RedHat-specific)
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

" toggle invisible characters
"set list
"set listchars=tab:→\ ,trail:⋅,extends:❯,precedes:❮
"set showbreak=↪

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


" Use :set nonumber to remove, or comment out
set number
set ttyfast
set laststatus=2            " show the satus line all the time
set so=7                    " set 7 lines to the cursors - when moving vertical
set wildmenu                " enhanced command line completion
set hidden                  " current buffer can be put into background
set showcmd                 " show incomplete commands
set noshowmode              " don't show which mode disabled for PowerLine
set wildmode=list:longest   " complete files like a shell
set scrolloff=3             " lines of text around cursor
set shell=$SHELL
set cmdheight=1             " command bar height
set title                   " set terminal title
set titleold=

" syntastic settings
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" "let g:syntastic_python_checkers = ['flake8']

"if has('mouse')
"    set mouse=a
"    " set ttymouse=xterm2
"endif

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

" Python PEP8 indentation style guide:
au BufNewFile,BufRead *.py:
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

" open a NERDTree automatically when vim starts up
"autocmd vimenter * NERDTree
