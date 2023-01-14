#
#	from src/totient.c
#
#	unsigned phi(unsigned)		to	phi
#

function phi(x,		t, d) {
	t = x
	if (x % 2 == 0) {
		t = int(t/2)
		do {
			x = int(x/2)
		} while (x % 2 == 0)
	}

	d = 3
	while (int(x/d) >= d) {
		if (x % d == 0) {
			t = int(t/d) * (d - 1)
			do {
				x = int(x/d)
			} while (x % d == 0)
		}
		d += 2
	}

	if (x > 1) {
		t = int(t/x) * (x - 1)
	}

	return t
}
