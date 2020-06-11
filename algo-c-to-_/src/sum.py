#
#	from src/sum.c
#
#	float sum1(int, float[])	to	sum1
#	float sum2(int, float[])	to	sum2
#

def sum1(a):
    r = 0
    for v in a:
        r += v
    return r

def sum2(a):
    r, rest = 0, 0
    for v in a:
        t = r
        rest += v
        r += rest
        t -= r
        rest += t
    return r
