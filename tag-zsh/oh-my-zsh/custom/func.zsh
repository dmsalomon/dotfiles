
fpath+=~/.scripts
fpath+=~/.zfunc

function rmdthis() {
	cd ..
	rmdir $OLDPWD || cd $OLDPWD
}

function cl() {
	cd "$1" && ls
}

function ml() {
	last="$@[-1]"
	mv "$@" && [ -d $last ] && cd $last && ls
}

function mkcd() {
	mkdir -p "$1" && cd "$1"
}

function spill() {
	if [ $# -eq 0 ]
	then
		mv * .. && rmdthis
	else
		for dir
		do
			d="$(pwd)"
			cd $dir && mv * $OLDPWD && rmdthis
			cd "$d"
		done
	fi
}

# for f in $HOME/.scripts/*(.x:t); do
# 	autoload -Uz "$f"
# done
