#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH="${PATH}:~/programming/scripts/public"

case "${OSTYPE}" in
    *cygwin|*msys|*win32)
        EDITOR=vim
        ;;
    *linux-gnu|*darwin|*freebsd)
        EDITOR=nvim
        ;;
    *)
        EDITORY=vi
        ;;
esac

export VISUAL="${EDITOR}"

