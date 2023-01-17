#
#	run-examples-interactive.sh
#
#	Please set the path of excutable, before you run this script.
#
#	e.g.
#	LUA=/path/to/lua or LUA=lua
#

AWK=
BASH=
LUA=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $AWK)" = "" ] && error "AWK"
[ "$(command -v $BASH)" = "" ] && error "BASH"
[ "$(command -v $LUA)" = "" ] && error "LUA"

#

runAWK() {
	$AWK -f src/_helper.awk -f src/${1}.awk -f examples/${1}.awk
}

runBASH() {
	$BASH examples/${1}.bash
}

runLUA() {
	LUA_PATH='src/?.lua' $LUA examples/${1}.lua
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
run josephus LUA
run water AWK BASH LUA
