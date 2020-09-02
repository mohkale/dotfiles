#!/usr/bin/sh
[ -z "$1" ] && exit 1

# See For More: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# Color Codes: \[\e[0;%dm\] % (code)
#     * DIM               ~> 0
#     * BRIGHT            ~> 1 (for colors in 30s)
#     * BOLD              ~> 1 (for colors in 90s)
#
#     * BLACK             ~> 30
#     * RED               ~> 31
#     * GREEN             ~> 32
#     * YELLOW            ~> 33
#     * LIGHT_BLUE        ~> 34
#     * PURPLE            ~> 35
#     * CYAN              ~> 36
#     * WHITE             ~> 37
#     * RESTORE           ~> 39
#     * DARK GREY         ~> 90
#     * LIGHT RED         ~> 91
#     * LIGHT GREEN       ~> 92
#     * LIGHT YELLOW      ~> 93
#     * LIGHT BLUE        ~> 94
#     * LIGHT MAGENTA     ~> 95
#     * LIGHT CYAN        ~> 96
#     * LIGHT WHITE (WTF) ~> 97

case "$1" in
    1) # catchall for general errors
        echo -n '\[\e[1;31m\]'
        ;;
    2) # misuse of shell builtins
        echo -n '\[\e[1;31m\]'
        ;;
    126) # command invoked cannot execute
        echo -n '\[\e[1;31m\]'
        ;;
    127) # command not found
        echo -n '\[\e[1;34m\]'
        ;;
    128) # invalid argument to exit
        echo -n '\[\e[1;31m\]'
        ;;
    129) # SIGHUP
        echo -n '\[\e[1;31m\]'
        ;;
    130) # SIGINT
        echo -n '\[\e[1;33m\]'
        ;;
    131) # SIGQUIT
        echo -n '\[\e[1;31m\]'
        ;;
    132) # SIGILL
        echo -n '\[\e[1;31m\]'
        ;;
    133) # SIGTRAP
        echo -n '\[\e[1;31m\]'
        ;;
    134) # SIGABRT
        echo -n '\[\e[1;31m\]'
        ;;
    135) # SIGBUS
        echo -n '\[\e[1;31m\]'
        ;;
    136) # SIGFPE
        echo -n '\[\e[1;31m\]'
        ;;
    137) # SIGKILL
        echo -n '\[\e[1;35m\]'
        ;;
    255) # Exit Status Out Of Range
        echo -n '\[\e[1;31m\]'
        ;;
    *)
        exit 1
        ;;
esac
