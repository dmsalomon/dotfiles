
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

omzlib=(
	bzr clipboard compfix completion correction
	diagnostics directories functions git
	grep history key-bindings misc nvm
	prompt_info_functions spectrum termsupport
	theme-and-appearance
)
for f in $omzlib; do
	zinit snippet "OMZ::lib/${f}.zsh"
done

zinit ice wait lucid
zinit light agkozak/zsh-z

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

omzplug=(
	colored-man-pages
	git
	systemd
)
for plug in $omzplug; do
	zinit ice wait lucid
	zinit snippet "OMZ::plugins/${plug}/${plug}.plugin.zsh"
done

for f in ~/.zsh/**/*; do
	[[ -d "$f" ]] || zinit snippet "$f"
done
# source ~/.zsh/themes/dovi.zsh-theme
zinit light "denysdovhan/spaceship-prompt"
SPACESHIP_PROMPT_ORDER=(
	user promptpwd host git
	venv exec_time char
)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_USER_SHOW=needed
SPACESHIP_BATTERY_THRESHOLD=15
spaceship_promptpwd () {
	spaceship::section "$SPACESHIP_DIR_COLOR" "$SPACESHIP_DIR_PREFIX" "$(prompt_pwd)" " "
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -d /usr/share/fzf ] && {
	source /usr/share/fzf/completion.zsh
	source /usr/share/fzf/key-bindings.zsh
}
export FZF_DEFAULT_COMMAND="find . -type f -or -type l -printf '%P\n'"

exists pyenv && eval "$(pyenv init -)"
export PATH="$HOME/.bin:$PATH"
dedupepath

