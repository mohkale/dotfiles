info 'Installing terminfo declarations'
# Order is significant, there are dependencies between definitions.
run-cmd find                                    \
    st.terminfo                                 \
    tmux.terminfo                               \
    st-tmux.terminfo                            \
    tmux-24bit.terminfo                         \
    st-tmux-24bit.terminfo                      \
  -type f -exec tic -x {} \;
