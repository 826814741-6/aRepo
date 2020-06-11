#
#	from src/fib.c
#
#	int fib1(int)		to	fib1
#	int fib2(int)		to	fib2
#	a part of main		to	fib3
#	fib3			to	fib4
#

from math import floor, pow, sqrt

def fib1(n):
    return floor(pow((1 + sqrt(5)) / 2, n) / sqrt(5) + 0.5)

def fib2(n):
    a, b, c, x, y = 1, 1, 0, 1, 0
    n = n - 1
    while n > 0:
        if n & 1 != 0:
            x, y = a * x + b * y, b * x + c * y
        a, b, c = a * a + b * b, b * (a + c), b * b + c * c
        n = n // 2
    return x

def fib3(n):
    a, b, c = 1, 0, 1
    while c < n:
        a, b, c = a + b, a, c + 1
    return a

def fib4(n):
    def iter(a, b, c):
        if c < n:
            return iter(a + b, a, c + 1)
        else:
            return a
    return iter(1, 0, 1)
