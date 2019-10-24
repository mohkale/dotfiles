# -*- mode: shell-script -*-

# ___.                 .__                .__  .__
# \_ |__ _____    _____|  |__      _____  |  | |_______    ______ ____   ______
#  | __ \\__  \  /  ___|  |  \     \__  \ |  | |  \__  \  /  ____/ __ \ /  ___/
#  | \_\ \/ __ \_\___ \|   Y  \     / __ \|  |_|  |/ __ \_\___ \\  ___/ \___ \
#  |___  (____  /____  |___|  _____(____  |____|__(____  /____  >\___  /____  >
#      \/     \/     \/     \/_____/    \/             \/     \/     \/     \/

# build aliases from shortcuts config file
build_shortcuts_script="${scripts_path}/build_shortcuts.sh"

_source_shortcuts_file() { # (PATH, FS=[1: true, 0: false])
    if [ ! -f "${build_shortcuts_script}" ]; then
        printf "bash_aliases::error : failed to find build shortcuts script: %s\n" "$1" >&2
        return 1
    elif [ ! -f "$1" ]; then
        printf "bash_aliases::warning : failed to find shortcuts definition file: %s\n" "$1" >&2
        return 2
    else
        if [ "${SILENCE_SHORTCUTS_WARNING}" ]; then
            if [ ${2:-0} == 0 ]; then
                eval $(INLINE=1 "${build_shortcuts_script}" "$1" 2>/dev/null)
            else
                eval $(INLINE=1 FS=1 "${build_shortcuts_script}" "$1" 2>/dev/null)
            fi
        else
            if [ ${2:-0} == 0 ]; then
                eval $(INLINE=1 "${build_shortcuts_script}" "$1")
            else
                eval $(INLINE=1 FS=1 "${build_shortcuts_script}" "$1")
            fi
        fi
    fi
}

_source_shortcuts_file "${HOME}/.shortcuts/shortcuts"
_source_shortcuts_file "${HOME}/.shortcuts/fsmaps" FS=1

get_last_command() { history | tail -n 2 | head -n 1 | sed -E 's/^ [0-9]+  //'; }

makecd() {
    mkdir -p "$*"
    cd       "$*"
}

export -f makecd

case ${OSTYPE} in
    cygwin*|msys*|win32*)
        alert() {
            # no configuration, simply notify the user of a message under the title of the last command
            notifu -w -t $([ $? -eq 0 ] && echo "info" || echo "error") -p "$(get_last_command)" -m "$*"
        }

        _source_shortcuts_file "${HOME}/.shortcuts/shortcuts.windows" ;;
    darwin*)
        _source_shortcuts_file "${HOME}/.shortcuts/shortcuts.macos" ;;
    linux-gnu*)
        smacs() { emacs "$@" & }  # run as a background process

        _source_shortcuts_file "${HOME}/.shortcuts/shortcuts.linux" ;;
    *)
        printf "basah_aliases::warning : unknown os type: %s\n" "${OSTYPE}" >&2 ;;
esac

unset -f _source_shortcuts_file
