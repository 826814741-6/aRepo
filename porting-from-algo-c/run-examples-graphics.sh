#
#  run-examples-graphics.sh
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
LUA=
LUAJIT=
PY=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $AWK)" = "" ] && error "AWK"
[ "$(command -v $LUA)" = "" ] && error "LUA"
[ "$(command -v $LUAJIT)" = "" ] && error "LUAJIT"
[ "$(command -v $PY)" = "" ] && error "PY"

#

runAWK() {
	local SVGLIB_PREFIX=svgplot
	local HELPER="-f src/_helper.awk"

	if [ "${1}" != "${SVGLIB_PREFIX}" ]; then
		HELPER="${HELPER} -f src/${SVGLIB_PREFIX}.awk"
	fi

	$AWK $HELPER -f src/${1}.awk -f examples/${1}.awk
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

run bifur LUA
run binormalG LUA
run ccurve AWK PY
run circle LUA LUAJIT
run dragoncurve AWK
run ellipse LUA LUAJIT
run gasket LUA
run grBMP LUA LUAJIT PY
run hilbert AWK
run koch AWK
run line LUA LUAJIT
run lissajouscurve AWK PY
run lorenz AWK
run sierpinski AWK
run svgplot AWK LUA LUAJIT PY
run treecurve AWK PY
