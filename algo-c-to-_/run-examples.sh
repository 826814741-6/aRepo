#
#	$ sh run-examples.sh [graphics|interactive]
#
#		or
#
#	$ {,g}awk -f src/_helper.awk -f src/A.{,g}awk -f examples/A.{,g}awk
#	$ bash examples/A.bash
#	$ pforth_standalone -q examples/A.fth
#	$ LUA_PATH=src/?.lua lua examples/A.lua
#	$ LUA_PATH=src/?.luajit luajit examples/A.luajit
#	$ MICROPYPATH=src micropython examples/A_.py
#	($ PYTHONPATH=src python3 examples/A_.py)
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
	if [ "${2}" = "awk" -o "${2}" = "gawk" ]; then
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
	elif [ "${2}" = "micropython" ]; then
		isExist "examples/${1}_.py" || return
		MICROPYPATH="src" ${2} "examples/${1}_.py"
	elif [ "${2}" = "python3" ]; then
		isExist "examples/${1}_.py" || return
		PYTHONPATH="src" ${2} "examples/${1}_.py"
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
GAWK=$(checkDependency gawk)
BASH=$(checkDependency bash)
FTH=$(checkDependency pforth_standalone)
LUA=$(checkDependency lua)
LUAJIT=$(checkDependency luajit)
PY=$(checkDependency micropython)
[ "${PY}" = "" ] && PY=$(checkDependency python3)
CHEZ=$(checkDependency scheme)

#

if [ "$#" -eq "1" -a "${1}" = "graphics" ]; then
	run 3dgraph		$LUA $PY
	run bifur		$LUA
	run binormalG		$LUA
	run ccurve		$LUA $PY
	run circle		$LUA
	run dragoncurve		$LUA $PY
	run dragoncurveR	$LUA $PY
	run ellipse		$LUA
	run epsplot		$LUA $PY
	run gasket		$LUA
	run grBMP		$LUA
	run hilbert		$LUA $PY
	run julia		$LUA
	run koch		$LUA $PY
	run line		$LUA
	run lissajouscurve	$LUA $PY
	run lorenz		$LUA $PY
	run sierpinski		$LUA $PY
	run svgplot		$LUA $PY
	run treecurve		$LUA $PY
elif [ "$#" -eq "1" -a "${1}" = "interactive" ]; then
	run 105			$AWK $BASH $LUA $PY
	run egyptianfraction	$PY
	run josephus		$LUA $PY
	run water		$AWK $BASH $LUA $PY
else
	run acker		$AWK $BASH $FTH $LUA $PY $CHEZ
	run atan		$LUA
	run binormal		$LUA
	run change		$AWK $LUA $PY
	run chisqdist		$AWK $LUA
	run ci			$LUA
	run combination		$AWK $LUA
	run crnd		$LUA $LUAJIT
	run cuberoot		$AWK $GAWK $FTH $LUA $LUAJIT $PY $CHEZ
	run dayweek		$AWK $LUA $PY
	run e			$AWK $BASH $FTH $LUA $PY $CHEZ
	run eulerian		$AWK $BASH $FTH $LUA $PY
	run factorize		$PY
	run fdist		$LUA
	run fft			$LUA
	run fib			$AWK $FTH $LUA $PY $CHEZ
	run gamma		$AWK $LUA
	run gcd			$AWK $BASH $LUA $PY
	run horner		$AWK $LUA $PY
	run hypot		$AWK $FTH $LUA $PY $CHEZ
	run isbn		$LUA $PY
	run isbn13		$LUA $PY
	run komachi		$LUA
	run luhn		$LUA $PY
	run machineepsilon	$LUA
	run mccarthy		$AWK $BASH $FTH $LUA $PY $CHEZ
	run montecarlo		$LUA
	run moveblock		$AWK $LUA $PY
	run multiply		$AWK $GAWK $BASH $FTH $LUA $LUAJIT $PY
	run normal		$AWK $LUA
	run pi			$AWK $FTH $LUA $PY $CHEZ
	run power		$AWK $GAWK $BASH $LUA $LUAJIT $PY
	run primes		$PY
	run rand		$FTH $LUA $LUAJIT $PY
	run randperm		$LUA
	run si			$LUA
	run sqrt		$AWK $GAWK $FTH $LUA $LUAJIT $PY $CHEZ
	run stirling		$AWK $BASH $FTH $LUA $PY
	run sum			$AWK $LUA $PY
	run swap		$AWK $GAWK $LUA $PY
	run tarai		$AWK $FTH $LUA $PY $CHEZ
	run tdist		$LUA
	run totient		$AWK $BASH $FTH $LUA $PY
	run whrnd		$LUA $PY
	run zeta		$LUA $PY
fi
