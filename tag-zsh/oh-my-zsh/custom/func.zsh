
fpath+=~/.scripts
fpath+=~/.zfunc

for f in $HOME/.scripts/*(.x:t); do
	autoload -Uz "$f"
done
