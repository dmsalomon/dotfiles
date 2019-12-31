#
# ~/.zlogin
#

[ -z "$DISPLAY" ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] && type fgconsole &>/dev/null && [ "$(fgconsole)" -eq 1 ] && type startx &>/dev/null && exec startx >/dev/null || return 0
