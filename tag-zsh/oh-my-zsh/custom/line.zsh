
# From https://github.com/Parth/dotfiles

function add_sudo() {
	[[ -z "$BUFFER" ]] && zle up-history
	BUFFER="sudo $BUFFER"
	zle end-of-line
}
zle -N add_sudo
bindkey "^s" add_sudo

function change_prog() {
	BUFFER=" ${BUFFER#* }"
	zle beginning-of-line
}
zle -N change_prog
bindkey "^v" change_prog
