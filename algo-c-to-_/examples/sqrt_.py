#
#	from src/sqrt.c
#
#	double mysqrt(double)		to	fSqrt
#
#	from src/isqrt.c
#
#	unsigned isqrt(unsigned)	to	iSqrt
#

from nthroot import fSqrt, iSqrt
from math import sqrt
from sys import exit

def _t_iSqrt(l, r):
    for i in range(l, r):
        t = iSqrt(i)
        if t * t > i or (t+1) * (t+1) <= i:
            print("ERROR: {0:d} {1:d}".format(i, t))
            exit()

    print("iSqrt() seems to be fine in {0:d} to {1:d}-1.".format(l, r))

for i in range(21):
    print("math.sqrt({0})\t{1:.20f}\nfSqrt({2})\t{3:.20f} ({4})".format(
        i, sqrt(i), i, fSqrt(i), sqrt(i) == fSqrt(i)))

print()

# _t_iSqrt(0, 1 << 32) # Maybe this will take a lot of time. (*)
_t_iSqrt(0, 1 << 16)

#
#	*) Please choose a number depending on the purpose and situation.
#
#	e.g. a list of elapsed time - running _t_iSqrt(0, n) on my old cheap laptop
#
#	in luajit, n == 1<<28 (2^28):
#
#		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
#		...
#		iSqrt() seems to be fine in 0 to 268435456-1.
#
#		real    0m36.307s
#		user    0m35.889s
#		sys     0m0.015s
#
#	in luajit, n == 1<<32 (2^32):
#
#		$ time LUA_PATH=src/?.luajit luajit example/sqrt.luajit
#		...
#		iSqrt() seems to be fine in 0 to 4294967296-1.
#
#		real    10m0.827s
#		user    10m0.906s
#		sys     0m0.096s
#
#	in lua, n == 1<<28 (2^28)
#
#		$ time LUA_PATH=src/?.lua lua example/sqrt.lua
#		...
#		iSqrt() seems to be fine in 0 to 268435456-1.
#
#		real    4m50.528s
#		user    4m50.730s
#		sys     0m0.021s
#
