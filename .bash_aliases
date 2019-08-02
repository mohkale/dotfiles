# -*- mode: shell-script -*-

# ___.                 .__                .__  .__
# \_ |__ _____    _____|  |__      _____  |  | |_______    ______ ____   ______
#  | __ \\__  \  /  ___|  |  \     \__  \ |  | |  \__  \  /  ____/ __ \ /  ___/
#  | \_\ \/ __ \_\___ \|   Y  \     / __ \|  |_|  |/ __ \_\___ \\  ___/ \___ \
#  |___  (____  /____  |___|  _____(____  |____|__(____  /____  >\___  /____  >
#      \/     \/     \/     \/_____/    \/             \/     \/     \/     \/

case ${OSTYPE} in
    cygwin*|msys*|win32*)
        alias smacs='runemacs' ;;
    *)
        smacs() { emacs $@ & } ;;
        # run as a background process
esac

# build aliases from shortcuts config file
build_scripts_script="${scripts_path}/build_shortcuts.sh"
shortcuts_file="${HOME}/.shortcuts"

if [ ! -f "${build_scripts_script}" ]; then
    printf "bash_aliases::error() : failed to find build_shortcuts script: %s\n" "${build_scripts_script}" >&2
elif [ ! -f "${shortcuts_file}" ]; then
    printf "bash_aliases::error() : failed to find shortcuts definition file: %s\n" "${shortcuts_file}" >&2
else
    if [ "${SILENCE_SHORTCUTS_WARNING}" ]; then
        . ${build_scripts_script} "${shortcuts_file}" 2>/dev/null
    else
        . ${build_scripts_script} "${shortcuts_file}"
    fi
fi
