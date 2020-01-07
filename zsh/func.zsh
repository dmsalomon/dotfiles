
function rmdthis() {
	cd .. && rmdir $OLDPWD || cd $OLDPWD
}

function cl() {
	cd "$1" && ls
}

function ml() {
	last="$@[-1]"
	mv "$@" && [ -d $last ] && cl $last
}

function mkcd() {
	mkdir -p "$1" && cd "$1"
}

function spill() {
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

function open() {
	case "$OSTYPE" in
	darwin*)
		command open "$@" &>/dev/null;;
	*)
		(open_command "$@" &>/dev/null &);;
	esac
}

function fv() {
	f=$(find $1 -type f -or -type l 2>/dev/null | fzf --prompt="vim> ")
	[[ -n $f ]] && vim $f
}

# for f in $HOME/.scripts/*(.x:t); do
# 	autoload -Uz "$f"
# done
