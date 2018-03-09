
# From https://github.com/Parth/dotfiles

function add_sudo() {
	[[ -z "$BUFFER" ]] && zle up-history
	BUFFER="sudo $BUFFER"
	zle end-of-line
}
zle -N add_sudo
bindkey "^s" add_sudo

