
# inspired by https://github.com/Parth/dotfiles

function toggle_sudo() {
	[[ -z "$BUFFER" ]] && zle up-history
	if echo "$BUFFER" | grep -qE '^[[:space:]]*sudo'
	then
		BUFFER=$(echo "$BUFFER" | sed 's/^[[:space:]]*sudo[[:space:]]*//')
	else
		BUFFER="sudo $(echo "$BUFFER" | sed 's/^[[:space:]]*//')"
	fi
	BUFFER=$(echo "$BUFFER" | sed -e 's/[[:space:]]*$/ /')
	zle end-of-line
}
zle -N toggle_sudo
bindkey "^s" toggle_sudo

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^v" edit-command-line
