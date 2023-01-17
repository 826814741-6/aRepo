#
#	from src/totient.c
#
#	unsigned phi(unsigned)		to	phi
#

. "src/totient.bash" || exit
. "src/_helper.bash" || exit

f0() {
	printf $((${1} * 10))
}
f1() {
	printf ${1}
}
f2() {
	printf $(phi $((${2} * 10 + ${1})))
}

printT 1 10 0 19 4 4 f0 f1 f2
