#!/bin/sh
if [ $# -eq 0 ]; then
    echo "Usage: . build_fsshortcuts.sh SHORTCUTS_FILE [SHORTCUTS_FILE...]" >&2
else
    failed=1

    for file in $@; do
        if ! ls "${file}" >/dev/null 2>&1; then
            echo "build_fsshortcuts::error() : shortcut path '${file}' not found" >&2
            failed=0
        elif [ ! -f "${file}" ]; then
            echo "build_fsshortcuts::error() : shortcut path '${file}' is not a file" >&2
            failed=0
        elif [ ! -r "${file}" ]; then
            echo "build_fsshortcuts::error() : shortcut file '${file}' is not readable" >&2
            failed=0
        fi
    done

    if [ ! $failed -eq 0 ]; then
        script="$(cat $@ | sed -r -e 's/#.*$//' -e '/^\s+/s/^\s+//' -e '/^\s*$/d' -)"
        # strip comments, entry level indentation & empty lines (in that order) from filestream

        while read cut dest; do
            is_file=1 # whether fs map references an editable file or (cd/pushd)-able directory
            case $cut in *@file) cut=$(echo "${cut}" | sed -e 's/@file$//'); is_file=0; ;; esac

            if [ $is_file -eq 0 ]; then
                if [ ! ${SHORTCUTS_OVERWRITE_EXISTING} ] && alias "${cut}" >/dev/null 2>&1; then
                    echo "build_fsshortcuts::warning : file shortcut '${cut}' already exists" >&2
                else
                    alias ${cut}='${EDITOR} '"${dest}"
                fi
            else
                if [ ! ${SHORTCUTS_OVERWRITE_EXISTING} ] &&
                       alias  ${cut} >/dev/null 2>&1     ||
                       alias q${cut} >/dev/null 2>&1; then
                    echo "build_fsshortcuts::warning : file shortcut '${cut}' or 'q${cut}' already exists" >&2
                else
                    alias ${cut}="cd ${dest}" q${cut}="pushd ${dest}"
                fi
            fi
        done <<< ${script}
    fi
fi
