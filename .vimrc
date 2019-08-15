"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / | | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"

""""""""""""""""""""""""""""""""""""
"              Plugins             "
""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Raimondi/delimitMate'
Plug 'danro/rename.vim'
Plug 'godlygeek/tabular'
Plug 'skammer/vim-css-color'
Plug 'scrooloose/nerdtree'
Plug 'j-tom/vim-old-hope'
Plug 'tpope/vim-surround'

""""""""""""""""""""""""""""""""""""
"              Themes              "
""""""""""""""""""""""""""""""""""""
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
Plug 'romainl/Apprentice'

call plug#end()

""""""""""""""""""""""""""""""""""""
" Configuration Options/Variables  "
""""""""""""""""""""""""""""""""""""
"let &background = "dark"
let &number = 1
let &whichwrap = "<,>,h,l,[,]"
let &tabstop = 4
let &expandtab = 0
let &shiftwidth = 4
let &autoindent = 0
colorscheme old-hope
let g:NERDTreeWinSize=35
let g:NERDTreeMinimalUI=1
set relativenumber
set encoding=utf8
syntax on " syntax highlighting
" allow backspace in insert mode
set backspace=indent,eol,start
:set ff=dos

if $TERM != "cygwin"
    set termguicolors
endif

" SPACES NOT TABS
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set nocompatible

""""""""""""""""""""""""""""""""""""
"        Needed By Ayu Theme       "
""""""""""""""""""""""""""""""""""""
"let ayucolor = "mirage"
"let &termguicolors = 1
"colorscheme ayu

""""""""""""""""""""""""""""""""""""
"     Custom Keyboard Mappings     "
""""""""""""""""""""""""""""""""""""
let mapleader = "-"

" Manipulate This Configuration File
nnoremap <leader>rc :tabedit ~/.vimrc<cr>
nnoremap <leader>rl :source ~/vimrc<cr>

" Select All with Ctrl+A
nnoremap <c-a> ggvGg$
