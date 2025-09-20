#
#  from src/lorenz.c
#
#    a part of main  to  lorenzAttractor
#

#
#  move, draw from src/svgplot.awk
#

function step(a, S, R, B, a1,	x, y, z) {
	x = a[1]; y = a[2]; z = a[3]
	a[1] = x + a1 * (S * (y - x))
	a[2] = y + a1 * (x * (R - z) - y)
	a[3] = z + a1 * (x * y - B * z)
}

function lorenzAttractor(S, R, B, n, a1, a2, a3, a4,	a, _) {
	split("1 1 1", a)

	for (_ = 1; _ <= 100; _++) {
		step(a, S, R, B, a1)
		move(a2 * a[1] + a3, a2 * a[3] - a4)
	}

	for (_ = 101; _ <= n; _++) {
		step(a, S, R, B, a1)
		draw(a2 * a[1] + a3, a2 * a[3] - a4)
	}
}
