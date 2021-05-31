
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

omzlib=(
	clipboard completion correction directories
	functions git grep history key-bindings misc
	nvm prompt_info_functions spectrum termsupport
	theme-and-appearance
)
for f in $omzlib; do
	zinit snippet "OMZ::lib/${f}.zsh"
done

zinit wait lucid for light-mode agkozak/zsh-z

omzplug=(colored-man-pages git systemd)
for plug in $omzplug; do
	zinit ice wait lucid
	zinit snippet "OMZP::${plug}"
done

setopt extendedglob
for f in ~/.zsh/**/(^local).zsh; do
	zinit snippet "$f"
done

zinit light "denysdovhan/spaceship-prompt"
SPACESHIP_PROMPT_ORDER=(
	vi_mode user promptpwd host git
	venv terraform exec_time char
)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_USER_SHOW=needed
SPACESHIP_BATTERY_THRESHOLD=15
spaceship_promptpwd () {
	spaceship::section "$SPACESHIP_DIR_COLOR" "$SPACESHIP_DIR_PREFIX" "$(prompt_pwd)" " "
}
spaceship_vi_mode_enable

[[ -f ~/.clrs.zsh ]] || dircolors -b > ~/.clrs.zsh
zinit snippet ~/.clrs.zsh

zinit wait lucid atload"zicompinit" blockf for \
	light-mode zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -d /usr/share/fzf ]] && {
	source /usr/share/fzf/completion.zsh
	source /usr/share/fzf/key-bindings.zsh
}
[[ -f ~/.cache/wal/colors.sh ]] && source ~/.cache/wal/colors.sh
export FZF_DEFAULT_OPTS=''

zinit wait lucid atload"zicompinit" blockf for \
	light-mode zsh-users/zsh-completions

zinit snippet ~/.zsh/local.zsh
exists pyenv && eval "$(pyenv init -)"
export PATH="$PATH:$HOME/.bin:$HOME/.bin/local:$HOME/.local/bin"
fpath=(~/.zfunc/ $fpath)

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
