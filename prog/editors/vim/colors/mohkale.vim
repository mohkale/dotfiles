" local syntax file
" Adapted from [[file:~/.dotfiles/prog/bat/an-old-hope/an-old-hope.tmTheme][an-old-hope-sublime]] using [[http://github.com/sickill/coloration][coloration]] (v0.4.0)
" Maintainer:  Mohsin Kaleem <mohkale@kisara.moe>
" Last Change: 2020 November 25

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "mohkale"

hi Visual       ctermfg=NONE ctermbg=110  cterm=NONE guifg=NONE    guibg=#44464f gui=NONE
hi MatchParen   ctermfg=NONE ctermbg=110  cterm=bold guifg=NONE    guibg=#44464f gui=bold
hi CursorLine   ctermfg=NONE ctermbg=236  cterm=NONE guifg=NONE    guibg=#313339 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=236  cterm=NONE guifg=NONE    guibg=#313339 gui=NONE
hi ColorColumn  ctermfg=NONE ctermbg=236  cterm=NONE guifg=NONE    guibg=#313339 gui=NONE
hi Cursor       ctermfg=234  ctermbg=188  cterm=NONE guifg=#1c1d20 guibg=#cbccd1 gui=NONE
hi Search       ctermfg=234  ctermbg=5    cterm=NONE guifg=NONE    guibg=#ba78ab gui=NONE
hi IncSearch    ctermfg=234  ctermbg=74   cterm=bold guifg=#1c1d20 guibg=#4fb3d8 gui=bold
hi Directory    ctermfg=221  ctermbg=NONE cterm=bold guifg=#e5cd52 guibg=NONE    gui=bold
hi VertSplit    ctermfg=12   ctermbg=NONE cterm=NONE guifg=#4fb3d8 guibg=NONE    gui=NONE
hi LineNr       ctermfg=15   ctermbg=234  cterm=NONE guifg=#cbcdd2 guibg=#1c1d20 gui=NONE
hi CursorLineNr ctermfg=74   ctermbg=234  cterm=NONE guifg=#4fb3d8 guibg=#1c1d20 gui=NONE
hi Pmenu        ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE    gui=NONE
hi PmenuSel     ctermfg=NONE ctermbg=208  cterm=NONE guifg=NONE    guibg=#ee7b29 gui=NONE
hi Folded       ctermfg=0    ctermbg=15   cterm=NONE guifg=#4f5053 guibg=#cbccd1 gui=NONE

hi StatusLine       ctermfg=235   ctermbg=252  cterm=NONE guifg=#4f5053 guibg=#cbccd1 gui=NONE
hi StatusLineBold   ctermfg=235   ctermbg=252  cterm=bold guifg=#4f5053 guibg=#cbccd1 gui=bold
hi StatusLineMeta   ctermfg=5     ctermbg=252  cterm=NONE guifg=#ba78ab guibg=#cbccd1 gui=NONE
hi StatusLineNC     ctermfg=252   ctermbg=239  cterm=NONE guifg=#cccccc guibg=#4d4d4d gui=NONE
hi StatusLineNCBold ctermfg=252   ctermbg=239  cterm=bold guifg=#cccccc guibg=#4d4d4d gui=bold
hi StatusLineNCMeta ctermfg=5     ctermbg=239  cterm=NONE guifg=#ba78ab guibg=#4d4d4d gui=NONE

hi Normal       ctermfg=NONE ctermbg=NONE cterm=NONE      guifg=#cbccd1 guibg=#18181b gui=NONE
hi NonText      ctermfg=12   ctermbg=NONE cterm=NONE      guifg=#44464f guibg=#18181b gui=NONE
hi Boolean      ctermfg=167  ctermbg=NONE cterm=bold      guifg=#ea3d54 guibg=NONE    gui=bold
hi Comment      ctermfg=8    ctermbg=NONE cterm=NONE      guifg=#686b78 guibg=NONE    gui=NONE
hi Conditional  ctermfg=2    ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=NONE
hi Constant     ctermfg=NONE ctermbg=NONE cterm=NONE      guifg=NONE    guibg=NONE    gui=NONE
hi Define       ctermfg=2    ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=NONE
hi ErrorMsg     ctermfg=7    ctermbg=167  cterm=NONE      guifg=#1c1d20 guibg=#ea3d54 gui=NONE
hi WarningMsg   ctermfg=7    ctermbg=167  cterm=NONE      guifg=#1c1d20 guibg=#ea3d54 gui=NONE
hi Float        ctermfg=NONE ctermbg=NONE cterm=NONE      guifg=#cbccd1 guibg=NONE    gui=NONE
hi Function     ctermfg=221  ctermbg=NONE cterm=NONE      guifg=#fedd38 guibg=NONE    gui=NONE
hi Identifier   ctermfg=NONE ctermbg=NONE cterm=NONE      guifg=#cbccd1 guibg=NONE    gui=NONE
" hi Identifier   ctermfg=107  ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=italic
hi Keyword      ctermfg=107  ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=NONE
hi Label        ctermfg=12   ctermbg=NONE cterm=NONE      guifg=#4fb3d8 guibg=NONE    gui=NONE
hi Number       ctermfg=NONE ctermbg=NONE cterm=NONE      guifg=#cbccd1 guibg=NONE    gui=NONE
" hi Operator     ctermfg=107  ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=NONE
hi Operator     ctermfg=NONE ctermbg=NONE cterm=NONE      guifg=#cbccd1 guibg=NONE    gui=NONE
hi PreProc      ctermfg=107  ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=NONE
hi Special      ctermfg=NONE ctermbg=NONE cterm=NONE      guifg=#cbccd1 guibg=NONE    gui=NONE
hi SpecialKey   ctermfg=74   ctermbg=NONE cterm=NONE      guifg=#ba78ab guibg=NONE    gui=NONE
hi Statement    ctermfg=107  ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=NONE
hi StorageClass ctermfg=107  ctermbg=NONE cterm=NONE      guifg=#78bd65 guibg=NONE    gui=italic
hi Character    ctermfg=12   ctermbg=NONE cterm=bold      guifg=#4fb3d8 guibg=NONE    gui=bold
hi String       ctermfg=12   ctermbg=NONE cterm=NONE      guifg=#4fb3d8 guibg=NONE    gui=NONE
hi Tag          ctermfg=221  ctermbg=NONE cterm=NONE      guifg=#fedd38 guibg=NONE    gui=NONE
hi Title        ctermfg=NONE ctermbg=NONE cterm=bold      guifg=#cbccd1 guibg=NONE    gui=bold
hi WarningMsg   ctermfg=7    ctermbg=167  cterm=NONE      guifg=#1c1d20 guibg=#ea3d54 gui=NONE
hi Todo         ctermfg=167  ctermbg=NONE cterm=bold      guifg=#ea3d54 guibg=NONE    gui=bold
hi Type         ctermfg=167  ctermbg=NONE cterm=bold      guifg=#ea3d54 guibg=NONE    gui=bold
hi Underlined   ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE    guibg=NONE    gui=underline
hi DiffAdd      ctermfg=188  ctermbg=64   cterm=bold      guifg=#cbccd1 guibg=#44810b gui=bold
hi DiffDelete   ctermfg=88   ctermbg=NONE cterm=NONE      guifg=#890606 guibg=NONE    gui=NONE
hi DiffChange   ctermfg=NONE ctermbg=23   cterm=NONE      guifg=#cbccd1 guibg=#1e3454 gui=NONE
hi DiffText     ctermfg=NONE ctermbg=24   cterm=bold      guifg=#cbccd1 guibg=#204a87 gui=bold

