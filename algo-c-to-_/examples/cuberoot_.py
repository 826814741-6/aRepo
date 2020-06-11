#
#	from src/cuberoot.c
#
#	double cuberoot(double)		to	fCbrt
#	double cuberoot2(double)	to	fCbrt2
#
#	from src/icubrt.c
#
#	unsigned icubrt(unsigned)	to	iCbrt
#

from nthroot import fCbrt, fCbrt2, iCbrt
from sys import exit

def _t_iCbrt(l, r):
    for i in range(l, r):
        t = iCbrt(i)
        if t * t * t > i or (t+1) * (t+1) * (t+1) <= i:
            print("ERROR: {0:d} {1:d}".format(i, t))
            exit()

    print("\niCbrt() seems to be fine in {0:d} to {1:d}-1.".format(l, r))

for i in range(-10, 11):
    t, u = fCbrt(i), fCbrt2(i)
    print("{0:3d} {1:.14f} {2:18.14f} {3:>6} (delta: {4:g})".format(
        i, t, u, str(t == u), abs(t-u)))

# _t_iCbrt(0, 1 << 32) # Maybe this will take a lot of time. (*)
_t_iCbrt(0, 1 << 16)

#
#	*) Please choose a number depending on the purpose and situation.
#
#	e.g. a list of elapsed time - running _t_iCbrt(0, n) on my old cheap laptop
#
#	in luajit, n == 1<<28 (2^28):
#
#		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
#		...
#		iCbrt() seems to be fine in 0 to 268435456-1.
#
#		real    0m49.737s
#		user    0m49.516s
#		sys     0m0.036s
#
#	in luajit, n == 1<<32 (2^32):
#
#		$ time LUA_PATH=src/?.luajit luajit example/cuberoot.luajit
#		...
#		iCbrt() seems to be fine in 0 to 4294967296-1.
#
#		real    13m32.873s
#		user    13m33.160s
#		sys     0m0.122s
#
#	in lua, n == 1<<28 (2^28)
#
#		$ time LUA_PATH=src/?.lua lua example/cuberoot.lua
#		...
#		iCbrt() seems to be fine in 0 to 268435456-1.
#
#		real    5m9.958s
#		user    5m9.423s
#		sys     0m0.082s
#
