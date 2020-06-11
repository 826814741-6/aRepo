#
#	from src/horner.c
#
#	double horner(int, double a[], double)		to	horner
#

#
#	a = (number, number, number, number, number, ...)
#
#	[0] + [1] * x + [2] * x^2 + [3] * x^3 + [4] * x^4 + ...
#
#	... + [4] * x^4 + [3] * x^3 + [2] * x^2 + [1] * x^1 + [0]
#

def horner(a, x):
    assert len(a) > 0, "ERROR: 'a' must be a list/tuple that contains at least one element."

    p = a[len(a)-1]
    for i in range(len(a)-2,-1,-1):
        p = p * x + a[i]
    return p
