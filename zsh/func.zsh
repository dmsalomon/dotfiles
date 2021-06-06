
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

dedupepath() {
	PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
}

exists() {
	command -v $1 &>/dev/null
}

kubectl_current_context() {
	[[ -e ~/.kube/config ]] && yq e '.current-context' ~/.kube/config
}

znu() {
	for f in ~/.zsh/**/*.zsh; do zinit update $f; done &
} > /dev/null

