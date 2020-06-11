#
#	from src/3dgraph.c
#
#	a part of main		to	tdGraph
#

_MAX_VALUE = float("inf")

class parametersTDGraph:
    def __init__(self, m, n, t, u, minX, minY, minZ, maxX, maxY, maxZ):
        self.m = m
        self.n = n
        self.t = t
        self.u = u
        self.minX = minX
        self.minY = minY
        self.minZ = minZ
        self.maxX = maxX
        self.maxY = maxY
        self.maxZ = maxZ

def tdGraph(plotter, aFunction, parameters):
    P = parameters

    lowerHorizon = [ _MAX_VALUE for _ in range(P.m + 4 * P.n + 1) ]
    upperHorizon = [ -_MAX_VALUE for _ in range(P.m + 4 * P.n + 1) ]

    for i in range(P.n + 1):
        flagA = False
        z = P.minZ + (P.maxZ - P.minZ) / P.n * i

        for j in range(P.m + 1):
            flagB = False
            idx = j + 2 * (P.n - i)

            x = P.minX + (P.maxX - P.minX) / P.m * j
            y = P.t * (aFunction(x, z) - P.minY) / (P.maxY - P.minY) + P.u * i

            if y < lowerHorizon[idx]:
                lowerHorizon[idx], flagB = y, True

            if y > upperHorizon[idx]:
                upperHorizon[idx], flagB = y, True

            if flagB and flagA:
                plotter.draw(2 * idx, 2 * y)
            else:
                plotter.move(2 * idx, 2 * y)

            flagA = flagB
