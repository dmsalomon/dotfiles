
function hostssh() {
	if [[ -n "$SSH_CLIENT" ]]; then
		echo "%m "
	fi
}

function prompt_pwd() {
	local realhome=~
	echo $PWD | sed -e "s|^$realhome|~|" -e 's-\([^/.]\)[^/]*/-\1/-g'
}
