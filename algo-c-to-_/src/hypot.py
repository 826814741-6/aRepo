#
#	from src/hypot.c
#
#	double hypot0(double, double)		to	hypot0
#	double hypot1(double, double)		to	hypot1
#	double hypot2(double, double)		to	hypot2	(Moler-Morrison)
#

from math import sqrt

def hypot0(x, y):
    return sqrt(x * x + y * y)

def hypot1(x, y):
    if x == 0:
        return abs(y)
    if y == 0:
        return abs(x)
    if abs(x) < abs(y):
        return abs(y) * sqrt(1 + (x/y) * (x/y))
    else:
        return abs(x) * sqrt(1 + (y/x) * (y/x))

def hypot2(x, y):
    a, b = abs(x), abs(y)
    if a < b:
        a, b = b, a
    if b == 0:
        return a
    for _ in range(3):
        t = (b/a)*(b/a) / (4 + (b/a)*(b/a))
        a, b = a + 2 * a * t, b * t
    return a
