#!/bin/sh
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

if [ "$1" = "-h" ]; then
    echo "$0 [SHORTCUTS_PATH [PLATFORM]]"
    exit 0
fi

shortcuts_root=${1:-"$HOME/.shortcuts"}
shift # strip shortcut root from argv

if [ $# != 0 ]; then
    # platform specified, find the
    # non platform shortcuts first
    "$0"
    shortcuts_root=$shortcuts_root/$*
fi

if [ ${FS:-0} = 1 ]; then
    [ -f $shortcuts_root/fsmaps ] && echo $shortcuts_root/fsmaps
    find "$shortcuts_root/.private" -type f -iname '*.fs' 2>/dev/null
else
    [ -f $shortcuts_root/shortcuts ] && echo $shortcuts_root/shortcuts
    find "$shortcuts_root/.private" -type f -not -iname '*.fs' 2>/dev/null
fi
