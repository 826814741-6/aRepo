#
#	from src/fib.c
#
#	int fib1(int)		to	fib1
#	int fib2(int)		to	fib2
#	a part of main		to	fib3
#	fib3			to	fib4
#

from fib import fib1, fib2, fib3, fib4
import sys

for i in range(1,12):
    sys.stdout.write(" {0}".format(fib1(i)))
print()
for i in range(1,12):
    sys.stdout.write(" {0}".format(fib2(i)))
print()
for i in range(1,12):
    sys.stdout.write(" {0}".format(fib3(i)))
print()
for i in range(1,12):
    sys.stdout.write(" {0}".format(fib4(i)))
print()
