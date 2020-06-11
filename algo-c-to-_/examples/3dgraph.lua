--
--	from src/3dgraph.c
--
--	a part of main		to	tdGraph
--

local M0 = require 'svgplot'
local M1 = require '3dgraph'

local svgPlot = M0.svgPlot
local tdGraph = M1.tdGraph

function sampleFunction(x, z)
	local t = x * x + z * z
	return math.exp(-t) * math.cos(10 * math.sqrt(t))
end

function sampleWriter(path, plotter, parameters)
	local fh = io.open(path, "w")

	plotter:plotStart(fh)
	local ret = pcall(tdGraph, plotter, sampleFunction, parameters)
	plotter:plotEnd()

	fh:close()
	assert(ret == true)
end

do
	local m, n, t, u = 200, 20, 30, 5
	local plotter = svgPlot(m * 2 + n * 4, m + n * 3)

	local parameters = {
		m = m,
		n = n,
		t = t,
		u = u,
		minX = -1,
		minY = -1,
		minZ = -1,
		maxX = 1,
		maxY = 1,
		maxZ = 1
	}

	sampleWriter("results/3dgraphA.svg", plotter, parameters)

	m, n, t, u = 300, 50, 30, 5
	plotter = svgPlot(m * 2 + n * 4, m + n * 5)

	parameters = {
		m = m,
		n = n,
		t = t,
		u = u,
		minX = -1.8,
		minY = -1.8,
		minZ = -1.8,
		maxX = 1.8,
		maxY = 1.8,
		maxZ = 1.8
	}

	sampleWriter("results/3dgraphB.svg", plotter, parameters)

	m, n, t, u = 300, 50, 30, 2
	plotter = svgPlot(m * 2 + n * 4, m - n * 1)

	parameters = {
		m = m,
		n = n,
		t = t,
		u = u,
		minX = -1.8,
		minY = -1.0,
		minZ = -1.8,
		maxX = 1.8,
		maxY = 1.0,
		maxZ = 1.8
	}

	sampleWriter("results/3dgraphC.svg", plotter, parameters)
end
