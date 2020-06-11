#
#	from src/stirling.c
#
#	int Stirling1(int, int)		to	stirling1
#	int Stirling2(int, int)		to	stirling2
#

def stirling1(n, k):
    if k < 1 or k > n:
        return 0
    if k == n:
        return 1
    return (n-1) * stirling1(n-1, k) + stirling1(n-1, k-1)

def stirling2(n, k):
    if k < 1 or k > n:
        return 0
    if k == 1 or k == n:
        return 1
    return k * stirling2(n-1, k) + stirling2(n-1, k-1)