hi rubyClass                    ctermfg=107  ctermbg=NONE cterm=NONE guifg=#78bd65 guibg=NONE gui=NONE
hi rubyFunction                 ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi rubyInterpolationDelimiter   ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi rubySymbol                   ctermfg=167  ctermbg=NONE cterm=bold guifg=#ea3d54 guibg=NONE gui=bold
hi rubyConstant                 ctermfg=167  ctermbg=NONE cterm=NONE guifg=#ea3d54 guibg=NONE gui=italic
hi rubyStringDelimiter          ctermfg=74   ctermbg=NONE cterm=NONE guifg=#4fb3d8 guibg=NONE gui=NONE
hi rubyBlockParameter           ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi rubyInstanceVariable         ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi rubyInclude                  ctermfg=107  ctermbg=NONE cterm=NONE guifg=#78bd65 guibg=NONE gui=NONE
hi rubyGlobalVariable           ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi rubyRegexp                   ctermfg=74   ctermbg=NONE cterm=NONE guifg=#4fb3d8 guibg=NONE gui=NONE
hi rubyRegexpDelimiter          ctermfg=74   ctermbg=NONE cterm=NONE guifg=#4fb3d8 guibg=NONE gui=NONE
hi rubyEscape                   ctermfg=167  ctermbg=NONE cterm=bold guifg=#ea3d54 guibg=NONE gui=bold
hi rubyControl                  ctermfg=107  ctermbg=NONE cterm=NONE guifg=#78bd65 guibg=NONE gui=NONE
hi rubyClassVariable            ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi rubyOperator                 ctermfg=107  ctermbg=NONE cterm=NONE guifg=#78bd65 guibg=NONE gui=NONE
hi rubyException                ctermfg=107  ctermbg=NONE cterm=NONE guifg=#78bd65 guibg=NONE gui=NONE
hi rubyPseudoVariable           ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi rubyRailsUserClass           ctermfg=167  ctermbg=NONE cterm=NONE guifg=#ea3d54 guibg=NONE gui=italic
hi rubyRailsARAssociationMethod ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi rubyRailsARMethod            ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi rubyRailsRenderMethod        ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi rubyRailsMethod              ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE

hi erubyDelimiter   ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi erubyComment     ctermfg=60   ctermbg=NONE cterm=NONE guifg=#686b78 guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE

hi htmlTag         ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi htmlEndTag      ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi htmlTagName     ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi htmlArg         ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=167  ctermbg=NONE cterm=bold guifg=#ea3d54 guibg=NONE gui=bold

hi javaScriptFunction      ctermfg=107  ctermbg=NONE cterm=NONE guifg=#78bd65 guibg=NONE gui=italic
hi javaScriptRailsFunction ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi javaScriptBraces        ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE

hi yamlKey               ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi yamlKeyValueDelimiter ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi yamlBlockMappingKey   ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi yamlmappingKeyStart   ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi yamlAnchor            ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi yamlAlias             ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi yamlDocumentHeader    ctermfg=74   ctermbg=NONE cterm=NONE guifg=#4fb3d8 guibg=NONE gui=NONE

hi cssURL           ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
hi cssFunctionName  ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi cssColor         ctermfg=167  ctermbg=NONE cterm=bold guifg=#ea3d54 guibg=NONE gui=bold
hi cssPseudoClassId ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi cssClassName     ctermfg=221  ctermbg=NONE cterm=NONE guifg=#fedd38 guibg=NONE gui=NONE
hi cssValueLength   ctermfg=188  ctermbg=NONE cterm=NONE guifg=#cbccd1 guibg=NONE gui=NONE
hi cssCommonAttr    ctermfg=167  ctermbg=NONE cterm=NONE guifg=#ea3d54 guibg=NONE gui=NONE
hi cssBraces        ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE    guibg=NONE gui=NONE
