#
#	from src/movebloc.c
#
#	void reverse(int, int)		to	reverse
#	void rotate(int, int, int)	to	rotate
#

#
#	decrement(n), increment(n), swap(a, i, j) from _helper.awk
#

function reverse(a, i, j) {
	while (i < j) {
		swap(a, i, j)
		i = increment(i)
		j = decrement(j)
	}
}

function rotate(a, left, mid, right) {
	reverse(a, left, mid)
	reverse(a, increment(mid), right)
	reverse(a, left, right)
}
