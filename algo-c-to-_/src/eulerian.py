#
#	from src/eulerian.c
#
#	Eulerian	to	eulerianNumber
#

def eulerianNumber(n, k):
    if k == 0:
        return 1
    if k < 0 or k >= n:
        return 0
    return (k+1) * eulerianNumber(n-1,k) + (n-k) * eulerianNumber(n-1,k-1)
