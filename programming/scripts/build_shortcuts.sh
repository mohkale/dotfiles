#!/bin/sh
print_usage() {
    echo "Usage: . ./build_shortcuts.sh SHORTCUTS_FILE [SHORTCUTS_FILE...]" >&2
}

if [ $# = 0 ]; then
    print_usage
    exit 1
else
    FAILED=1

    for file in $@; do
        ls "${file}" &>/dev/null

        if [ $? != 0 ]; then
            echo "build_shortcuts::error() : shortcut path '${file}' not found" >&2
            FAILED=0
        elif [ ! -f "${file}" ]; then
            echo "build_shortcuts::error() : shortcut path '${file}' is not a file" >&2
            FAILED=0
        elif [ ! -r "${file}" ]; then
            echo "build_shortcuts::error() : shortcut file '${file}' is not readable" >&2
            FAILED=0
        fi
    done

    if [ $FAILED = 0 ]; then
        exit 1 # failed
    fi
fi

script="$(cat $@ | sed -r -e 's/#.*$//' -e '/^\s+/s/^\s+//' -e '/^\s*$/d' -)"
# strip comments, entry level indentation & empty lines (in that order) from filestream

while read cut dest; do
    if alias "${cut}" &>/dev/null; then
        echo "build_shortcuts::warning() : shortcut \"${cut}\" already exists" >&2
    else
        alias ${cut}="${dest}"
    fi
done <<< ${script}
