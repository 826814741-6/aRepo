#
#  from src/tarai.c
#
#    int tarai(int, int, int)  to  tarai
#    tarai                     to  tak(*)
#
#  *) https://en.wikipedia.org/wiki/Tak_(function)
#

function tarai(x, y, z) {
	_C++
	if (x <= y) return y
	return tarai(tarai(x-1, y, z), tarai(y-1, z, x), tarai(z-1, x, y))
}

function tak(x, y, z) {
	_C++
	if (x <= y) return z
	return tak(tak(x-1, y, z), tak(y-1, z, x), tak(z-1, x, y))
}

#

BEGIN {
	_C = 0
	printf "%s = %d (%d)\n", "tarai(10, 5, 0)", tarai(10, 5, 0), _C
	_C = 0
	printf "%s = %d (%d)\n", "tak(10, 5, 0)", tak(10, 5, 0), _C
}
