#
#	from src/eulerian.c
#
#	Eulerian	to	eulerianNumber
#

. "src/eulerian.bash" || exit
. "src/_helper.bash" || exit

f0 () {
	printf ${1}
}

f1 () {
	printf $(eulerianNumber ${2} ${1})
}

# printT 0 10 0 10 3 8 f0 f0 f1 "L"
printT 0 6 0 6 3 8 f0 f0 f1 "L"

printf "\n(Note:\n"
printf " A smaller value (than the other langs) is set here to run casually.\n"
printf " If you have a powerful machine or enough time, please try same or more.)\n"
