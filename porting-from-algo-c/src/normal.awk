#
#	from src/normal.c
#
#	double pNormal(double)		to	pNormal
#	double qNormal(double)		to	qNormal
#

BEGIN {
	PI = 3.14159265358979323846264 # from src/normal.c
}

function pNormal(z,	p, prev, t, i) {
	t = z * exp(-0.5 * z * z) / sqrt(2 * PI)
	p = t
	for (i = 3; i < 200; i += 2) {
		prev = p
		t *= (z*z) / i
		p += t
		if (p == prev) return 0.5 + p
	}
	return z > 0
}

function qNormal(z) {
	return 1 - pNormal(z)
}

#

BEGIN {
	printf "%-3s %-16s\n", "z", "pNormal(z)"
	for (i = 0; i <= 20; i++) {
		z = 0.2 * i
		printf "%3.1f %16.14f\n", z, pNormal(z)
	}
}
