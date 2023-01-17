#
#	from src/water.c
#
#	a part of main		to	isMeasurable
#

. "src/gcd.bash" || exit

isMeasurable() {
	if [ "${3}" -le "${1}" -o "${3}" -le "${2}" ]; then
		if [ "$((${3} % $(gcdL ${1} ${2})))" -eq "0" ]; then
			printf 1
		fi
	fi
	return
}
