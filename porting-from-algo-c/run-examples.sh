#
#  run-examples.sh
#
#  Please set the path of excutable, before you run this script.
#
#    e.g.
#    LUA=/path/to/lua or LUA=lua or
#    PY='micropython -X heapsize=2wM -X emit=native' (*)
#
#  *) Quick reference for the UNIX and Windows ports
#  https://github.com/micropython/micropython/blob/master/docs/unix/quickref.rst
#

AWK=
DC=
LUA=
LUAJIT=
PY=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $AWK)" = "" ] && error "AWK"
[ "$(command -v $DC)" = "" ] && error "DC"
[ "$(command -v $LUA)" = "" ] && error "LUA"
[ "$(command -v $LUAJIT)" = "" ] && error "LUAJIT"
[ "$(command -v $PY)" = "" ] && error "PY"

#

runAWK() {
	$AWK -f src/_helper.awk -f src/${1}.awk
}

runDC() {
	DC_LINE_LENGTH=0 $DC src/${1}.dc
}

runLUA() {
	LUA_PATH='src/?.lua' $LUA examples/${1}.lua
}

runLUAJIT() {
	LUA_PATH='src/?.luajit' $LUAJIT examples/${1}.luajit
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

run binormal LUA
run complex LUA
run dayweek AWK
run e AWK DC
run egyptianfraction LUA PY
run factorize LUA PY
run gcd AWK
run machineepsilon LUA PY
run moveblock AWK
run nthroot LUA
run pi AWK DC
run rand DC LUA LUAJIT
run sum AWK
run whrnd AWK
