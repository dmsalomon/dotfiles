
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# history
HISTSIZE=1000000000000
HISTFILESIZE=$HISTSIZE

zinit snippet ~/.zsh/omz.zsh
zinit ice wait lucid
zinit snippet ~/.zsh/delay.zsh
zinit snippet ~/.zsh/spaceship.zsh

zinit wait lucid for light-mode agkozak/zsh-z

zinit wait lucid atload"zicompinit" blockf for \
	light-mode zsh-users/zsh-completions

zinit wait lucid atload'_zsh_autosuggest_start' for light-mode zsh-users/zsh-autosuggestions
zinit wait lucid for light-mode zsh-users/zsh-syntax-highlighting

