#
#  run-examples.sh
#
#  Please set the path of excutable, before you run this script.
#
#    AWK=/path/to/awk or LUA=lua or ...
#

AWK=
DC=
LUA=
LUAJIT=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $AWK)" = "" ] && error "AWK"
[ "$(command -v $DC)" = "" ] && error "DC"
[ "$(command -v $LUA)" = "" ] && error "LUA"
[ "$(command -v $LUAJIT)" = "" ] && error "LUAJIT"

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
run dayweek AWK
run e AWK DC
run egyptianfraction LUA
run factorize LUA
run gcd AWK
run machineepsilon LUA
run moveblock AWK
run nthroot LUA
run pi AWK DC
run rand DC LUA LUAJIT
run sum AWK
run whrnd AWK
