
[[ "$ZPROFRC" -ne 1 ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

set -o vi

source "$ZDOTDIR/antidote.zsh"

autoload -U promptinit; promptinit
prompt pure
# eval "$(starship init zsh)"
# eval $(oh-my-posh init zsh --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/spaceship.omp.json')

zsh-defer -c 'eval "$(fzf --zsh)"'

[[ "$ZPROFRC" -eq 1 ]] && zprof
[[ -v ZPROFRC ]] && unset ZPROFRC || true
