#
#	from src/change.c
#
#	int change(int, int)		to	changeR
#	int change1(int, int)		to	changeL
#

def changeR(n, k):
    if n < 0:
        return 0

    r = 1 + n // 5 + changeR(n - 10, 10)
    if k >= 50:
        r += changeR(n - 50, 50)
    if k >= 100:
        r += changeR(n - 100, 100)

    return r

def changeL(n):
    r = 0
    for i in range(n//100, -1, -1):
        t = n - 100 * i
        for j in range(t//50, -1, -1):
            u = t - 50 * j
            r += (1 + u//5 - u//10) * (1 + u//10)
    return r
