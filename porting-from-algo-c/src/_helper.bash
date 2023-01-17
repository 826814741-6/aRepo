border() {
	local n=${1}
	while [ "$n" -gt "0" ]; do
		printf "-"
		n=$(($n - 1))
	done
	printf "\n"
}

padding() {
	printf "%${1}s" " "
}

printH() {
	local i j
	j=${1}; i=${2}
	while [ "$i" -le "${3}" ]; do
		printf "%${4}d" $(${5} $i $j)
		i=$(($i + 1))
	done
	printf "\n"
}

printT() {
	local j t

	padding $((${5} + 2))
	printH _ ${1} ${2} ${6} ${8}
	padding $((${5} + 2))
	border $((${6} * (${2} - ${1} + 1)))

	j=${3}
	while [ "$j" -le "${4}" ]; do
		[ "${10}" = "L" ] && t=$j || t=${2}
		printf "%${5}d |" $(${7} $j)
		printH $j ${1} $t ${6} ${9}
		j=$(($j + 1))
	done
}
