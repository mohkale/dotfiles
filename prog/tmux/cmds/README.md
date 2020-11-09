# Tmux Fzf Commands
My [fzf][fzf] shell scripts for managing tmux.

Some of these are largely just rewrites or refactorings or redesigns (whatever floats
your boat) of [tmux-fzf][tmux-fzf]. I wanted to keep these scripts in my dotfiles repo
so I could access them on any machine I've set up; copying from [tmux-fzf][tmux-fzf]
directly would be cool but I'm not a fan of public directories containing scripts I
personally don't run eg: `.fzf-tmux` and `menu.sh`.

The translations between the two is quite self explanatory:
- run-binding = keybinding.sh
- run-command = command.sh
- manage-window = window.sh

NOTE: I've removed a lot of the customisation options for [tmux-fzf][tmux-fzf], because
IMHO it makes the code harder to read, introduces coupling between scripts and isn't
really necessary so long as code duplication is kept to a minimum.

[fzf]:https://github.com/junegunn/fzf
[tmux-fzf]:https://github.com/sainnhe/tmux-fzf
