
# inspired by https://github.com/Parth/dotfiles

function toggle_sudo() {
	[[ -z "$BUFFER" ]] && zle up-history
	if [[ "$BUFFER" =~ "^\s*sudo" ]]
	then
		BUFFER=$(echo "$BUFFER" | sed 's/^\s*sudo\s*//')
	else
		BUFFER="sudo $(echo "$BUFFER" | sed 's/^\s*//')"
	fi
	BUFFER=$(echo "$BUFFER" | sed -e 's/\s*$/ /')
	zle end-of-line
}
zle -N toggle_sudo
bindkey "^s" toggle_sudo

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^v" edit-command-line
