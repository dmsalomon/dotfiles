
fpath=( "$HOME/.scripts" "${fpath[@]}" )

for f in $HOME/.scripts/*(.x:t); do
	autoload -Uz "$f"
done
