#
#	from src/totient.c
#
#	unsigned phi(unsigned)		to	phi
#

phi () {
	local x t d

	x=${1}; t=${1}
	if [ "$(($x % 2))" -eq "0" ]; then
		t=$(($t / 2)); x=$(($x / 2))
		while [ "$((x % 2))" -eq "0" ]; do
			x=$(($x / 2))
		done
	fi

	d=3
	while [ "$(($x / $d))" -ge "$d" ]; do
		if [ "$(($x % $d))" -eq "0" ]; then
			t=$(($t / $d * ($d - 1))); x=$(($x / $d))
			while [ "$(($x % $d))" -eq "0" ]; do
				x=$(($x / $d))
			done
		fi
		d=$(($d + 2))
	done

	[ "$x" -gt "1" ] && t=$(($t / $x * ($x - 1)))

	printf $t
}
