#  _               _
# | |             | |
# | |__   __ _ ___| |__  _ __ ___
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__
# |_.__/ \__,_|___/_| |_|_|  \___|
#

# Only Run bashrc if being run interactively
case $- in
    *i*) ;;
      *) return;;
esac

. ~/.shenv

shopt -s globstar # enable **/* in shell globing
shopt -s autocd   # cd to path automatically.
shopt -s histappend # open history file as a, not w
HISTCONTROL=ignoreboth # ignore duplicate lines or lines with spaces.

# enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# SILENCE_SHORTCUTS_WARNING=1 # uncomment to make build shortcuts quiet

# source all the following scripts
plugin_scripts=(
    "$HOME/.colors.bashrc"
    "$HOME/.bash_aliases"
)

# source if available, else ignore.
optional_plugins=(
    "$HOME/.rvm/scripts/rvm"
)

for plugin_script in "${plugin_scripts[@]}"; do
    if [ -f "$plugin_script" ]; then . "$plugin_script"; else
        printf "bashrc(warning) : unable to source plugin script: %s\n" "$plugin_script" >&2
    fi
done

for plugin in "${optional_plugins[@]}"; do
    [ -x "$plugin" ] && . "$plugin"
done

[ "${SMART_TERM:-0}" -eq 1 ] && . "$SCRIPTS_DIR/.ps1/bash"
