
prompt_pwd() {
	local realhome=~
	echo $PWD | sed -e "s|^$realhome|~|" -e 's-\([^/.]\)[^/]*/-\1/-g'
}

zinit light "spaceship-prompt/spaceship-prompt"
# SPACESHIP_PROMPT_ORDER=(
# 	battery user promptpwd host git
# 	venv terraform exec_time char
# )
# SPACESHIP_PROMPT_ADD_NEWLINE=false
# SPACESHIP_PROMPT_SEPARATE_LINE=false
# SPACESHIP_USER_SHOW=needed
# SPACESHIP_BATTERY_THRESHOLD=25
# SPACESHIP_BATTERY_SHOW=true
# [[ -e ~/.kube/config ]] && SPACESHIP_KUBECTL_SHOW=true
# spaceship_promptpwd () {
# 	spaceship::section \
# 		--color "$SPACESHIP_DIR_COLOR" \
# 		--prefix "$SPACESHIP_DIR_PREFIX" \
# 		--suffix " " \
# 		"$(prompt_pwd)"
# }
# spaceship_kubectl () {
# 	[[ $SPACESHIP_KUBECTL_SHOW == true ]] || return
# 	context="$(kubectl_current_context)"
# 	spaceship::section \
# 	  "$SPACESHIP_KUBECTL_COLOR" \
# 	  "$SPACESHIP_KUBECTL_PREFIX" \
# 	  "${SPACESHIP_KUBECTL_SYMBOL}${context##*cluster/}" \
# 	  "$SPACESHIP_KUBECTL_SUFFIX"
# }

SPACESHIP_YIELDX_ENV_SHOW=true
SPACESHIP_YIELDX_ENV_PREFIX=on
SPACESHIP_YIELDX_ENV_SUFFIX=" "
SPACESHIP_YIELDX_ENV_SYMBOL="🅇"
spaceship_yieldx_env () {
	[[ $SPACESHIP_YIELDX_ENV_SHOW == false ]] && return
	local env=${YIELDX_ENV}
	[[ -z $env ]] && return
	spaceship::section --color "$SPACESHIP_AWS_COLOR" \
		--prefix "$SPACESHIP_YIELDX_ENV_PREFIX" \
		--suffix "$SPACESHIP_YIELDX_ENV_SUFFIX" \
		--symbol "$SPACESHIP_YIELDX_ENV_SYMBOL" \
		"$env"
}

spaceship_kubectl () {
	[[ $SPACESHIP_KUBECTL_SHOW == false ]] && return
	local kubectl_context="$(spaceship_kubectl_context)"
	[[ -z $kubectl_context ]] && return
	local kubectl_context_section="$(spaceship::section::render $kubectl_context)"
	spaceship::section --color "$SPACESHIP_KUBECTL_COLOR" --prefix "$SPACESHIP_KUBECTL_PREFIX" --suffix "$SPACESHIP_KUBECTL_SUFFIX" --symbol "$SPACESHIP_KUBECTL_SYMBOL" "${kubectl_context_section}"
}
SPACESHIP_KUBECTL_SHOW=true

SPACESHIP_AZURE_SHOW=false
SPACESHIP_ASYNC_SYMBOL=''
