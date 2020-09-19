" local syntax file - set colors on a per-machine basis: forked from pablo.vim
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:  Mohsin Kaleem <mohkale@kisara.moe>
" Last Change: 2020 September 19

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "mohkale"

highlight	Comment     ctermfg=8                          guifg=#808080
highlight	Constant    ctermfg=14             cterm=none  guifg=#00ffff                 gui=none
highlight	Identifier  ctermfg=1              cterm=none  guifg=#eb3d54
highlight	String      ctermfg=4                          guifg=#000080
highlight	Statement   ctermfg=2              cterm=bold  guifg=#c0c000                 gui=bold
highlight	PreProc     ctermfg=11                         guifg=#00ff00
highlight	Type        ctermfg=2                          guifg=#00c000
highlight	Special     ctermfg=12                         guifg=#0000ff
highlight	Error       ctermbg=9                                         guibg=#ff0000
highlight	Todo        ctermfg=4   ctermbg=3              guifg=#000080  guibg=#c0c000
highlight	Directory   ctermfg=3                          guifg=#00c000
highlight	StatusLine  ctermfg=0   ctermbg=7  cterm=none  guifg=#ffff00  guibg=#0000ff  gui=none
highlight	Normal                                         guifg=#ffffff  guibg=#000000
highlight	Search                  ctermbg=3                             guibg=#c0c000
