#
# ~/.bash_profile
#

[ -z "$DISPLAY" ] &&  [ -z "$SSH_TTY" ] && [ "$(fgconsole)" -eq 1 ] && exec startx  || [ -f ~/.bashrc ] && . ~/.bashrc
