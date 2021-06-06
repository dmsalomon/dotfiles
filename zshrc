
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# history
HISTSIZE=1000000000000
HISTFILESIZE=$HISTSIZE

zinit ice wait lucid
zinit snippet ~/.zsh/delay.zsh
zinit snippet ~/.zsh/omz.zsh
zinit snippet ~/.zsh/spaceship.zsh

zinit wait lucid light-mode for \
	atinit'zicompinit; zicdreplay' \
		zdharma/fast-syntax-highlighting \
	atload'_zsh_autosuggest_start' \
		zsh-users/zsh-autosuggestions \
	blockf atpull'zinit creinstall -q .' \
		zsh-users/zsh-completions \
	agkozak/zsh-z \
	atclone"dircolors -b LS_COLORS > clrs.zsh" \
	atpull'%atclone' pick"clrs.zsh" nocompile'!' \
	atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”' \
		trapd00r/LS_COLORS \
	from"gh-r" as"program" mv"direnv* -> direnv" \
	atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
	pick"direnv" src="zhook.zsh" \
		direnv/direnv

