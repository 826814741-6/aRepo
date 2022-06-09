#
#	$ sh run-examples.sh [graphics|interactive]
#
#		or
#
#	$ {,g}awk -f src/_helper.awk -f src/A.awk -f examples/A.awk
#	$ bash examples/A.bash
#	$ pforth_standalone -q examples/A.fth
#	$ LUA_PATH=src/?.lua lua examples/A.lua
#	$ LUA_PATH=src/?.luajit luajit examples/A.luajit
#	$ scheme --libdirs src --script examples/A.ss
#

checkDependency () {
	[ "$(command -v ${1})" = "" ] && return || printf "${1}"
}

isExist () {
	local P
	for P in "${@}"; do
		[ -e "${P}" ] || return 1
	done
	return 0
}

_cmd () {
	if [ "${2}" = "awk" ]; then
		isExist "src/${1}.${2}" "examples/${1}.${2}" || return
		${2} -f "src/_helper.awk" -f "src/${1}.${2}" -f "examples/${1}.${2}"
	elif [ "${2}" = "bash" ]; then
		isExist "examples/${1}.${2}" || return
		${2} "examples/${1}.${2}"
	elif [ "${2}" = "pforth_standalone" ]; then
		isExist "examples/${1}.fth" || return
		${2} -q "examples/${1}.fth"
	elif [ "${2}" = "lua" -o "${2}" = "luajit" ]; then
		isExist "examples/${1}.${2}" || return
		LUA_PATH="src/?.${2}" ${2} "examples/${1}.${2}"
	elif [ "${2}" = "scheme" ]; then
		isExist "examples/${1}.ss" || return
		${2} --libdirs "src" --script "examples/${1}.ss"
	fi
}

run () {
	local T C
	T=${1}
	shift
	for C in "${@}"; do
		printf "======== ${T} (${C})\n"
		_cmd "${T}" "${C}"
	done
	printf "\n"
}

#

[ "${0%%run-examples.sh}" = "" ] || cd ${0%%run-examples.sh}
[ -d "results" ] || mkdir results

AWK=$(checkDependency awk)
BASH=$(checkDependency bash)
FTH=$(checkDependency pforth_standalone)
LUA=$(checkDependency lua)
LUAJIT=$(checkDependency luajit)
CHEZ=$(checkDependency scheme)

#

if [ "$#" -eq "1" -a "${1}" = "graphics" ]; then
	run 3dgraph		$LUA
	run bifur		$LUA
	run binormalG		$LUA
	run ccurve		$LUA
	run circle		$LUA
	run dragoncurve		$LUA
	run dragoncurveR	$LUA
	run ellipse		$LUA
	run epsplot		$LUA
	run gasket		$LUA
	run grBMP		$LUA
	run hilbert		$LUA
	run julia		$LUA
	run koch		$LUA
	run line		$LUA
	run lissajouscurve	$LUA
	run lorenz		$LUA
	run sierpinski		$LUA
	run svgplot		$LUA
	run treecurve		$LUA
elif [ "$#" -eq "1" -a "${1}" = "interactive" ]; then
	run 105			$AWK $BASH $LUA
	run josephus		$LUA
	run water		$AWK $BASH $LUA
else
	run acker		$AWK $BASH $FTH $LUA $CHEZ
	run atan		$LUA
	run binormal		$LUA
	run change		$AWK $LUA
	run chisqdist		$AWK $LUA
	run ci			$LUA
	run combination		$AWK $LUA
	run crnd		$LUA $LUAJIT
	run cuberoot		$AWK $FTH $LUA $LUAJIT $CHEZ
	run dayweek		$AWK $LUA
	run e			$AWK $BASH $FTH $LUA $CHEZ
	run eulerian		$AWK $BASH $FTH $LUA
	run fdist		$LUA
	run fft			$LUA
	run fib			$AWK $FTH $LUA $CHEZ
	run gamma		$AWK $LUA
	run gcd			$AWK $BASH $LUA
	run horner		$AWK $LUA
	run hypot		$AWK $FTH $LUA $CHEZ
	run isbn		$LUA
	run isbn13		$LUA
	run komachi		$LUA
	run luhn		$LUA
	run machineepsilon	$LUA
	run mccarthy		$AWK $BASH $FTH $LUA $CHEZ
	run montecarlo		$LUA
	run moveblock		$AWK $LUA
	run multiply		$AWK $BASH $FTH $LUA $LUAJIT
	run normal		$AWK $LUA
	run pi			$AWK $FTH $LUA $CHEZ
	run power		$AWK $BASH $LUA $LUAJIT
	run rand		$FTH $LUA $LUAJIT
	run randperm		$LUA
	run si			$LUA
	run sqrt		$AWK $FTH $LUA $LUAJIT $CHEZ
	run stirling		$AWK $BASH $FTH $LUA
	run sum			$AWK $LUA
	run swap		$AWK $LUA
	run tarai		$AWK $FTH $LUA $CHEZ
	run tdist		$LUA
	run totient		$AWK $BASH $FTH $LUA
	run whrnd		$LUA
	run zeta		$LUA
fi
