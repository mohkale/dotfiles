#  ____             __ _ _
# |  _ \ _ __ ___  / _(_) | ___
# | |_) | '__/ _ \| |_| | |/ _ \
# |  __/| | | (_) |  _| | |  __/
# |_|   |_|  \___/|_| |_|_|\___|
#

# platform dependent config
case "${OSTYPE}" in
    *cygwin|*msys|*win32)
        export EDITOR=vim
        ;;
    *linux-gnu|*darwin|*freebsd)
        export EDITOR=nvim
        ;;
    *)
        export EDITORY=vi
        ;;
esac

export VISUAL="${EDITOR}"

# set path based variables
lines_to_path() { #(PATH [...PATH])
    # converts a list of paths into a PATH like string sequence,
    # with support for comments and auto removal of empty lines.

    # NOTE trailing whitespace is automatically removed with
    #      inline comments.

    if [ $# -gt 0 -a ! -z "$1" ]; then
        # print existing path variables when given
        # in linux path format.

        case "${OSTYPE}" in
            *cygwin|*msys)
                printf "%s:" "$(cygpath --path "$*")"
                ;;
            *)
                printf "%s:" "$*"
                ;;
        esac
    fi

    sed -e 's/ *#.*$//g' -e '/^ *$/d' | tr '\n' ':' | sed -e 's/:$//'
    # strip out empty lines and comments and join paths with a :
}

export PATH=`lines_to_path $PATH <<EOF
~/programming/scripts/public
~/programming/programs
~/programming/.modules/node
EOF`

export CLASSPATH=`lines_to_path $CLASSPATH <<EOF
.
~/programming/.modules/java/*
EOF`

export PYTHONPATH=`lines_to_path $PYTHONPATH <<EOF
~/programming/.modules/python
EOF`

if [ ${OSTYPE} == "msys" -o ${OSTYPE} == "cygwin" ]; then
    # for programs that don't care about the environment,
    # only about the OS, convert back to a windows like path.
    # NOTE Also convert ~ to ${HOME} cause apparrently python
    #      won't accept ~ as ${HOME} in PATH variables.

    for path_var in CLASSPATH PYTHONPATH; do
        export ${path_var}=$(cygpath --windows --path "$(echo "${!path_var}" | sed 's ~ '"${HOME}"' g')")
    done
fi

unset -f lines_to_path
