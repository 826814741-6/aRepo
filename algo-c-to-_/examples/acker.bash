#
#	from src/acker.c
#
#	int A(int, int)		to	ack
#

. "src/acker.bash" || exit

# printf "%s = %d\n" "ack 3 3" $(ack 3 3)
printf "%s = %d\n" "ack 2 2" $(ack 2 2)

printf "\n(Note:\n"
printf " A smaller value (than the other langs) is set here to run casually.\n"
printf " If you have a powerful machine or enough time, please try same or more.)\n"
