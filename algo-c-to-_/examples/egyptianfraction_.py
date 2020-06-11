#
#	from src/egypfrac.c
#
#	a part of main		to	ef
#	ef			to	efGenerate
#	ef			to	efList
#

from egyptianfraction import ef, efGenerate, efList

fmt0 = lambda n, d: "{0}/{1} = ".format(n, d)
fmt = lambda t: "1/{0}".format(t)

print("Egyptian fraction: n/d = 1/a + 1/b + ... + 1/x")
n = int(input("numerator is > "))
d = int(input("denominator is > "))

print(fmt0(n, d), end="")
ef(n, d)

print(fmt0(n, d), end="")
print(" + ".join(map(fmt, efGenerate(n, d))))

print(fmt0(n, d), end="")
print(" + ".join(efGenerate(n, d, fmt=fmt)))

print(fmt0(n, d), end="")
print(" + ".join(map(fmt, efList(n, d))))

print(fmt0(n, d), end="")
print(" + ".join(efList(n, d, fmt=fmt)))
