
export PATH="$HOME/.bin/local:$HOME/.bin:$HOME/.local/bin:$PATH"
fpath=(~/.zfunc/ $fpath)

setopt extendedglob
snippets=(aliases func var local line)
for f in $snippets; do
	zinit snippet ~/.zsh/$f.zsh
done
unset snippets

[ -n "$commands[pyenv]" ] && eval "$(pyenv init -)"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -d /usr/share/fzf ]] && {
	source /usr/share/fzf/completion.zsh
	source /usr/share/fzf/key-bindings.zsh
}
[[ -f ~/.cache/wal/colors.sh ]] && source ~/.cache/wal/colors.sh
export FZF_DEFAULT_OPTS=''
export NODE_VERSION_PREFIX=v
export NODE_VERSIONS=$HOME/.nvm/versions/node
dedupepath
