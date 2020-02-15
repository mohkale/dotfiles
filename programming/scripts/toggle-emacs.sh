#!/usr/bin/sh
# shell script to manage and switch focus to emacs frames

TRUE=1
FALSE=0

running_windows() { # (desired_application_name)
    wmctrl -lp | while read window_row; do
        window_id=$(echo "${window_row}" | cut -d ' ' -f1)
        xprop_out=$(xprop -id ${window_id} _NET_WM_WINDOW_TYPE WM_CLASS)

        window_type=$(echo "${xprop_out}" | head -n 1)

        if $(echo ${window_type} | grep -q '_NET_WM_WINDOW_TYPE_NORMAL'); then
            window_application=$(echo "${xprop_out}" | tail -n1 | cut -d ' ' -f4-)
            window_application=${window_application:1:-1} # strip out wrapping ""

            [ "${window_application}" == "$1" ] && echo "${window_row}"
        fi
    done
}

emacs_windows=$(running_windows "Emacs") # all the open emacs frames
# emacs_windows=$(wmctrl -lp | grep -P "${USER}"@"$(hostname)") # all the open emacs frames

# default settings
create_frame_when_none_found=${FALSE}
filter_by_desktop=${TRUE} # when true, only frames in current dekstop are focused
toggle_backwards=${FALSE} # go backwards in emacs window list instead of forwards

#region parse args
if [ $# -gt 0 ]; then
    for argument in "$@"; do
        case "${argument}" in
        "--all-desktops" | "-a")
            filter_by_desktop=${FALSE}
            ;;
        "--backwards" | "-b")
            toggle_backwards=${TRUE}
            ;;
        "--create" | "-c")
            create_frame_when_none_found=${TRUE}
            ;;
        "--help" | "-h")
            echo "$0 [--all-desktops] [--backwards] [--create]" >&2
            exit 1
            ;;
        *) # default
            notify-send "toggle-emacs::unknown-flag() : ${argument}"
            ;;
        esac
    done
fi
#endregion

get_next_emacs_window() { #(active_window_wid)
    # retrieves the wmctrl row entry for the next emacs window
    # this method also handles logic for moving forwards or
    # backwards and makes sure to wrap around to the first or
    # last known window when the end or beginning is reached.

    if [ ${toggle_backwards} -eq ${TRUE} ]; then
        awk_script='{ print prev; exit }; { prev=$0 }' # print previous or empty
        wraparound_command="tail -n 1" # back to bottom when top of list reached
    else
        awk_script='{ getline; print; exit }' # print line after match & quit
        wraparound_command="head -n 1" # back to top when bottom of list reached
    fi

    next_row=$(echo "${emacs_windows}" | awk -e '{ print $0 }' -e 'END { print "\n" }' | awk -e '$1 ~ /(0x)?0*'$1'/ '"${awk_script}")
    if [ ! -z "${next_row}" ]; then echo "${next_row}"; else echo "${emacs_windows}" | ${wraparound_command}; fi # row or wrapped row
}

if [ -z "${emacs_windows}" ]; then
    [ ${create_frame_when_none_found} -eq ${TRUE} ] && emacs
    # begin in current dekstop when there's no frame to toggle
else
    active_desktop=$(wmctrl -d | grep -P '\*' | cut -d ' ' -f 1)
    in_current_desktop=$(echo "${emacs_windows}" | awk -e '$2 == '${active_desktop})

    if [ "${filter_by_desktop}" -eq ${TRUE} -a ! -z "${in_current_desktop}" ]; then
        # only work on those in current desktop when a frame in this desktop exists & filter_by_desktop is true
        emacs_windows=${in_current_desktop}
    fi

    if [ $(echo "${emacs_windows}" | wc -l) -eq ${TRUE} ]; then
        # only one emacs window is open, simply toggle it
        wmctrl -ia $(echo "${emacs_windows}" | cut -d ' ' -f 1)
    else
        active_window_wid=$(printf "%x" $(xdotool getwindowfocus)) # as hex, no preceding 0x0
        active_window_pid=$(xdotool getwindowfocus getwindowpid) # for comparing emacs active?

        if [ -z "$(echo "${emacs_windows}" | awk -e '$3 == '${active_window_pid})" ]; then
            # currently active window isn't emacs, so activate first match
            wmctrl -ia $(echo "${emacs_windows}" | head -n 1 | cut -d ' ' -f 1)
        else
            wmctrl -ia $(get_next_emacs_window "${active_window_wid}" | cut -d ' ' -f 1)
        fi
    fi
fi
