#
#	from src/stirling.c
#
#	int Stirling1(int, int)		to	stirling1
#	int Stirling2(int, int)		to	stirling2
#

stirling1 () {
	if [ "${2}" -lt "1" -o "${2}" -gt "${1}" ]; then
		printf 0
		exit
	fi
	if [ "${2}" -eq "${1}" ]; then
		printf 1
		exit
	fi
	printf $(((${1} - 1) * $(stirling1 $((${1} - 1)) ${2}) \
		+ $(stirling1 $((${1} - 1)) $((${2} - 1)))))
}

stirling2 () {
	if [ "${2}" -lt "1" -o "${2}" -gt "${1}" ]; then
		printf 0
		exit
	fi
	if [ "${2}" -eq "1" -o "${2}" -eq "${1}" ]; then
		printf 1
		exit
	fi
	printf $((${2} * $(stirling2 $((${1} - 1)) ${2}) \
		+ $(stirling2 $((${1} - 1)) $((${2} - 1)))))
}
