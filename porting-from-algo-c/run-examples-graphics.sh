#
#	run-examples-graphics.sh
#
#	Please set the path of excutable, before you run this script.
#
#	e.g.
#	LUA=/path/to/lua or LUA=lua
#

LUA=

#

error() {
	printf "Please set \$%s in this script.\n" "$1"
	exit 1
}

[ "$(command -v $LUA)" = "" ] && error "LUA"

#

run() {
	LUA_PATH='src/?.lua' $LUA examples/${1}.lua
}

run 3dgraph
run bifur
run binormalG
run ccurve
run circle
run dragoncurve
run dragoncurveR
run ellipse
run gasket
run grBMP
run hilbert
run julia
run koch
run line
run lissajouscurve
run lorenz
run sierpinski
run svgplot
run treecurve
