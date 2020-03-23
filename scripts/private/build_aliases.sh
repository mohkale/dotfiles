#!/bin/bash
inline=0
ignore=0
prettify=0
editor=${EDITOR:-vi}

while getopts "hi1e:Pp" option; do
    case "$option" in
        [h?])
            echo 'Usage: eval "$(build_shortcuts.sh [-1] [-i] [-P] [-e EDITOR] FILE [FILE...])"'
            exit 0
            ;;
        1) inline=1
           ;;
        i) ignore=1
           ;;
        e) editor=$OPTARG
           ;;
        P) prettify=0 # probably the safe bet :)
           ;;
        p) prettify=1
           ;;
    esac
done

shift $(($OPTIND - 1))

read_scripts() { #(*files)
    cat "$@" | sed -r - -e ':x /\\$/ { N; s/\\\n//g ; bx }' \
                        -e 's/#.*$//'                       \
                        -e '/^\s+/s/^\s+//'                 \
                        -e '/^\s*$/d'

    # join lines ending with a backslash together, then strip comments, entry
    # level indentation, empty lines (in that order) from every input file
    # concatenated together.
    # the line joining program was a godsend from the gnu sed manual:
    #  * https://www.gnu.org/software/sed/manual/html_node/Joining-lines.html
}

create_aliases() { #(*files)
    while read -r cut dest; do
        # available tags:
        #  @file create a file shortcut, invoking it opens editor with it.
        #  @dir  create a dir shortcut, invoking it changes dir to it.
        #  @dirx same as @dir, but also creates a q{name} alias which
        #        pushes onto the directory stack.
        case "$cut" in
            *@file) cut=${cut%@file*}
                    echo alias ${cut@Q}=${editor@Q}"' '"${dest@Q}
                    ;;
            *@dir) cut=${cut%@dir*}
                   echo alias ${cut@Q}="'cd '"${dest@Q}
                   ;;
            *@dirx) cut="${cut%@dir*}"
                    echo alias  ${cut@Q}="'cd '"${dest@Q}
                    echo alias q${cut@Q}="'pushd '"${dest@Q}
                    ;;
            *) echo alias ${cut@Q}=${dest@Q}
               ;;
        esac
    done < <(read_scripts "$@") | if [ "$prettify" -eq 1 ]; then sed "s/''//g"; else cat; fi
}

_inline_alias_calls() {
    # turn an output stream with rows of alias calls,
    # into one alias calls with multiple alias targets

    cat | sed 's/^alias //' \
        | tr '\n' ' '       \
        | awk -e 'BEGIN { printf "alias " }' -e '{ printf("%s", $0) }' -e 'END { printf "\n" }'
}

failed=0

for file in $@; do
    if [ ! -e "$file" ]; then
        echo "build_shortcuts(error) : shortcut path '$file' not found" >&2
        failed=1
    elif [ ! -f "$file" ]; then
        echo "build_shortcuts(error) : shortcut path '$file' is not a file" >&2
        failed=1
    elif [ ! -r "${file}" ]; then
        echo "build_shortcuts(error) : shortcut file '$file' is not readable" >&2
        failed=1
    fi
done

[ "$failed" -eq 1 -a "$ignore" -eq 0 ] && exit 1

create_aliases "$@" | if [ "$inline" -eq 1 ]; then _inline_alias_calls; else cat; fi
