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
"Plug 'ide'
Plug 'scrooloose/nerdtree'
Plug 'j-tom/vim-old-hope'

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

"use block cursor on cygwin

if $TERM == "cygwin"
    let &t_ti.="\e[1 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    let &t_te.="\e[0 q"
endif

" SPACES NOT TABS
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set termguicolors

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
