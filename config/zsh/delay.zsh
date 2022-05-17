
export PATH="$HOME/.bin/local:$HOME/.local/bin/shellscripts:$HOME/.local/bin:$PATH"
fpath=(~/.zfunc $fpath)

setopt extendedglob
snippets=(aliases func var local line)
for f in $snippets; do
	zinit snippet ~/.config/zsh/$f.zsh
done
unset snippets

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -d /usr/share/fzf ]] && {
	source /usr/share/fzf/completion.zsh
	source /usr/share/fzf/key-bindings.zsh
}
[[ -f ~/.cache/wal/colors.sh ]] && source ~/.cache/wal/colors.sh
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

export NVM_DIR="$HOME/.local/share/nvm"
export NODE_VERSION_PREFIX=v
export NODE_VERSIONS="$NVM_DIR/versions/node"

dedupepath
