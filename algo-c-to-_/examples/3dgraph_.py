#
#	from src/3dgraph.c
#
#	a part of main		to	tdGraph
#

from svgplot import svgPlot
from _3dgraph import parametersTDGraph, tdGraph

from math import cos, exp, sqrt

def sampleFunction(x, z):
    t = x * x + z * z
    return exp(-t) * cos(10 * sqrt(t))

def sampleWriter(path, plotter, parameters):
    with open(path, "w") as fh:
        plotter.plotStart(fh)
        tdGraph(plotter, sampleFunction, parameters)
        plotter.plotEnd()

#

m, n, t, u = 200, 20, 30, 5
plotter = svgPlot(m * 2 + n * 4, m + n * 3)

parameters = parametersTDGraph(
    m,
    n,
    t,
    u,
    -1,
    -1,
    -1,
    1,
    1,
    1
)

sampleWriter("results/3dgraphA-py.svg", plotter, parameters)

m, n, t, u = 300, 50, 30, 5
plotter = svgPlot(m * 2 + n * 4, m + n * 5)

parameters = parametersTDGraph(
    m,
    n,
    t,
    u,
    -1.8,
    -1.8,
    -1.8,
    1.8,
    1.8,
    1.8
)

sampleWriter("results/3dgraphB-py.svg", plotter, parameters)

m, n, t, u = 300, 50, 30, 2
plotter = svgPlot(m * 2 + n * 4, m - n * 1)

parameters = parametersTDGraph(
    m,
    n,
    t,
    u,
    -1.8,
    -1.0,
    -1.8,
    1.8,
    1.0,
    1.8
)

sampleWriter("results/3dgraphC-py.svg", plotter, parameters)
