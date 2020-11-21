export GOPATH=/home/dms/prog/go
export PATH="$PATH:$GOPATH/bin"

mmmcd() {
	cd $(mmm cd "$@")
}
