#
#	from src/power.c
#
#	double ipower(double, int)	to	iPow
#	iPow				to	iPowR
#

. "src/power.bash" || exit

_p () {
	local r="T"
	[ "${1}" -eq "${2}" ] || r="F"
	printf $r
}

i=-10
while [ "${i}" -lt "0" ]; do
	printf "%3d %s %s\n" $i $(iPow 2 $i) $(iPowR 2 $i)
	i=$(($i + 1))
done
printf "%22s%19s\n" "2**n == iPow 2 n" "2**n == iPowR 2 n"
while [ "${i}" -le "10" ]; do
	printf "%3d%12s%18s\n" \
		$i $(_p $((2 ** $i)) $(iPow 2 $i)) $(_p $((2 ** $i)) $(iPowR 2 $i))
	i=$(($i + 1))
done
