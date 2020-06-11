#
#	from src/e.c
#
#	long double ee(void)	to	e
#

_e () {
	local r a n prev
	r=0; a=${1}; n=1

	prev=$r; r=$(($r + $a)); a=$(($a / $n)); n=$(($n + 1))
	while [ "$r" -ne "$prev" ]; do
		prev=$r; r=$(($r + $a)); a=$(($a / $n)); n=$(($n + 1))
	done

	printf $r
}

e () {
	local t=$(_e ${1})
	printf "%d.%d" $(($t / ${1})) $(($t - $(($t / ${1})) * ${1}))
}
