#
#	from src/sqrt.c
#
#	double mysqrt(double)		to	fSqrt
#
#	from src/isqrt.c
#
#	unsigned isqrt(unsigned)	to	iSqrt
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

from _helper import atLeastOne

def loopF(x, step):
    prev, t = atLeastOne(x), step(x, atLeastOne(x))
    while t < prev:
        prev, t = t, step(x, t)
    return prev

def fSqrt(x):
    if x <= 0:
        return 0
    return loopF(x, lambda x, t: (x / t + t) / 2)

def iSqrt(x):
    if x <= 0:
        return 0

    r, t = x, 1
    while t < r:
        r, t = r >> 1, t << 1

    r, t = t, (x // t + t) >> 1
    while t < r:
        r, t = t, (x // t + t) >> 1

    return r

def _f(step):
    def f(x):
        if x == 0:
            return 0
        elif x > 0:
            return loopF(x, step)
        else:
            return -loopF(abs(x), step)
    return f

fCbrt = _f(lambda x, t: (x / (t * t) + 2 * t) / 3)
fCbrt2 = _f(lambda x, t: t + (x - t * t * t) / (2 * t * t + x / t))

def iCbrt(x):
    if x <= 0:
        return 0

    r, t = x, 1
    while t < r:
        r, t = r >> 2, t << 1

    r, t = t, (x // (t * t) + 2 * t) // 3
    while t < r:
        r, t = t, (x // (t * t) + 2 * t) // 3

    return r
