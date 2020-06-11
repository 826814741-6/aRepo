#
#	from src/jos1.c
#
#	a part of main		to	josephusProblem1
#
#	from src/jos2.c
#
#	a part of main		to	josephusProblem2
#

def josephusProblem1(n, p):
    k = 1
    for j in range(2, n+1):
        k = (k + p) % j
        if k == 0:
            k = j
    return k

def josephusProblem2(n, p):
    k = p - 1
    while k < (p - 1) * n:
        k = (p * k) // (p - 1) + 1
    return p * n - k
