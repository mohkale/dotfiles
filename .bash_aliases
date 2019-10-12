# -*- mode: shell-script -*-

# ___.                 .__                .__  .__
# \_ |__ _____    _____|  |__      _____  |  | |_______    ______ ____   ______
#  | __ \\__  \  /  ___|  |  \     \__  \ |  | |  \__  \  /  ____/ __ \ /  ___/
#  | \_\ \/ __ \_\___ \|   Y  \     / __ \|  |_|  |/ __ \_\___ \\  ___/ \___ \
#  |___  (____  /____  |___|  _____(____  |____|__(____  /____  >\___  /____  >
#      \/     \/     \/     \/_____/    \/             \/     \/     \/     \/

# build aliases from shortcuts config file
build_shortcuts_script="${scripts_path}/build_shortcuts.sh"
build_fsshortcuts_script="${scripts_path}/build_fsshortcuts.sh"

_source_shortcuts_file() { # (SCRIPT, PATH)
    if [ ! -f "$1" ]; then
        printf "bash_aliases::error : failed to find build shortcuts script: %s\n" "$1" >&2
        return 1
    elif [ ! -f "$2" ]; then
        printf "bash_aliases::warning : failed to find shortcuts definition file: %s\n" "$2" >&2
        return 2
    else
        if [ "${SILENCE_SHORTCUTS_WARNING}" ]; then
            . "$1" "$2" 2>/dev/null
        else
            . "$1" "$2"
        fi
    fi
}

_source_shortcuts_file "${build_shortcuts_script}"   "${HOME}/.shortcuts/shortcuts"
_source_shortcuts_file "${build_fsshortcuts_script}" "${HOME}/.shortcuts/fsmaps"

get_last_command() { history | tail -n 2 | head -n 1 | sed -E 's/^ [0-9]+  //'; }

case ${OSTYPE} in
    cygwin*|msys*|win32*)
        alert() {
            # no configuration, simply notify the user of a message under the title of the last command
            notifu -w -t $([ $? -eq 0 ] && echo "info" || echo "error") -p "$(get_last_command)" -m "$*"
        }

        _source_shortcuts_file "${build_shortcuts_script}" "${HOME}/.shortcuts/shortcuts.windows" ;;
    darwin*)
        _source_shortcuts_file "${build_shortcuts_script}" "${HOME}/.shortcuts/shortcuts.macos" ;;
    linux-gnu*)
        smacs() { emacs "$@" & }  # run as a background process

        _source_shortcuts_file "${build_shortcuts_script}" "${HOME}/.shortcuts/shortcuts.linux" ;;
    *)
        printf "basah_aliases::warning : unknown os type: %s\n" "${OSTYPE}" >&2 ;;
esac

unset -f _source_shortcuts_file
