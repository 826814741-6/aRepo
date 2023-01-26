--
--	from src/3dgraph.c
--
--	a part of main		to	tdGraph
--

local M0 = require 'svgplot'
local M1 = require '3dgraph'
local H = require '_helper'

local svgPlot = M0.svgPlot
local tdGraph = M1.tdGraph
local with = H.with

function sampleFunction(x, z)
	local t = x * x + z * z
	return math.exp(-t) * math.cos(10 * math.sqrt(t))
end

function sampleWriter(path, x, y, parameters)
	with(path, "w", function (fh)
		local plotter = svgPlot(x, y)
		plotter:plotStart(fh)
		tdGraph(plotter, sampleFunction, parameters)
		plotter:plotEnd()
	end)
end

do
	local m, n, t, u = 200, 20, 30, 5
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
	sampleWriter("results/3dgraphA.svg", m*2 + n*4, m + n*3, parameters)

	m, n, t, u = 300, 50, 30, 5
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
	sampleWriter("results/3dgraphB.svg", m*2 + n*4, m + n*5, parameters)

	m, n, t, u = 300, 50, 30, 2
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
	sampleWriter("results/3dgraphC.svg", m*2 + n*4, m - n, parameters)
end
