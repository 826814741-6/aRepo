#
#	from src/factoriz.c
#
#	void factorize(int)	to	factorize
#	factorize		to	factorizeG
#	factorize		to	factorizeL
#

def factorize(x):
    while x >= 4 and x % 2 == 0:
        print("2 * ", end="")
        x = x // 2

    d = 3
    q = x // d
    while q >= d:
        if x % d == 0:
            print("{0} * ".format(d), end="")
            x = q
        else:
            d = d + 2
        q = x // d

    print("{0}".format(x))

def factorizeG(x, fmt=lambda x: x):
    while x >= 4 and x % 2 == 0:
        yield fmt(2)
        x = x // 2

    d = 3
    q = x // d
    while q >= d:
        if x % d == 0:
            yield fmt(d)
            x = q
        else:
            d = d + 2
        q = x // d

    yield fmt(x)

def factorizeL(x, fmt=lambda x: x):
    r = []

    while x >= 4 and x % 2 == 0:
        r.append(fmt(2))
        x = x // 2

    d = 3
    q = x // d
    while q >= d:
        if x % d == 0:
            r.append(fmt(d))
            x = q
        else:
            d = d + 2
        q = x // d

    r.append(fmt(x))

    return r
