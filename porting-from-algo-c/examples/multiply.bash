#
#	from src/multiply.c
#
#	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
#

. "src/multiply.bash" || exit

printf "%s, %s -> %d, %d\n" "2*3" "mulA(2,3)" $((2 * 3)) $(mulA 2 3)
printf "%s, %s -> %d, %d\n" "2*3" "mulB(2,3)" $((2 * 3)) $(mulB 2 3)
printf "%s, %s -> %d, %d\n" "2*3" "mulC(2,3)" $((2 * 3)) $(mulC 2 3)
