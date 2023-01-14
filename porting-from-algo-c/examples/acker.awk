#
#	from src/acker.c
#
#	int A(int, int)		to	ack
#

function _ack(x, y) {
	_C++
	if (x == 0) return y+1
	if (y == 0) return _ack(x-1,1)
	return _ack(x-1, _ack(x,y-1))
}

function count(x, y) {
	_C = 0
	_ack(x, y)
	return _C
}

BEGIN {
	printf "%s = %d, %d\n", "ack(3,3)", ack(3,3), count(3,3)
}
