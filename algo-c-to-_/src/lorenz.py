#
#	from src/lorenz.c
#
#	a part of main		to	lorenzAttractor
#

def lorenzAttractor(plotter, S, R, B, n, a1, a2, a3, a4):
    def step(x, y, z):
        return x + a1*(S*(y-x)), y + a1*(x*(R-z)-y), z + a1*(x*y-B*z)

    x, y, z = 1, 1, 1

    for _ in range(100):
        x, y, z = step(x, y, z)
        plotter.move(a2 * x + a3, a2 * z - a4)

    for _ in range(100, n):
        x, y, z = step(x, y, z)
        plotter.draw(a2 * x + a3, a2 * z - a4)
