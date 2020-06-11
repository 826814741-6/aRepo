#
#	from src/egypfrac.c
#
#	a part of main		to	ef
#	ef			to	efGenerate
#	ef			to	efList
#

def ef(n, d):
    while d % n != 0:
        t = d // n + 1
        print("1/{0} + ".format(t), end="")
        n, d = n * t - d, d * t
    print("1/{0}".format(d // n))

def efGenerate(n, d, fmt=lambda t: t):
    while d % n != 0:
        t = d // n + 1
        yield fmt(t)
        n, d = n * t - d, d * t
    yield fmt(d // n)

def efList(n, d, fmt=lambda t: t):
    r = []
    while d % n != 0:
        t = d // n + 1
        r.append(fmt(t))
        n, d = n * t - d, d * t
    r.append(fmt(d // n))
    return r
