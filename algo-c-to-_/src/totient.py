#
#	from src/totient.c
#
#	unsigned phi(unsigned)		to	phi
#

def phi(x):
    t = x
    if x % 2 == 0:
        t, x = t // 2, x // 2
        while x % 2 == 0:
            x = x // 2

    d = 3
    while x // d >= d:
        if x % d == 0:
            t, x = t // d * (d - 1), x // d
            while x % d == 0:
                x = x // d
        d += 2

    if x > 1:
        t = t // x * (x - 1)

    return t
