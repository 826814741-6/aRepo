#
#	from src/water.c
#
#	a part of main		to	isMeasurable
#

from gcd import gcdL

def isMeasurable(a, b, v):
    return (v <= a or v <= b) and (v % gcdL(a, b) == 0)
