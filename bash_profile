#
# ~/.bash_profile
#

[ -d "$HOME/.cargo" ] && source "$HOME/.cargo/env"
[ -z "$DISPLAY" ] &&  [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] && type fgconsole >/dev/null 2>&1 && tt="$(fgconsole 2>/dev/null)" && [ -n "$tt" ] && [ "$tt" -eq 1 ] && exec startx
