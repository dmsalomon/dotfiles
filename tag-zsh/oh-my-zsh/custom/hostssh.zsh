
function hostssh() {
	if [[ -n "$SSH_CLIENT" ]]; then
		echo "%m "
	fi
}
