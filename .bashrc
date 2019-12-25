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

shopt -s globstar # enable **/* in shell globing
shopt -s autocd   # cd to path automatically.

# Configure Bash History
HISTCONTROL=ignoreboth # ignore duplicate lines or lines with spaces
shopt -s histappend # open history file as a, not w
HISTSIZE=1000 HISTFILESIZE=2000 # change command history sizes

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Configure Environment Variables
# see also ./.bash_profile

scripts_path="${HOME}/programming/scripts"

# COLOR_CODED_PS1=1           # uncomment line to color code bash prompt
# SILENCE_SHORTCUTS_WARNING=1 # uncomment to make build shortcuts quiet

# Source all the following scripts
plugin_scripts=(
    "${HOME}/.colors.bashrc"
    "${HOME}/.bash_aliases"
    "${HOME}/.bash_ps1"
    # "${HOME}/.rvm/scripts/rvm"
)

for plugin_script in "${plugin_scripts[@]}"; do
    if [ -f "${plugin_script}" ]; then
        . "${plugin_script}"
    else
        printf "bashrc::warning() : unable to source plugin script: %s\n" "${plugin_script}" >&2
    fi
done
