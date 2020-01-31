
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

spill() {
	if [ $# -eq 0 ]
	then
		cd .. && spill $OLDPWD
	else
		for dir
		do
			cd $dir && mv * $OLDPWD && cd $OLDPWD && rmdir $dir
		done
	fi
}

open() {
	case "$OSTYPE" in
	darwin*)
		command open "$@" &>/dev/null;;
	*)
		(open_command "$@" &>/dev/null &);;
	esac
}

fv() {
	f=$(find $1 -type f -or -type l 2>/dev/null | fzf --prompt="vim> ")
	[[ -n $f ]] && vim $f
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
