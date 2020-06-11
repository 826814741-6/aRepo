#
#	from src/movebloc.c
#
#	void reverse(int, int)		to	reverse
#	void rotate(int, int, int)	to	rotate
#

from _helper import decrement, increment

def reverse(a, i, j):
    while i < j:
        a[i], a[j] = a[j], a[i]
        i, j = increment(i), decrement(j)

def rotate(a, left, mid, right):
    reverse(a, left, mid)
    reverse(a, increment(mid), right)
    reverse(a, left, right)
