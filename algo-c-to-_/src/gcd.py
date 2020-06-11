#
#	from src/gcd.c
#
#	int gcd(int, int) ; recursive	to	gcdR
#	int gcd(int, int) ; loop	to	gcdL
#	int ngcd(int, int[])		to	ngcdL
#	ngcdL				to	ngcdR
#

def gcdR(x, y):
    if y == 0:
        return x
    else:
        return gcdR(y, x % y)

def gcdL(x, y):
    while y != 0:
        x, y = y, x % y
    return x

def ngcdL(a):
    if not type(a) in (type(()), type([])) or len(a) == 0:
        return

    d = a[0]
    for v in a[1:]:
        if d == 1:
            break
        d = gcdL(v, d)
    return d

def ngcdR(a):
    if not type(a) in (type(()), type([])) or len(a) == 0:
        return

    def iter(i, d):
        if i >= len(a) or d == 1:
            return d
        else:
            return iter(i+1, gcdR(a[i], d))

    return iter(1, a[0])
