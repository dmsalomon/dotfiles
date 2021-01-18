#
# ~/.zlogin
#

[ -z "$DISPLAY" ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] && type fgconsole &>/dev/null && tt="$(fgconsole 2>/dev/null)" && [ -n "$tt" ] && [ "$tt" -eq 1 ] && [ ! -e .nox ] && type startx &>/dev/null && exec startx >/dev/null || return 0
