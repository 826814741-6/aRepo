#
#	from src/acker.c
#
#	int A(int, int)		to	ack
#

. "src/acker.bash" || exit

printf "%s = %d\n" "ack 3 3" $(ack 3 3)
