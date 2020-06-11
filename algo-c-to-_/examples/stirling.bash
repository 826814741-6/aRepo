#
#	from src/stirling.c
#
#	int Stirling1(int, int)		to	stirling1
#	int Stirling2(int, int)		to	stirling2
#

. "src/stirling.bash" || exit
. "src/_helper.bash" || exit

f0 () {
	printf ${1}
}

f1 () {
	printf $(stirling1 ${2} ${1})
}

f2 () {
	printf $(stirling2 ${2} ${1})
}

printf -- "-------- Stirling numbers of the first kind:\n"
printT 0 10 0 10 3 8 f0 f0 f1 "L"
printf -- "-------- Stirling numbers of the second kind:\n"
printT 0 10 0 10 3 8 f0 f0 f2 "L"
