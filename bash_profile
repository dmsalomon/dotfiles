#
# ~/.bash_profile
#

export PATH="$HOME/.cargo/bin:$PATH"
[ -z "$DISPLAY" ] &&  [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] && type fgconsole >/dev/null 2>&1 && tt="$(fgconsole 2>/dev/null)" && [ -n "$tt" ] && [ "$tt" -eq 1 ] && exec startx  || [ -f ~/.bashrc ] && . ~/.bashrc
