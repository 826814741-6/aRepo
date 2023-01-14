#
#	from src/acker.c
#
#	int A(int, int)		to	ack
#

ack () {
	if [ "${1}" -eq "0" ]; then
		printf $((${2} + 1))
		exit
	fi
	if [ "${2}" -eq "0" ]; then
		ack $((${1} - 1)) 1
	fi
	ack $((${1} - 1)) $(ack ${1} $((${2} - 1)))
}
