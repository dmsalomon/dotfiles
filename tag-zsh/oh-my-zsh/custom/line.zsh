
# Many are from https://github.com/Parth/dotfiles


function edit_exec() {
	BUFFER="fc"
	zle accept-line
}
zle -N edit_exec
bindkey "^v" edit_exec


function add_sudo() {
	BUFFER="sudo $BUFFER"
	zle end-of-line
}
zle -N add_sudo
bindkey "^s" add_sudo

