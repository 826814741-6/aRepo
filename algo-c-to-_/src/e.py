#
#	from src/e.c
#
#	long double ee(void)	to	e
#

def e():
    r, a, n = 0, 1, 1

    r, a, n, prev = r + a, a / n, n + 1, r
    while r != prev:
        r, a, n, prev = r + a, a / n, n + 1, r

    return r, n
