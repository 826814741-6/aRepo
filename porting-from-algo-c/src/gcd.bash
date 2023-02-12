#
#	from src/gcd.c
#
#	int gcd(int, int) ; recursive	to	gcdR
#	int gcd(int, int) ; loop	to	gcdL
#	int ngcd(int, int[])		to	ngcd
#

_rec() {
	if [ "${2}" -eq "0" ]; then
		printf "${1}"
		exit
	else
		_rec ${2} $((${1} % ${2}))
	fi
}

gcdR() {
	[ "$#" -eq "2" ] || exit
	printf $(_rec $@)
}

gcdL() {
	[ "$#" -eq "2" ] || exit

	local t x y

	x=${1}; y=${2}
	while [ "$y" -ne "0" ]; do
		t=$(($x % $y)); x=$y; y=$t
	done

	printf $x
}

ngcd() {
	[ "$#" -eq "0" ] && exit

	local d=${1}
	shift

	while [ "$#" -gt "0" -a "$d" -ne "1" ]; do
		d=$(gcdL ${1} $d)
		shift
	done

	printf $d
}
