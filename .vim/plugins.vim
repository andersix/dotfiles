" ============================================================================
" Plugins (vim-plug)
" ============================================================================
" Auto-install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if empty(glob('~/.vim-plugged'))
  silent !mkdir ~/.vim-plugged
endif

call plug#begin('~/.vim-plugged')
" Tmux integration
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'  " Show git diff in the gutter

" Language support
Plug 'vhda/verilog_systemverilog.vim', { 'for': ['verilog', 'systemverilog', 'verilog_systemverilog'] }
Plug 'zhuzhzh/verilog_emacsauto.vim', { 'for': ['verilog', 'systemverilog', 'verilog_systemverilog'] }
Plug 'vimtaku/hl_matchit.vim'
Plug 'vim-scripts/tcl.vim', { 'for': 'tcl' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'

" Linting and syntax checking
Plug 'dense-analysis/ale'  " Asynchronous linting for multiple languages

" Language Server Protocol
Plug 'prabirshrestha/vim-lsp'  " Language Server Protocol support
Plug 'mattn/vim-lsp-settings'  " Easy LSP setup for various languages

" Completion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'  " LSP source for asyncomplete

" Code Navigation
Plug 'ludovicchabant/vim-gutentags'  " Automatic tag management
Plug 'liuchengxu/vista.vim', { 'on': ['Vista', 'Vista!!'] }  " Tag viewer for various languages

" UI enhancements
Plug 'itchyny/lightline.vim'

" Terminal Integration
Plug 'voldikss/vim-floaterm', { 'on': ['FloatermNew', 'FloatermToggle'] }

" Fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'on': ['FZF', 'Files', 'Buffers', 'Rg', 'Lines', 'Tags'] }

" Color themes
Plug 'joshdick/onedark.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'nanotech/jellybeans.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()
