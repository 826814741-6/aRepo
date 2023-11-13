#
#	run-examples-graphics.sh
#
#	Please set the path of excutable, before you run this script.
#
#	e.g.
#	LUA=/path/to/lua or LUA=lua or
#	PY='micropython -X heapsize=2wM -X emit=native' (*)
#
#	*) Quick reference for the UNIX and Windows ports
#	https://github.com/micropython/micropython/blob/master/docs/unix/quickref.rst
#

AWK=
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
[ "$(command -v $HAXE)" = "" ] && error "HAXE"
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

runHAXE() {
	$HAXE --interp -p examples --main DemoGraphics -D ${1}
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

run 3dgraph LUA
run bifur LUA
run binormalG LUA
run ccurve AWK HAXE LUA
run circle LUA LUAJIT
run dragoncurve LUA
run dragoncurveR LUA
run ellipse LUA LUAJIT
run gasket LUA
run grBMP LUA LUAJIT PY
run hilbert LUA
run julia LUA
run koch LUA
run line LUA LUAJIT
run lissajouscurve AWK HAXE LUA LUAJIT
run lorenz LUA
run sierpinski LUA
run svgplot AWK HAXE LUA LUAJIT PY
run treecurve AWK HAXE LUA
