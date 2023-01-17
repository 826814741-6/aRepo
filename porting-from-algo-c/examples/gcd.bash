#
#	from src/gcd.c
#
#	int gcd(int, int) ; recursive	to	gcdR
#	int gcd(int, int) ; loop	to	gcdL
#	int ngcd(int, int[])		to	ngcd
#

. "src/gcd.bash" || exit

_t_gcd() {
	if [ "$(gcdL ${1} ${2})" -ne "${3}" ]; then printf 0; exit; fi
	if [ "$(gcdR ${1} ${2})" -ne "${3}" ]; then printf 0; exit; fi
	if [ "$(gcdL ${1} ${2})" -ne "$(gcdR ${1} ${2})" ]; then printf 0; exit; fi
	if [ "${1}" -ne "${2}" ]; then
		if [ "$(gcdL ${2} ${1})" -ne "${3}" ]; then printf 0; exit; fi
		if [ "$(gcdR ${2} ${1})" -ne "${3}" ]; then printf 0; exit; fi
	fi
	if [ "$(gcdL $(gcdL $(gcdL ${1} ${2}) ${1}) ${2})" -ne "${3}" ]; then printf 0; exit; fi
	if [ "$(gcdR $(gcdR $(gcdR ${1} ${2}) ${1}) ${2})" -ne "${3}" ]; then printf 0; exit; fi
	if [ "$(gcdL $(gcdR $(gcdL ${1} ${2}) ${2}) ${1})" -ne "${3}" ]; then printf 0; exit; fi
	if [ "$(gcdR $(gcdL $(gcdR ${1} ${2}) ${2}) ${1})" -ne "${3}" ]; then printf 0; exit; fi
	printf 1
}

_t_ngcd() {
	local d=${1}
	shift
	if [ "$(ngcd $@)" -ne "$d" ]; then
		printf 0; exit
	fi
	printf 1
}

t0=0
t0=$(($t0 + $(_t_gcd 11 121 11)))
t0=$(($t0 + $(_t_gcd 22 22 22)))
t0=$(($t0 + $(_t_gcd 2 3 1)))

# 2147483647*4194304 (9007199250546688) < 1<<53
t0=$(($t0 + $(_t_gcd 2147483647 $((2147483647 * 4194304)) 2147483647)))
# 2147483647*4194305 (9007201398030335) > 1<<53
t0=$(($t0 + $(_t_gcd 2147483647 $((2147483647 * 4194305)) 2147483647)))

t0=$(($t0 + $(_t_gcd 2147483647 $((2147483647 * 6700417)) 2147483647)))
t0=$(($t0 + $(_t_gcd 67280421310721 2305843009213693951 1)))
t0=$(($t0 + $(_t_gcd 2305843009213693951 2305843009213693951 2305843009213693951)))

printf "gcdL and gcdR seem to be fine (in %d/%d samples).\n" $t0 8

t1=0
t1=$(($t1 + $(_t_ngcd 1 1)))
t1=$(($t1 + $(_t_ngcd 10 10)))
t1=$(($t1 + $(_t_ngcd 1 2 3)))
t1=$(($t1 + $(_t_ngcd 22 22 22 22 22 22)))
t1=$(($t1 + $(_t_ngcd 11 11 22 33 44 55 66 77 88 99 110)))
t1=$(($t1 + $(_t_ngcd 2147483647 2147483647 2147483647 $((2147483647 * 6700417)))))
t1=$(($t1 + $(_t_ngcd 1 1 2147483647 $((2147483647 * 6700417)) 6700417)))
t1=$(($t1 + $(_t_ngcd 1 6700417 2147483647 2305843009213693951)))

printf "ngcd seems to be fine (in %d/%d samples).\n" $t1 8
