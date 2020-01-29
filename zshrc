
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
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_PROMPT_ORDER=(
	time
	user
	promptpwd
	host
	git
	ruby
	golang
	docker
	venv
	pyenv
	exec_time
	battery
	vi_mode
	jobs
	char
)
SPACESHIP_PROMPTPWD_SHOW=true
SPACESHIP_DIR_SHOW=false
spaceship_promptpwd () {
	[[ $SPACESHIP_PROMPTPWD_SHOW == false ]] && return
	spaceship::exists prompt_pwd || return
	spaceship::section "$SPACESHIP_DIR_COLOR" "$SPACESHIP_DIR_PREFIX" "$(prompt_pwd)" " "
}

export PATH="$PATH:$HOME/.scripts"
