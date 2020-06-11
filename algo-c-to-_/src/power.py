#
#	from src/power.c
#
#	double ipower(double, int)	to	iPow
#	iPow				to	iPowR
#	double power(double, double)	to	fPow
#

def iPow(x, n):
    r, t = 1, abs(n)
    while t != 0:
        x, r, t = x*x, r*x if t&1==1 else r, t>>1
    return 1/r if n<0 else r

def _iter(x, n, r, t):
    if t != 0:
        return _iter(x*x, n, r*x if t&1==1 else r, t>>1)
    return 1/r if n<0 else r

def iPowR(x, n):
    return _iter(x, n, 1, abs(n))

from math import exp, log

def fPow(x, n):
    return exp(n*log(x)) if x>0 else 0
