# -*- mode: shell-script -*-

# ___.                 .__                .__  .__
# \_ |__ _____    _____|  |__      _____  |  | |_______    ______ ____   ______
#  | __ \\__  \  /  ___|  |  \     \__  \ |  | |  \__  \  /  ____/ __ \ /  ___/
#  | \_\ \/ __ \_\___ \|   Y  \     / __ \|  |_|  |/ __ \_\___ \\  ___/ \___ \
#  |___  (____  /____  |___|  _____(____  |____|__(____  /____  >\___  /____  >
#      \/     \/     \/     \/_____/    \/             \/     \/     \/     \/

# build aliases from shortcuts config file
build_shortcuts_script="${scripts_path}/build_shortcuts.sh"
shortcuts_file="${HOME}/.shortcuts"

if [ ! -f "${build_shortcuts_script}" ]; then
    printf "bash_aliases::error() : failed to find build_shortcuts script: %s\n" "${build_shortcuts_script}" >&2
elif [ ! -f "${shortcuts_file}" ]; then
    printf "bash_aliases::error() : failed to find shortcuts definition file: %s\n" "${shortcuts_file}" >&2
else
    if [ "${SILENCE_SHORTCUTS_WARNING}" ]; then
        . ${build_shortcuts_script} "${shortcuts_file}" 2>/dev/null
    else
        . ${build_shortcuts_script} "${shortcuts_file}"
    fi
fi

# OS dependent bindings
get_last_command() { history | tail -n 2 | head -n 1 | sed -E 's/^ [0-9]+  //'; }

case ${OSTYPE} in
    cygwin*|msys*|win32*)
        alias smacs='runemacs'

        alert() {
            # no configuration, simply notify the user of a message under the title of the last command
            notifu -w -t $([ $? -eq 0 ] && echo "info" || echo "error") -p "$(get_last_command)" -m "$*"
        }
        ;;
    *)
        smacs() { emacs $@ & }
        alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(get_last_command)"'
        ;;
    # run as a background process
esac
