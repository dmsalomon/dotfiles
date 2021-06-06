
setopt extendedglob
snippets=(aliases func var local line)
for f in $snippets; do
	zinit snippet ~/.zsh/$f.zsh
done
unset snippets

exists pyenv && eval "$(pyenv init -)"
export PATH="$PATH:$HOME/.bin:$HOME/.bin/local:$HOME/.local/bin"
fpath=(~/.zfunc/ $fpath)

[[ -f ~/.fzf.zsh ]] && zinit snippet ~/.fzf.zsh
[[ -d /usr/share/fzf ]] && {
	zinit snippet /usr/share/fzf/completion.zsh
	zinit snippet /usr/share/fzf/key-bindings.zsh
}
[[ -f ~/.cache/wal/colors.sh ]] && zinit snippet ~/.cache/wal/colors.sh
export FZF_DEFAULT_OPTS=''

[[ -f ~/.clrs.zsh ]] || dircolors -b > ~/.clrs.zsh
zinit snippet ~/.clrs.zsh
