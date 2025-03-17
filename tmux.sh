#!/bin/bash

SESSION="bass-zig"

if tmux has-session -t $SESSION 2> /dev/null; then
    tmux-attach -t $SESSION
else
    tmux new-session -d -s $SESSION
    tmux new-window -t $SESSION
    tmux attach-session -t $SESSION
fi
