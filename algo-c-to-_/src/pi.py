#
#	from src/pi1.c
#
#	long double pi(void)	to	machinLike
#
#	from src/pi2.c
#
#	a part of main		to	gaussLegendre
#

def machinLike():
    p, k, t = 0, 1, 16 / 5

    p, k, t, prev = p + t / k, k + 2, t / (-5 * 5), p
    while p != prev:
        p, k, t, prev = p + t / k, k + 2, t / (-5 * 5), p

    k, t = 1, 4 / 239
    p, k, t, prev = p - t / k, k + 2, t / (-239 * 239), p
    while p != prev:
        p, k, t, prev = p - t / k, k + 2, t / (-239 * 239), p

    return p

from math import sqrt

def gaussLegendre(n):
    a, b, t, u = 1, 1 / sqrt(2), 1, 4
    for _ in range(n):
        prev = a
        a, b = (a + b) / 2, sqrt(prev * b)
        t, u = t - u * (a - prev) * (a - prev), u * 2
    return (a + b) * (a + b) / t
