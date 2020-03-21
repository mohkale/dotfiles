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

case $OSTYPE in
    cygwin*|msys*|win32*) platform="windows" ;;
    darwin*)              platform="macos"   ;;
    linux-gnu*)           platform="linux"   ;;
    *)
        platform="mystery"
        echo "bash_aliases(warning) : unknown os type: $OSTYPE" >&2
        ;;
esac

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

[ "$platform" = "mystery" ] || ${platform}_bindings # invoke local function bindings for current platform

# build aliases from shortcuts config file
build_shortcuts_script="${SCRIPTS_DIR:-$HOME/programming/scripts}/private/build_shortcuts.sh"

if [ ! -x "$build_shortcuts_script" ]; then
    printf "bash_aliases(error) : failed to find build shortcuts script: %s\n" "$1" >&2
else
    shortcuts_root="$XDG_CONFIG_HOME/shortcuts"

    # nicest way to check whether the files exist or not, and then build shortcuts
    eval "$(find $shortcuts_root/shortcuts $shortcuts_root/shortcuts.private \
                 $shortcuts_root/$platform $shortcuts_root/$platform.private \
                 -exec "$build_shortcuts_script" -i1 '{}' + 2>/dev/null)"

    unset -f source_shortcuts source_file_maps get_shortcut_files_for_platform
    unset shortcuts_root
fi

unset platform build_shortcuts_script
unset -f windows_bindings macos_bindings linux_bindings
