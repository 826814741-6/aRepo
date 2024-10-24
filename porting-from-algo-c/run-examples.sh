#
#	run-examples.sh
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
DC=
HAXE=
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
[ "$(command -v $HAXE)" = "" ] && error "HAXE"
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

runHAXE() {
	$HAXE --interp -p examples --main Demo -D ${1}
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

run acker AWK LUA
run atan LUA
run binormal LUA
run change AWK LUA
run chisqdist AWK LUA
run ci LUA
run combination AWK LUA
run complex LUA
run crnd LUA LUAJIT
run cuberoot AWK LUA LUAJIT
run dayweek AWK LUA
run e AWK DC HAXE LUA
run eulerian AWK LUA
run factorize LUA PY
run fdist LUA
run fft LUA
run fib AWK LUA
run gamma AWK LUA
run gcd AWK LUA
run horner AWK LUA
run hypot AWK LUA
run isbn LUA
run isbn13 LUA
run komachi LUA
run luhn LUA
run machineepsilon HAXE LUA PY
run mccarthy AWK LUA
run montecarlo LUA
run moveblock AWK LUA
run multiply AWK LUA LUAJIT
run normal AWK LUA
run pi AWK DC HAXE LUA
run power AWK LUA LUAJIT
run rand DC LUA LUAJIT
run randperm LUA
run si LUA
run sqrt AWK LUA LUAJIT
run stirling AWK LUA
run sum AWK LUA
run swap AWK LUA
run tarai AWK LUA
run tdist LUA
run totient AWK LUA
run whrnd LUA
run zeta LUA
