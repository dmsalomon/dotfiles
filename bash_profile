#
# ~/.bash_profile
#

export PATH="$HOME/.cargo/bin:$PATH"
[ -z "$DISPLAY" ] &&  [ -z "$SSH_TTY" ] && [ "$(fgconsole)" -eq 1 ] && exec startx  || [ -f ~/.bashrc ] && . ~/.bashrc
