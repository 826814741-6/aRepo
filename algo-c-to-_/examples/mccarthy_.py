#
#	from src/mccarthy.c
#
#	int McCarthy(int)	to	mccarthy91
#

from mccarthy import mccarthy91
import sys

def _t_mccarthy91(l, r):
    for i in range(l, r+1):
        t = mccarthy91(i)
        if t != 91:
            print("ERROR: {0} {1}".format(i, t))
            sys.exit()
    print("mccarthy91 seems to be 91 in {0} to {1}".format(l, r))

_t_mccarthy91(-(1 << 10), 100)

print("... and in 101 to 110 are:")

for i in range(101, 111):
    sys.stdout.write("{0:4d}:{1}".format(i, mccarthy91(i)))
print()
