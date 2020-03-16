# -*- mode: shell-script -*-

# ___.                 .__                .__  .__
# \_ |__ _____    _____|  |__      _____  |  | |_______    ______ ____   ______
#  | __ \\__  \  /  ___|  |  \     \__  \ |  | |  \__  \  /  ____/ __ \ /  ___/
#  | \_\ \/ __ \_\___ \|   Y  \     / __ \|  |_|  |/ __ \_\___ \\  ___/ \___ \
#  |___  (____  /____  |___|  _____(____  |____|__(____  /____  >\___  /____  >
#      \/     \/     \/     \/_____/    \/             \/     \/     \/     \/

# aliases implemented as bash functions and desired regardless of platform
get_last_command() { history | tail -n 2 | head -n 1 | sed -E 's/^ [0-9]+  //'; }

makecd() {
    mkdir -p "$*"
    cd       "$*"
}

export -f makecd # make available in bash subprocesses

ec_cmd() {
    # echo the valid emacsclient command for OSTYPE.
    local flags= s_file="${EMACS_SERVER_FILE}"

    case "$OSTYPE" in
        cygwin*|msys*|win32*) ;;
        *) flags='--socket-name '"$s_file"
           # windows doesn't support --socket-name
           ;;
    esac

    echo emacsclient $flags --server-file "$s_file";
}

ec() { $(ec_cmd) "$@"; }
export -f ec

with_emacs() {
    # run a command with editor set to emacsclient.
    local usage="with-emacs [-h] COMMAND [ARGS...]" cmd=$(ec_cmd)

    if [ "$#" -eq 0 ]; then
        echo -e "EDITOR=${cmd@Q}\nVISUAL=${cmd@Q}"
    else
        local OPTIND OPTION
        while getopts 'h?' OPTION; do
            case "$OPTION" in
                h) echo "$usage"
                   return 0
                   ;;
                *) echo "$usage" >&2
                   return 1
                   ;;
            esac
        done
        shift $((OPTIND-1))

        EDITOR="$cmd" VISUAL="$cmd" "$@"
    fi
}
alias with-emacs='with_emacs ' # alias expanding version

alias sd='sudo '

# build aliases from shortcuts config file
build_shortcuts_script="${SCRIPTS_DIR:-$HOME/programming/scripts}/private/build_shortcuts.sh"

source_shortcuts() { # (PATH, FS=[1: true, 0: false])
    if [ ! -f "${build_shortcuts_script}" ]; then
        printf "bash_aliases(error) : failed to find build shortcuts script: %s\n" "$1" >&2
        return 1
    else
        if [ "${SILENCE_SHORTCUTS_WARNING}" ]; then
            eval $(INLINE=1 "$build_shortcuts_script" "$@" 2>/dev/null)
        else
            eval $(INLINE=1 "$build_shortcuts_script" "$@")
        fi
    fi
}

source_file_maps() { FS=1 source_shortcuts "$@"; }

windows_bindings() {
    function alert {
        # no configuration, simply notify the user of a message under the title of the last command
        notifu -w -t $([ $? -eq 0 ] && echo "info" || echo "error") -p "$(get_last_command)" -m "$*"
    }
}

macos_bindings() {
    :
}

linux_bindings() {
    smacs() { emacs "$@" & }  # run as a background process
}

# see ~/programming/scripts/list_shortcuts.sh
get_shortcut_files_for_platform() { # (platform)
    shortcuts_root="$HOME/.shortcuts"

    if [ $# != 0 ]; then
        # platform specified, find the
        # non platform shortcuts first
        get_shortcut_files_for_platform
        shortcuts_root=$shortcuts_root/$*
    fi

    if [ ${FS:-0} = 1 ]; then
        [ -f $shortcuts_root/fsmaps ] && echo $shortcuts_root/fsmaps
        find "$shortcuts_root/.private" -type f -iname '*.fs' 2>/dev/null
    else
        [ -f $shortcuts_root/shortcuts ] && echo $shortcuts_root/shortcuts
        find "$shortcuts_root/.private" -type f -not -iname '*.fs' 2>/dev/null
    fi
}

case $OSTYPE in
    cygwin*|msys*|win32*) platform="windows" ;;
    darwin*)              platform="macos"   ;;
    linux-gnu*)           platform="linux"   ;;
    *)
        echo "bash_aliases(warning) : unknown os type: $OSTYPE" >&2 ;;
esac

source_shortcuts $(     get_shortcut_files_for_platform $platform)
source_file_maps $(FS=1 get_shortcut_files_for_platform $platform)

[ -z "$platform" ] || ${platform}_bindings # invoke local function bindings for current platform

unset platform
unset -f source_shortcuts source_file_maps              \
         windows_bindings macos_bindings linux_bindings \
         get_shortcut_files_for_platform
