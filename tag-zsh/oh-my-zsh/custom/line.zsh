
# inspired by https://github.com/Parth/dotfiles

function add_sudo() {
	[[ -z "$BUFFER" ]] && zle up-history
	if [[ "$BUFFER" =~ "^\s*sudo" ]]
	then
		BUFFER=$(echo "$BUFFER" | sed 's/^\s*sudo\s*//')
	else
		BUFFER="sudo $(echo "$BUFFER" | sed "s/^\s*//")"
	fi
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
