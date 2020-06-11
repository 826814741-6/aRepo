#
#	from src/factoriz.c
#
#	void factorize(int)	to	factorize
#	factorize		to	factorizeG
#	factorize		to	factorizeL
#

from factorize import factorize, factorizeG, factorizeL

for i in range(1, 101):
    print("{0:5d} = ".format(i), end="")
    factorize(i)

    print("{0:5d} = ".format(i), end="")
    print(" * ".join(map(str, factorizeG(i))))

    print("{0:5d} = ".format(i), end="")
    print(" * ".join(factorizeG(i, fmt=str)))

    print("{0:5d} = ".format(i), end="")
    print(" * ".join(map(str, factorizeL(i))))

    print("{0:5d} = ".format(i), end="")
    print(" * ".join(factorizeL(i, fmt=str)))
