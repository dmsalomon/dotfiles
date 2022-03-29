
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
	[[ -n $file ]] && $EDITOR $file +$line
}

dedupepath() {
	PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
}

exists() {
	[ -n "$commands[$1]" ]
}

kubectl_current_context() {
	[[ -e ~/.kube/config ]] && yq e '.current-context' ~/.kube/config
}

znu() {
	for f in ~/.zsh/**/*.zsh; do zinit update $f; done &
} > /dev/null


fzf-git-branch () {
	git rev-parse HEAD > /dev/null 2>&1 || return

	git branch --color=always --sort=-committerdate |
		grep -v HEAD |
		fzf --height 50% --ansi --no-multi --preview-window right:65% \
		    --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

jump-to-git-root() {
  local _root_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [[ $? -gt 0 ]]; then
    >&2 echo 'Not a Git repo!'
    exit 1
  fi
  local _pwd=$(pwd)
  if [[ $_pwd = $_root_dir ]]; then
    # Handle submodules:
    # If parent dir is also managed under Git then we are in a submodule.
    # If so, cd to nearest Git parent project.
    _root_dir="$(git -C $(dirname $_pwd) rev-parse --show-toplevel 2>/dev/null)"
    if [[ $? -gt 0 ]]; then
      echo "Already at Git repo root."
      return 0
    fi
  fi
  # Make `cd -` work.
  OLDPWD=$_pwd
  echo "Git repo root: $_root_dir"
  cd $_root_dir
}
