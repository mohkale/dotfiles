""""""""""""""""""""""""""""""""""""
"              Plugins             "
""""""""""""""""""""""""""""""""""""

call plug#begin($XDG_CONFIG_HOME.'/vim/plugged')

Plug 'rbgrouleff/bclose.vim'    " close a buffer without closing window
Plug 'liuchengxu/vim-which-key' " emacs-which-key... for VIM!!! :)
Plug 'Raimondi/delimitMate'     " auto close pairs such as parens
Plug 'tpope/vim-surround'       " change surrounding pairs
Plug 'junegunn/fzf' ", { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'easymotion/vim-easymotion' " like emacs avy-jump TODO properly implement
Plug 'tpope/vim-commentary'

call plug#end()

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
