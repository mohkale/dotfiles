# -*- mode: conf-space; eval: (display-line-numbers-mode +1) -*-

# disable title poisoning
set global ui_options ncurses_set_title=false

# enable highlighting for all search matches
set-face global search +bi
add-highlighter global/search dynregex '%reg{/}' 0:search

# highlight TODO matches
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE)\b 0:default+rb

add-highlighter global/ number-lines -relative

# C-g works the same as escape
map global insert <c-g> <esc>
map global normal <c-g> '<space>;'
map global prompt <c-g> <esc>
# remove multiple selections
map global normal <backspace> '<space>'

# setup leader keys
map global normal <space> ',' -docstring 'leader'
# TODO bind user m to bindings for the current
# file type.
map global normal ',' ',m'

declare-user-mode leader-buffer
map global user b ':enter-user-mode<space>leader-buffer<ret>' -docstring "buffers"
map global leader-buffer b ':buffer<space>' -docstring 'buffer'
map global leader-buffer m ':buffer<space>*debug*<ret>' -docstring 'messages'
map global leader-buffer s ':buffer<space>*scratch*<ret>' -docstring 'scratch'

declare-user-mode leader-file
map global user f ':enter-user-mode<space>leader-file<ret>' -docstring "files"

declare-user-mode leader-toggle
map global user t ':enter-user-mode<space>leader-toggle<ret>' -docstring "toggle"

# make zero work like it does in vim.
map global normal 0 ':zero<ret>'
define-command zero %{evaluate-commands %sh{
    if [ "$kak_count" = 0 ]; then
        echo "exec gh"
    else
        echo "exec ${kak_count}0"
    fi
}}

# Local Variables:
# electric-pair-preserve-balance: t
# End:
