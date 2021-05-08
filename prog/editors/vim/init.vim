"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / | | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"

set nocompatible

" XDG Compatibility Stuff
" -----------------------

" Assign the defaults when the environment doesn't provide them.
if empty($XDG_CACHE_HOME)
  let $XDG_CACHE_HOME = $HOME.'/.cache'
endif
if empty($XDG_CONFIG_HOME)
  let $XDG_CONFIG_HOME = $HOME.'/.config'
endif

" Make sure any configuration directories/paths exist.
if !isdirectory($XDG_CACHE_HOME."/vim/swap")
  call mkdir($XDG_CACHE_HOME."/vim/swap", "p")
endif
if !isdirectory($XDG_CACHE_HOME."/vim/backup")
  call mkdir($XDG_CACHE_HOME."/vim/backup", "p")
endif
if !isdirectory($XDG_CACHE_HOME."/vim/undo")
  call mkdir($XDG_CACHE_HOME."/vim/undo", "p")
endif
if !isdirectory($XDG_CACHE_HOME."/vim/view")
  call mkdir($XDG_CACHE_HOME."/vim/view", "p")
endif

let &undodir=$XDG_CACHE_HOME.'/vim/undo'
let &directory=$XDG_CACHE_HOME.'/vim/swap'
let &backupdir=$XDG_CACHE_HOME.'/vim/backup'
let &viewdir=$XDG_CACHE_HOME.'/vim/view'
let &runtimepath=expand('$XDG_CONFIG_HOME/vim,$VIMRUNTIME,$XDG_CONFIG_HOME/vim/after')
let g:netrw_home=$XDG_CACHE_HOME.'/vim'

source $XDG_CONFIG_HOME/vim/plugins.vim                                        " Load vim plugin configuration
source $XDG_CONFIG_HOME/vim/statusline.vim                                     " Load custom statusline theme

" Editor Options
" --------------
syntax on
colorscheme mohkale

" Change the terminals title depending on the current buffer. Format: filename [modifiers ](dirname)
set title titlestring=%t%(\ %M%)%(\ (%{substitute(getcwd(),\ $HOME,\ '~',\ '')})%)%(\ %a%)

set relativenumber                                                             " enable relative line numbers
set clipboard=unnamedplus                                                      " automatically yank into system clipboard when available
set number                                                                     " current line is absolute
set noautoindent                                                               " no auto indenting
set ff=unix                                                                    " preffered line endings
set splitbelow                                                                 " split to below, not up
set splitright                                                                 " split to right, not left
set encoding=utf8
set hidden                                                                     " change buffers even when current one is modified
set nostartofline                                                              " prevent column changing on scroll
set wildmode=list:longest,list:full                                            " make vim completion work like bash
set wildmenu                                                                   " jump through completion candidates with tab/shift-tab
set autoread                                                                   " automatically read changes in unmodified buffers
set hidden                                                                     " hide files in the background instead of closing them
set ignorecase                                                                 " make search case insensitive by default
set smartcase                                                                  " make search case sensetive when including a capital letter
set laststatus=2                                                               " always show the status bar
set shortmess+=I                                                               " disable the default startup message
set list                                                                       " highlight trailing whitespace and other confusing things
set listchars=tab:\ \ ,trail:.,extends:#,nbsp:.
set backspace=indent,eol,start                                                 " allow backspace in insert mode
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab                    " use spaces, with default tab width being 4 spaces
set whichwrap+=<,>,h,l,[,]                                                     " move to previous or next line when moving back at eol
set nowrap                                                                     " disable lines being wrapped by default
set guifont=Meslo\ LG\ M\ DZ                                                   " set preffered font for graphical vim displays
set selection=old                                                              " Fix bizarre eol behaviour in visual mode. See [[https://vi.stackexchange.com/questions/12607/extend-visual-selection-til-the-last-character-on-the-line-excluding-the-new-li][here]]
set undofile                                                                   " Save undo history to undodir and reload on startup
set undolevels=1000                                                            " Maximum number of undos allowed (has memory cost)
set mouse=a                                                                    " Enable mouse interactions even in the terminal

let g:netrw_banner=0                                                           " configure netrw to be more dired like
let g:netrw_fastbrowse=1                                                       " cache directory entries only when remote
let g:netrw_keepdir=1
let g:netrw_silent=1
let g:netrw_special_syntax=1
let g:netrw_bufsettings = "noma nomod nonu nowrap ro nobl relativenumber"      " Fix relativenumber being unset in netrw buffers
let g:EasyMotion_startofline=0                                                 " keep cursor column when JK motion
let g:EasyMotion_smartcase=1                                                   " makes EasyMotion work like smartcase for global searches

if has('nvim')
  set inccommand=nosplit
endif

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " suppress automatic comment insertion

autocmd BufEnter    * silent! lcd %:p:h                                        " like autochdir except for any buffer, not just files
silent! au TermOpen * setlocal listchars= nonumber norelativenumber            " disable line numbers in vims builtin terminal emulator

if $TERM == "cygwin"
  let &t_ti.="\e[1 q" &t_SI.="\e[5 q" &t_EI.="\e[1 q" &t_te.="\e[0 q"          " use a block cursor on windows cygwin
endif

runtime! bindings/*

" Position Restore
" ----------------
" Automatically restore the previous cursor position when entering a
" new buffer.

" WARN: For some reason nvim and vim viminfo files are [[https://vi.stackexchange.com/q/9987][incompatible]].
if has('nvim')
  set viminfo='250,\"100,:20,%,n$XDG_DATA_HOME/nvim/viminfo
else
  set viminfo='250,\"100,:20,%,n$XDG_DATA_HOME/vim/viminfo
endif

" ResCur silently jumps to the previous cursor position saved in mark "
" without updating the jumplist.
function! ResCur()
  if line("'\"") <= line("$")
    silent! normal! g`"zz
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

augroup fileTypeDetect
  autocmd!
  autocmd BufNewFile,BufRead .config   set syntax=clojure
augroup END

function! SynStack ()
  for i1 in synstack(line("."), col("."))
    let i2 = synIDtrans(i1)
    let n1 = synIDattr(i1, "name")
    let n2 = synIDattr(i2, "name")
    echo n1 "->" n2
  endfor
endfunction
map gm :call SynStack()<CR>

augroup help_splits
  autocmd!
  autocmd! BufEnter * if &ft ==# 'help' | wincmd L | endif
augroup END

augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
