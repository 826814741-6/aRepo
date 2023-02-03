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

def factorizeG(x):
    while x >= 4 and x % 2 == 0:
        yield 2
        x = x // 2

    d = 3
    q = x // d
    while q >= d:
        if x % d == 0:
            yield d
            x = q
        else:
            d = d + 2
        q = x // d

    yield x

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

#

def _demo1(n, start=1):
    for i in range(start, n+1):
        print("{0:5d} = ".format(i), end="")
        factorize(i)

        print("{0:5d} = ".format(i), end="")
        print(" * ".join(map(str, factorizeG(i))))

        print("{0:5d} = ".format(i), end="")
        print(" * ".join(factorizeL(i, fmt=str)))

def _demo2(n):
    t = (1 << n) * 997 * 10007
    g = factorizeG(t)

    i = 1
    while i <= n:
        v = g.__next__()
        assert v == 2, "ERROR: {0}th is not 2. ({1})".format(i, v)
        i += 1
    assert g.__next__() == 997
    assert g.__next__() == 10007

if __name__ == "__main__":
    _demo1(100)
    _demo2(10000)
