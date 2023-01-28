#
#	run-examples.sh
#
#	Please set the path of excutable, before you run this script.
#
#	e.g.
#	LUA=/path/to/lua or LUA=lua
#

AWK=
BASH=
FTH=
LUA=
LUAJIT=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $AWK)" = "" ] && error "AWK"
[ "$(command -v $BASH)" = "" ] && error "BASH"
[ "$(command -v $FTH)" = "" ] && error "FTH"
[ "$(command -v $LUA)" = "" ] && error "LUA"
[ "$(command -v $LUAJIT)" = "" ] && error "LUAJIT"

#

runAWK() {
	$AWK -f src/_helper.awk -f src/${1}.awk
}

runBASH() {
	$BASH examples/${1}.bash
}

runFTH() {
	$FTH -q examples/${1}.fth
}

runLUA() {
	LUA_PATH='src/?.lua' $LUA examples/${1}.lua
}

runLUAJIT() {
	LUA_PATH='src/?.luajit' $LUAJIT examples/${1}.luajit
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

run acker AWK BASH FTH LUA
run atan LUA
run binormal LUA
run change AWK LUA
run chisqdist AWK LUA
run ci LUA
run combination AWK LUA
run crnd LUA LUAJIT
run cuberoot AWK FTH LUA LUAJIT
run dayweek AWK LUA
run e AWK BASH FTH LUA
run eulerian AWK BASH FTH LUA
run fdist LUA
run fft LUA
run fib AWK FTH LUA
run gamma AWK LUA
run gcd AWK BASH LUA
run horner AWK LUA
run hypot AWK FTH LUA
run isbn LUA
run isbn13 LUA
run komachi LUA
run luhn LUA
run machineepsilon LUA
run mccarthy AWK BASH FTH LUA
run montecarlo LUA
run moveblock AWK LUA
run multiply AWK BASH FTH LUA LUAJIT
run normal AWK LUA
run pi AWK FTH LUA
run power AWK BASH LUA LUAJIT
run rand FTH LUA LUAJIT
run randperm LUA
run si LUA
run sqrt AWK FTH LUA LUAJIT
run stirling AWK BASH FTH LUA
run sum AWK LUA
run swap AWK LUA
run tarai AWK FTH LUA
run tdist LUA
run totient AWK BASH FTH LUA
run whrnd LUA
run zeta LUA
