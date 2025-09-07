#
#  from src/factoriz.c
#
#    void factorize(int)  to  factorize
#    factorize            to  factorizeG
#    factorize            to  factorizeL
#

def factorize(x0):
    x = x0
    while x >= 4 and x % 2 == 0:
        print("2 * ", end="")
        x = x // 2

    d = 3
    q = x // d
    while q >= d:
        if x % d == 0:
            print(f"{d} * ", end="")
            x = q
        else:
            d = d + 2
        q = x // d

    print(f"{x}")

def factorizeG(x0):
    x = x0
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

def factorizeL(x0, fmt=lambda x: x):
    r, x = [], x0

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
        print(f"{i:5d} = ", end="")
        factorize(i)

        print(f"{i:5d} = {' * '.join(map(str, factorizeG(i)))}")

        print(f"{i:5d} = {' * '.join(factorizeL(i, fmt=str))}")

def _demo2(n):
    t = (1 << n) * 997 * 10007
    g = factorizeG(t)

    i = 1
    while i <= n:
        v = g.__next__()
        assert v == 2, f"ERROR: {i}th is not 2. ({v})"
        i += 1
    assert g.__next__() == 997
    assert g.__next__() == 10007

if __name__ == "__main__":
    _demo1(100)
    _demo2(10000)
