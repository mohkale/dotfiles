#!/bin/bash
export FS=${FS:-${fs:-0}}
export INLINE=${INLINE:-${inline:-0}}

while getopts "h?fi" option; do
    case "$option" in
        [h|?])
            echo 'Usage: eval "$(build_shortcuts.sh [-f] [-i] SHORTCUTS_FILE [SHORTCUTS_FILE...])"'
            exit 0
            ;;
        f) export FS=1
           ;;
        i) export INLINE=1
           ;;
    esac
done

shift $(($OPTIND - 1))

read_scripts() { #(*files)
    cat "$@" | sed -r - -e 's/#.*$//' -e '/^\s+/s/^\s+//' -e '/^\s*$/d' -e 's/'"'"'/'"'"'"'"'"'"'"'"'/g' -e 's/\\/\\\\/g'
    # strip comments, entry level indentation, empty lines and escape single quotes (in that order)
    # from every input file concatenated together.
}

create_program_aliases() { #(*files)
    script="$(read_scripts $@)"

    if [ ! -z "${script}" ]; then
        while read cut dest; do
            echo alias $cut="'"$dest"'"
        done <<< "$script"
    fi
}

create_fs_aliases() {
    script="$(read_scripts $@)"

    if [ ! -z "${script}" ]; then
        while read cut dest; do
            is_file=1 # whether fs map references an editable file or (cd/pushd)-able directory
            case $cut in *@file) cut=$(echo "$cut" | sed -e 's/@file$//'); is_file=0; ;; esac

            if [ $is_file -eq 0 ]; then
                echo alias $cut="'"${EDITOR:-edit}' '$dest"'"
            else
                echo alias  $cut="'"'cd '$dest"'"
                echo alias q$cut="'"'pushd '$dest"'"
            fi
        done <<< "$script"
    fi
}

_inline_alias_calls() {
    # turn an output stream with rows of alias calls,
    # into one alias calls with multiple alias targets

    input=$(cat) # read STDIN into variable

    if [ ! -z "$input" ]; then
        echo "$input"           \
            | sed 's/^alias //' \
            | tr '\n' ' '       \
            | awk -e 'BEGIN { printf "alias " }' -e '{ printf("%s", $0) }' -e 'END { printf "\n" }'
    fi
}

failed=1

for file in $@; do
    if [ ! -e "$file" ]; then
        echo "build_shortcuts(error) : shortcut path '$file' not found" >&2
        failed=0
    elif [ ! -f "$file" ]; then
        echo "build_shortcuts(error) : shortcut path '$file' is not a file" >&2
        failed=0
    elif [ ! -r "${file}" ]; then
        echo "build_shortcuts(error) : shortcut file '$file' is not readable" >&2
        failed=0
    fi
done

if [ ! $failed -eq 0 ]; then
    if [ $FS == 0 ]; then
        command=create_program_aliases
    else
        command=create_fs_aliases
    fi

    if [ $INLINE == 1 ]; then
        pipe_filter=_inline_alias_calls
    fi

    $command "$@" | ${pipe_filter:-cat}
fi
