
prompt_pwd() {
	local realhome=~
	echo $PWD | sed -e "s|^$realhome|~|" -e 's-\([^/.]\)[^/]*/-\1/-g'
}

zinit light "denysdovhan/spaceship-prompt"
SPACESHIP_PROMPT_ORDER=(
	battery vi_mode user promptpwd host git
	venv terraform exec_time char
)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_USER_SHOW=needed
SPACESHIP_BATTERY_THRESHOLD=25
SPACESHIP_BATTERY_SHOW=true
[[ -e ~/.kube/config ]] && SPACESHIP_KUBECTL_SHOW=true
spaceship_promptpwd () {
	spaceship::section "$SPACESHIP_DIR_COLOR" "$SPACESHIP_DIR_PREFIX" "$(prompt_pwd)" " "
}
spaceship_kubectl () {
	[[ $SPACESHIP_KUBECTL_SHOW == true ]] || return
	context="$(kubectl_current_context)"
	spaceship::section \
	  "$SPACESHIP_KUBECTL_COLOR" \
	  "$SPACESHIP_KUBECTL_PREFIX" \
	  "${SPACESHIP_KUBECTL_SYMBOL}${context##*cluster/}" \
	  "$SPACESHIP_KUBECTL_SUFFIX"
}
spaceship_vi_mode_enable
