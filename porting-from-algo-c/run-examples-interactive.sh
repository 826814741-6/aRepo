#
#	run-examples-interactive.sh
#
#	Please set the path of excutable, before you run this script.
#
#	e.g.
#	LUA=/path/to/lua or LUA=lua
#	PY='micropython -X heapsize=2wM -X emit=native' (*)
#
#	*) Quick reference for the UNIX and Windows ports
#	https://github.com/micropython/micropython/blob/master/docs/unix/quickref.rst
#

AWK=
BASH=
HAXE=
LUA=
PY=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $AWK)" = "" ] && error "AWK"
[ "$(command -v $BASH)" = "" ] && error "BASH"
[ "$(command -v $HAXE)" = "" ] && error "HAXE"
[ "$(command -v $LUA)" = "" ] && error "LUA"
[ "$(command -v $PY)" = "" ] && error "PY"

#

runAWK() {
	$AWK -f src/_helper.awk -f src/${1}.awk
}

runBASH() {
	$BASH examples/${1}.bash
}

runHAXE() {
	$HAXE --interp -p examples --main Demo -D ${1}
}

runLUA() {
	LUA_PATH='src/?.lua' $LUA examples/${1}.lua
}

runPY() {
	MICROPYPATH='src' PYTHONPATH='src' $PY src/${1}.py
}

#

run() {
	local t=$1
	shift
	for cmd in "$@"; do
		printf "======== $t ($cmd)\n"
		run${cmd} $t
	done
}

run 105 AWK BASH LUA
run egyptianfraction HAXE LUA PY
run josephus LUA
run water AWK BASH LUA
