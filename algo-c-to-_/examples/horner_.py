#
#	from src/horner.c
#
#	double horner(int, double a[], double)		to	horner
#

from horner import horner

def fmt(a):
    assert len(a) > 0, "ERROR: 'a' must be a list/tuple that contains at least one element."

    r = []
    for i in range(len(a)-1, 1, -1):
        r.append("{0} * x^{1}".format(a[i], i))
    if len(a) >= 2:
        r.append("{0} * x".format(a[1]))
    r.append(str(a[0]))

    return "f(x) = {0}".format(" + ".join(r))

a = (1, 2, 3, 4, 5)
print(fmt(a))
print("f({0}) = {1}".format(2, horner(a,2)))
print("f({0}) = {1}".format(11, horner(a,11)))
print("f({0}) = {1}".format(121, horner(a,121)))
