#  ____             __ _ _
# |  _ \ _ __ ___  / _(_) | ___
# | |_) | '__/ _ \| |_| | |/ _ \
# |  __/| | | (_) |  _| | |  __/
# |_|   |_|  \___/|_| |_|_|\___|
#

# bootstrap guide:
#  > git clone --bare https://github.com/MoHKale/.dotfiles $HOME/.dotfiles
#  > git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
#  > git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no

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

export EMACS_SERVER_FILE="$HOME/.emacs.d/var/server/server"
export VISUAL="$EDITOR" PAGER=less LESS="-R"
export DOTFILES_REPO_PATH=${HOME}/.dotfiles

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
~/.rvm/bin
EOF`

export CLASSPATH=`lines_to_path $CLASSPATH <<EOF
.
# WARN you need to specify both the directory with
#      wildcards to reference JARs and without them
#      for finding classes from that directory.
# WARN for some dumb reason... java & javac just
#      completely ignore this environment variable
#      when you pass the -cp argument.
~/programming/.modules/java/
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

unset -f lines_to_path # thank you, good bye

case ${OSTYPE} in
    cygwin*|msys*|win32*)
        ;;  # sources bashrc automatically
    *)
        if [ -n "$BASH_VERSION" ]; then
            if [ -f "${HOME}/.bashrc" ]; then
                . "${HOME}/.bashrc"
            fi
        fi
        ;;
esac

if which thefuck >/dev/null 2>&1; then
    # honestly I doubt I'll really be using 'the-fuck' but
    # lazy loading it is a near effortless task so why not

    export PYTHONIOENCODING="utf-8" # prevents error msg
    # lazy load 'the fuck' using an alias which evaluates
    # it removes the alias and then runs it for the first
    # time

    alias='fx' # alias under which 'the-fuck' will be invoked... actually a function
    alias $alias='eval $(thefuck --alias '$alias') && unalias '$alias' && '$alias
    unset alias # remove a basically uselass environment variable from the shell
fi
