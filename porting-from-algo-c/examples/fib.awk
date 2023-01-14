#
#	from src/fib.c
#
#	int fib1(int)		to	fib1
#	int fib2(int)		to	fib2
#	a part of main		to	fib3
#	fib3			to	fib4
#

BEGIN {
	for (i=1; i<=11; i++) printf " %d", fib1(i)
	print
	for (i=1; i<=11; i++) printf " %d", fib2(i)
	print
	for (i=1; i<=11; i++) printf " %d", fib3(i)
	print
	for (i=1; i<=11; i++) printf " %d", fib4(i)
	print
}
