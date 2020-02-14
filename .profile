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
        if which nvim >/dev/null 2>&1; then
            export EDITOR=nvim
        else
            export EDITOR=vim
        fi
        ;;
    *)
        export EDITORY=vi
        ;;
esac

export VISUAL="$EDITOR"
export PAGER=less
export LESS="-R"
export DOTFILES_REPO_PATH=$HOME/.dotfiles
export TMUX_TMPDIR=$HOME/.tmux/tmp/
export EMACS_SERVER_FILE=$HOME/.emacs.d/var/server/server

# Custom Configuration Paths
export PROGRAM_DIR=$HOME/programming
export SCRIPTS_DIR="$PROGRAM_DIR"/scripts

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

    sed -e 's/ *#.*$//g' -e '/^ *$/d' -e 's ^~/ '"${HOME}"/' g' | tr '\n' ':' | sed -e 's/:$//'
    # strip out empty lines and comments, replace ~/ with users home directory & join paths with a :
}

export PATH=`lines_to_path $PATH <<EOF
$SCRIPTS_DIR/public
$PROGRAM_DIR/bin
$PROGRAM_DIR/.modules/node
$PROGRAM_DIR/.modules/ruby/bin
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
$PROGRAM_DIR/.modules/java/
$PROGRAM_DIR/.modules/java/*
EOF`

export PYTHONPATH=`lines_to_path $PYTHONPATH <<EOF
$PROGRAM_DIR/.modules/python
EOF`

export GEM_HOME=$PROGRAM_DIR/.modules/ruby
export GEM_PATH=`lines_to_path $GEM_PATH <<EOF
$PROGRAM_DIR/.modules/ruby
EOF`

if [ ${OSTYPE} == "msys" -o ${OSTYPE} == "cygwin" ]; then
    # for programs that don't care about the environment,
    # only about the OS, convert back to a windows like path.
    # NOTE Also convert ~ to ${HOME} cause apparrently python
    #      won't accept ~ as ${HOME} in PATH variables.

    for path_var in CLASSPATH PYTHONPATH; do
        export ${path_var}=$(cygpath --windows --path "$(echo "${!path_var}")")
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

# uses darcula theme from fzf color schemes wiki
export FZF_DEFAULT_OPTS="
    --bind ctrl-j:down
    --bind ctrl-k:up
    --bind ctrl-u:page-up
    --bind ctrl-d:page-down
    --bind alt-h:backward-word
    --bind alt-l:forward-char
    --bind alt-g:jump-accept
    --bind alt-j:jump-accept
    --bind shift-left:backward-word
    --bind shift-right:forward-word
    --bind ctrl-space:toggle+down
    --color dark
    --color fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
    --color info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
"

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
