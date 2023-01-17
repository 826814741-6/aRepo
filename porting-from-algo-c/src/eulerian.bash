#
#	from src/eulerian.c
#
#	Eulerian	to	eulerianNumber
#

eulerianNumber() {
	if [ "${2}" -eq "0" ]; then
		printf 1
		exit
	fi
	if [ "${2}" -lt "0" -o "${2}" -ge "${1}" ]; then
		printf 0
		exit
	fi
	printf $(((${2}+1) * $(eulerianNumber $((${1}-1)) ${2}) + \
		$((${1}-${2})) * $(eulerianNumber $((${1}-1)) $((${2}-1)))))
}
