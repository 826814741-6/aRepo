#
#	from src/mccarthy.c
#
#	int McCarthy(int)	to	mccarthy91
#

mccarthy91() {
	if [ "${1}" -gt 100 ]; then
		printf $((${1} - 10))
		exit
	else
		mccarthy91 $(mccarthy91 $((${1} + 11)))
	fi
}
