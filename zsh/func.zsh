
rmdthis() {
	cd .. && rmdir $OLDPWD || cd $OLDPWD
}

cl() {
	cd "$1" && ls
}

ml() {
	last="$@[-1]"
	mv "$@" && [ -d $last ] && cl $last
}

mkcd() {
	mkdir -p "$1" && cd "$1"
}

open() {
	case "$OSTYPE" in
	darwin*)
		command open "$@" &>/dev/null;;
	*)
		(command xdg-open "$@" &>/dev/null &);;
	esac
}

fv() {
	fzf --prompt="edit> " | xargs -ro "$EDITOR"
}

gv() {
	local file
	local line
	rg -S --line-number --no-heading $@ | fzf -0 -1 | awk -F: '{print $1, $2}' | read -r file line
	[[ -n $file ]] && vim $file +$line
}

exists() {
	command -v $1 &>/dev/null
}

dedupepath() {
	PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
}

# for f in $HOME/.scripts/*(.x:t); do
# 	autoload -Uz "$f"
# done
