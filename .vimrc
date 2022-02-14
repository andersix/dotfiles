set nocompatible
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
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-fugitive'
Plug 'vhda/verilog_systemverilog.vim'
"Plug 'nachumk/systemverilog.vim'
Plug 'hdima/python-syntax'
Plug 'zhuzhzh/verilog_emacsauto.vim', {'for': ['verilog', 'systemverilog'] }
Plug 'vimtaku/hl_matchit.vim'
"Plug 'jlfwong/vim-mercenary'
Plug 'ludovicchabant/vim-lawrencium'
"Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'git://repo.or.cz/vcscommand'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'nanotech/jellybeans.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'joshdick/onedark.vim'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'junegunn/limelight.vim'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-markdown'
Plug 'preservim/vim-pencil'
Plug 'junegunn/goyo.vim'
if has('mac')
  Plug 'junegunn/vim-xmark'
endif
" Integrate fzf with Vim.
"Plug '$XDG_DATA_HOME/fzf'
Plug '$HOME/.local/share/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()
" }}}

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if has('nvim') || has('termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    colorscheme onedark
"    colorscheme challenger_deep
  else
"    colorscheme jellybeans
    colorscheme challenger_deep
  endif
endif
" my terminal is white on black
"set background=dark
"set background=light

"let g:zenburn_high_Contrast=1
"colors zenburn
"let g:solarized_termcolors=256
"colors solarized

" set to on enables syntax highlighting.
let python_highlight_all=1
syntax on

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

" Highlight redundant whitespaces and tabs.
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

" for "gvim" remove annoying left/right scroll bars and the toolbar.
set guioptions=aegimt

filetype on            " enables filetype detection


set autoindent
set autoread
set backspace=indent,eol,start  " more powerful backspacing
set cindent                     " stricter rules for C programs. Note: smartindent (deprecated in favor of cindent)
#set colorcolumn=80              " put a marker on column number given
set cursorline
"set fileformats=unix            " always show ^M in DOS files
set nowrap
"set wrapmargin=1
set ruler                        " always show line, col number, the current command, and line number
"set ignorecase                   " caseinsensitive incremental search
"set smartcase                    " override ignorecase if search pattern contains any uppercase chars
set hlsearch
set incsearch
set nostartofline                " don't jump to first character when paging
set paste                        " start in paste mode by default (cancel with [ESC]:nopaste)
set autowrite                    " Automatically save before commands like :next and :make
set viminfo='20,\"50             " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50                   " keep 50 lines of command line history
set showcmd
set tabstop=4
set expandtab                    " don't use actual tab character (ctrl-v)
set smarttab
set shiftwidth=4
set softtabstop=4
set number
set ttyfast
set laststatus=2                 " show the satus line all the time
set so=7                         " set 7 lines to the cursors - when moving vertical
set wildmenu                     " enhanced command line completion
set hidden                       " current buffer can be put into background
set showcmd                      " show incomplete commands
set showmatch                    " Show matching brackets
set showmode
set noshowmode                   " don't show which mode disabled for PowerLine
set wildmode=list:longest        " complete files like a shell
set scrolloff=3                  " lines of text around cursor
set shell=$SHELL
set cmdheight=1                  " command bar height
set title                        " set terminal title
set titleold=
set virtualedit=block            " when in block mode, can position cursor where there is no text
" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

filetype indent on

if !has('mac')
  set diffopt+=iwhite " ignore whitespace for vimdiff
endif
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

"let mapleader=" "
"let maplocalleader=" "

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>


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
 " use Verilog mode for editing Liberty .lib files
 autocmd BufRead,BufNewFile *.lib set filetype=verilog_systemverilog
 autocmd BufRead,BufNewFile *.do                set filetype=tcl
 autocmd BufRead,BufNewFile *.spf,*.stil,*.ctl  set filetype=verilog  " DFT stuff in STIL syntax
 "autocmd BufRead,BufNewFile *.lib,*.lib_ccs_tn  set filetype=verilog  " Synopsys Liberty
 autocmd BufRead,BufNewFile *.lef,*.LEF         so ~/.vim/syntax/lef.vim
 autocmd BufRead,BufNewFile *.def               so ~/.vim/syntax/def.vim
 autocmd BufRead,BufNewFile *.lef,*.LEF         set filetype=lef
 autocmd BufRead,BufNewFile *.def               set filetype=def
 autocmd BufRead,BufNewFile *.cdl               set filetype=spice
 " Make sure .aliases, .bash_aliases and similar files get syntax highlighting.
 autocmd BufNewFile,BufRead .*aliases* set ft=sh
 " Ensure tabs don't get converted to spaces in Makefiles.
 autocmd FileType make setlocal noexpandtab
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
" Clear search highlights using Leader key followed by space:
"map <Leader><Space> :let @/=''<CR>

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

" Auto-resize splits when Vim gets resized.
autocmd VimResized * wincmd =


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

"if &term =~ "^xterm\\|rxvt"
"  " use an orange cursor in insert mode
"  let &t_SI = "\<Esc>]12;orange\x7"
"  " use a red cursor otherwise
"  let &t_EI = "\<Esc>]12;red\x7"
"  silent !echo -ne "\033]12;red\007"
"  " reset cursor when vim exits
"  autocmd VimLeave * silent !echo -ne "\033]112\007"
"  " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
"endif

" Cursor
" IBeam shape in insert mode, underline shape in replace mode and block shape in normal mode.
" Using iTerm2? Go-to preferences / profile / colors and disable the smart bar
" cursor color. Then pick a cursor and highlight color that matches your theme.
" That will ensure your cursor is always visible within insert mode.
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
if has("mac")
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

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

" Only show the cursor line in the active buffer.
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" Add all TODO items to the quickfix list relative to where you opened Vim.
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

" .............................................................................
" junegunn/fzf.vim settings
" .............................................................................

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" Customize fzf colors to match your color scheme.
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-b': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}

" Launch fzf with CTRL+P.
nnoremap <silent> <C-p> :FZF -m<CR>

" Map a few common things to do with FZF.
nnoremap <silent> <Leader><Enter> :Buffers<CR>
nnoremap <silent> <Leader>l :Lines<CR>

" Allow passing optional flags into the Rg command.
"   Example: :Rg myterm -g '*.md'
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ "rg --column --line-number --no-heading --color=always --smart-case " .
  \ <q-args>, 1, fzf#vim#with_preview(), <bang>0)
" .............................................................................

" gvim fonts
if has("gui_running")
  if has("gui_gtk2") || has("gui_gtk3")
    set guifont=Fira\ Code\ weight=450\ 11
  elseif has("gui_macvim")
    "set guifont=Menlo\ Regular:h14
    set guifont=Source\ Code\ Pro\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

