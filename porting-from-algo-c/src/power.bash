#
#	from src/power.c
#
#	double ipower(double, int)	to	iPow
#	iPow				to	iPowR
#

_abs() {
	local r=${1}
	[ "${r}" -lt "0" ] && r=$((-1 * $r))
	printf $r
}

_helperFormat() {
	local FMT=$(printf "0.%%0%dd" ${3})
	local r=${1}
	[ "${2}" -lt "0" ] && r=$(printf $FMT $(($((10 ** ${3})) / $r)))
	printf $r
}

#iPowA() {
#	local x r t
#	x=${1}; r=1; t=$(_abs ${2})
#	while [ "${t}" -ne "0" ]; do
#		[ "$(($t % 2))" -eq 1 ] && r=$(($r * $x))
#		x=$(($x * $x)); t=$(($t / 2))
#	done
#	printf $(_helperFormat $r ${2} 16)
#}

iPow() {
	local x r t
	x=${1}; r=1; t=$(_abs ${2})
	while [ "${t}" -ne "0" ]; do
		[ "$(($t & 1))" -eq 1 ] && r=$(($r * $x))
		x=$(($x * $x)); t=$(($t >> 1))
	done
	printf $(_helperFormat $r ${2} 16)
}

_helperAssign() {
	local r=${1}
	[ "$((${2} & 1))" -eq 1 ] && r=$((${r} * ${3}))
	printf $r
}

_rec() {
	if [ "${4}" -ne "0" ]; then
		_rec $((${1} * ${1})) ${2} $(_helperAssign ${3} ${4} ${1}) $((${4} >> 1))
	else
		printf $(_helperFormat ${3} ${2} 16)
	fi
}

iPowR() {
	printf $(_rec ${1} ${2} 1 $(_abs ${2}))
}
