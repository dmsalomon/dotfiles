
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

omzlib=(
	bzr clipboard compfix completion correction
	diagnostics directories functions git
	grep history key-bindings misc nvm
	prompt_info_functions spectrum termsupport
	theme-and-appearance
)
for f in $omzlib; do
	zplugin snippet "OMZ::lib/${f}.zsh"
done

zplugin ice wait lucid
zplugin light agkozak/zsh-z

zplugin light zsh-users/zsh-syntax-highlighting
zplugin light zsh-users/zsh-autosuggestions

omzplug=(
	colored-man-pages
	git
	systemd
)
for plug in $omzplug; do
	zplugin ice wait lucid
	zplugin snippet "OMZ::plugins/${plug}/${plug}.plugin.zsh"
done

for f in ~/.zsh/**/*; do
	[[ -d "$f" ]] || zplugin snippet "$f"
done
# source ~/.zsh/themes/dovi.zsh-theme
zplugin light "denysdovhan/spaceship-prompt"
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

exists pyenv && eval "$(pyenv init -)"
export PATH="$HOME/.bin:$PATH"
dedupepath
