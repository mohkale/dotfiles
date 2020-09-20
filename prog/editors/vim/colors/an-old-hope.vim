" local syntax file - set colors on a per-machine basis: forked from pablo.vim
" vim: tw=0 ts=4 sw=4
" VIM color file
"
" This theme works better with termguicolors enabled.
"
" Note: Based on an-old-hope.tmTheme from submlime.
" Maintainer:  Mohsin Kaleem <mohkale@kisara.moe>
" Last Change: 2020 September 19

hi clear
set background=dark
if version > 580
  if exists("syntax_on")
    syntax reset
  endif
endif
set t_Co=256
let g:colors_name="mohkale"

hi Character       guifg=#EA3D54 guibg=None    guisp=None gui=bold ctermfg=167  ctermbg=None cterm= bold
hi Comment         guifg=#686B78 guibg=None    guisp=None gui=None ctermfg=242  ctermbg=None cterm=None
hi Constant        guifg=#EA3D54 guibg=None    guisp=None gui=bold ctermfg=167  ctermbg=None cterm= bold
hi Cursor          guifg=None    guibg=#CBCCD1 guisp=None gui=None ctermfg=None ctermbg=252  cterm=None
hi CursorLine      guifg=None    guibg=#313339 guisp=None gui=None ctermfg=None ctermbg=236  cterm=None
hi Function        guifg=#FEDD38 guibg=None    guisp=None gui=None ctermfg=221  ctermbg=None cterm=None
hi Identifier      guifg=None    guibg=None    guisp=None gui=None ctermfg=None ctermbg=None cterm=None
hi Keyword         guifg=#78BD65 guibg=None    guisp=None gui=None ctermfg=107  ctermbg=None cterm=None
hi LineNr          guifg=None    guibg=None    guisp=None gui=None ctermfg=None ctermbg=None cterm=None
hi Normal          guifg=#CBCCD1 guibg=#1C1D20 guisp=None gui=None ctermfg=252  ctermbg=234  cterm=None
hi Number          guifg=#CBCCD1 guibg=None    guisp=None gui=None ctermfg=252  ctermbg=None cterm=None
hi StorageClass    guifg=#78BD65 guibg=None    guisp=None gui=None ctermfg=107  ctermbg=None cterm=None
hi String          guifg=#4FB3D8 guibg=None    guisp=None gui=None ctermfg=74   ctermbg=None cterm=None
hi Type            guifg=#EA3D54 guibg=None    guisp=None gui=None ctermfg=167  ctermbg=None cterm=None
hi Visual          guifg=None    guibg=#848794 guisp=None gui=None ctermfg=None ctermbg=245  cterm=None

hi link Repeat Keyword
hi link Conditional Keyword
hi link cType Keyword
