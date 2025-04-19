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
Plug 'ludovicchabant/vim-lawrencium'
Plug 'mhinz/vim-signify'  " Show git diff in the gutter

" Languages and syntax
Plug 'vhda/verilog_systemverilog.vim'
Plug 'hdima/python-syntax'
Plug 'zhuzhzh/verilog_emacsauto.vim'
Plug 'vimtaku/hl_matchit.vim'
Plug 'nvie/vim-flake8'
Plug 'git://repo.or.cz/vcscommand'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-markdown'
Plug 'elzr/vim-json'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/tcl.vim'  " Better TCL support
Plug 'octol/vim-cpp-enhanced-highlight'  " Better C/C++ highlighting

" Linting and syntax checking
Plug 'dense-analysis/ale'  " Asynchronous linting for multiple languages

" Formatting
Plug 'rhysd/vim-clang-format'  " C/C++ formatting

" Language Server Protocol
Plug 'prabirshrestha/vim-lsp'  " Language Server Protocol support
Plug 'mattn/vim-lsp-settings'  " Easy LSP setup for various languages

" Completion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'  " LSP source for asyncomplete

" Code Navigation
Plug 'ludovicchabant/vim-gutentags'  " Automatic tag management
Plug 'liuchengxu/vista.vim'  " Tag viewer for various languages

" UI enhancements
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'junegunn/limelight.vim'
Plug 'preservim/vim-pencil'
Plug 'junegunn/goyo.vim'

" Terminal Integration
Plug 'voldikss/vim-floaterm'  " Floating terminal

" FZF for fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ASIC-specific enhancements - Only loaded when needed via asic.vim module
" Plug 'antoinemadec/vim-verilog-instance'  " UVM instance port connection helper

" Mac-specific
if has('mac')
  Plug 'junegunn/vim-xmark'
endif

" Color themes
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()
