#
#	from src/mccarthy.c
#
#	int McCarthy(int)	to	mccarthy91
#

. "src/mccarthy.bash" || exit

_t_mccarthy91 () {
	local i t
	i=${1}
	while [ "$i" -le "${2}" ]; do
		t=$(mccarthy91 $i)
		if [ "$t" -ne "91" ]; then
			printf "ERROR: %d %d\n" $i $t
			exit
		fi
		i=$(($i + 1))
	done
	printf "mccarthy91 seems to be 91 in %d to %d\n" ${1} ${2}
}

_t_mccarthy91 -100 100

printf "... and in 101 to 110 are:\n"

i=101
while [ "$i" -le "110" ]; do
	printf "%4d:%d" $i $(mccarthy91 $i)
	i=$(($i + 1))
done
printf "\n"
