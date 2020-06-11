#
#	from src/multiply.c
#
#	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
#

mulA () {
	local a b r
	a=${1}; b=${2}; r=0
	while [ "${a}" -ne "0" ]; do
		[ "$((${a} % 2))" -eq "1" ] && r=$((${r} + ${b}))
		b=$((${b} * 2)); a=$((${a} / 2))
	done
	printf $r
}

mulB () {
	local a b r
	a=${1}; b=${2}; r=0
	while [ "${a}" -ne "0" ]; do
		[ "$((${a} & 1))" -eq "1" ] && r=$((${r} + ${b}))
		b=$((${b} << 1)); a=$((${a} >> 1))
	done
	printf $r
}

_iter () {
	local t
	if [ "${1}" -ne "0" ]; then
		[ "$((${1} & 1))" -eq "1" ] && t=$((${3} + ${2})) || t=${3}
		_iter $((${1} >> 1)) $((${2} << 1)) $t
	else
		printf ${3}
	fi
}

mulC () {
	printf $(_iter ${1} ${2} 0)
}
