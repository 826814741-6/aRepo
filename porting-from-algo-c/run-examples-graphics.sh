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

LUA=
PY=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $LUA)" = "" ] && error "LUA"
[ "$(command -v $PY)" = "" ] && error "PY"

#

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

run 3dgraph LUA
run bifur LUA
run binormalG LUA
run ccurve LUA
run circle LUA
run dragoncurve LUA
run dragoncurveR LUA
run ellipse LUA
run gasket LUA
run grBMP LUA PY
run hilbert LUA
run julia LUA
run koch LUA
run line LUA
run lissajouscurve LUA
run lorenz LUA
run sierpinski LUA
run svgplot LUA PY
run treecurve LUA
