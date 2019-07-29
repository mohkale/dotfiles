#!/bin/bash
shell_path=$(dirname $0)
cycle_flags="--all-desktops --backwards"

if [ -z "${shell_path}" ]; then
    toggle-emacs.sh ${cycle_flags}
else
    ${shell_path}/toggle-emacs.sh ${cycle_flags}
fi
