#!/bin/sh
if [ $# = 0 ]; then
    echo "Usage: . build_shortcuts.sh SHORTCUTS_FILE [SHORTCUTS_FILE...]" >&2
else
    failed=1

    for file in $@; do
        if ! ls "${file}" >/dev/null 2>&1; then
            echo "build_shortcuts::error() : shortcut path '${file}' not found" >&2
            failed=0
        elif [ ! -f "${file}" ]; then
            echo "build_shortcuts::error() : shortcut path '${file}' is not a file" >&2
            failed=0
        elif [ ! -r "${file}" ]; then
            echo "build_shortcuts::error() : shortcut file '${file}' is not readable" >&2
            failed=0
        fi
    done

    if [ ! $failed -eq 0 ]; then
        script="$(cat $@ | sed -r -e 's/#.*$//' -e '/^\s+/s/^\s+//' -e '/^\s*$/d' -)"
        # strip comments, entry level indentation & empty lines (in that order) from filestream

        while read cut dest; do
            if [ ! ${SHORTCUTS_OVERWRITE_EXISTING} ] && alias "${cut}" >/dev/null 2>&1; then
                echo "build_shortcuts::warning : shortcut '${cut}' already exists" >&2
            else
                alias ${cut}="${dest}"
            fi
        done <<< ${script}
    fi
fi
