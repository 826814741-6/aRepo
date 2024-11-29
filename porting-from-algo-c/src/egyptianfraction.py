#
#	from src/egypfrac.c
#
#	a part of main		to	egyptianFraction
#	egyptianFraction	to	egyptianFractionG
#	egyptianFraction	to	egyptianFractionL
#

def egyptianFraction(n0, d0):
    n, d = n0, d0
    while d % n != 0:
        t = d // n + 1
        print("1/{0} + ".format(t), end="")
        n, d = n * t - d, d * t
    print("1/{0}".format(d // n))

def egyptianFractionG(n0, d0):
    n, d = n0, d0
    while d % n != 0:
        t = d // n + 1
        yield t
        n, d = n * t - d, d * t
    yield d // n

def egyptianFractionL(n0, d0, fmt=lambda t: t):
    r, n, d = [], n0, d0
    while d % n != 0:
        t = d // n + 1
        r.append(fmt(t))
        n, d = n * t - d, d * t
    r.append(fmt(d // n))
    return r

#

def _demo():
    fmt0 = lambda n, d: f"{n}/{d} = "
    fmt = lambda t: f"1/{t}"

    print("Egyptian fraction: n/d = 1/a + 1/b + 1/c + ...")
    n = int(input("numerator is > "))
    d = int(input("denominator is > "))

    print(fmt0(n, d), end="")
    egyptianFraction(n, d)

    print(fmt0(n, d), end="")
    print(" + ".join(map(fmt, egyptianFractionG(n, d))))

    print(fmt0(n, d), end="")
    print(" + ".join(egyptianFractionL(n, d, fmt=fmt)))

if __name__ == '__main__':
    _demo()
