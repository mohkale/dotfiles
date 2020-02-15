#!/bin/bash
# -*- mode: shell-script -*-
# how it works from the root shortcuts directory:
#   * shortcuts are read from a file named shortcuts
#   * file maps are read from a file named fsmaps
#   * file maps are also read from a files ending with
#     the extension 'fs' (case insensitive) in the
#     .private subdirectory
#   * all other files in the .private directory are read
#     as shortcut files.
# the process is then repeated in the platform specific
# subdirectory.

export shortcuts_root="$HOME/.shortcuts"
export FS=0 # not a file system shortcut
skip_global=0 # not skipping global shortcuts

while getopts "h?s:f!" option; do
    case "$option" in
        h|\?)
            echo "$(basename "$0") [-h] [-!] [-s SHORTCUTS_PATH] [PLATFORM [PLATFORM...]]"
            exit 0
            ;;
        s)  export shortcuts_root=$OPTARG
            ;;
        f)  export FS=1
            ;;
        \!) skip_global=1
            ;;
    esac
done

shift $(($OPTIND - 1))

get_shortcut_files() { # (platform)
    shortcuts_path=$shortcuts_root # root path default
    [ $# != 0 ] && shortcuts_path=$shortcuts_root/$*

    if [ $FS = 1 ]; then
        [ -f $shortcuts_path/fsmaps ] && echo $shortcuts_path/fsmaps
        find "$shortcuts_path/.private" -type f -iname '*.fs' 2>/dev/null
    else
        [ -f $shortcuts_path/shortcuts ] && echo $shortcuts_path/shortcuts
        find "$shortcuts_path/.private" -type f -not -iname '*.fs' 2>/dev/null
    fi
}

if [ $skip_global == 0 ]; then
    get_shortcut_files # no platform
fi

for platform in "$@"; do
    get_shortcut_files "$platform"
done
