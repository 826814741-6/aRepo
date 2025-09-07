--
--  from src/3dgraph.c
--
--    a part of main  to  tdGraph
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local tdGraph = require '3dgraph'.tdGraph
local with = require '_helper'.with

local function sampleFunction(x, z)
	local t = x * x + z * z
	return math.exp(-t) * math.cos(10 * math.sqrt(t))
end

local function sampleWriter(pathPrefix, x, y, parameters, style)
	function body(plotter)
		plotter:pathStart()
		tdGraph(plotter, sampleFunction, parameters)
		plotter:pathEnd(false, style)
	end

	with(("%s-A.svg"):format(pathPrefix), "w", function (fh)
		svgPlot(x, y):write(fh, body)
	end)

	with(("%s-B.svg"):format(pathPrefix), "w", function (fh)
		svgPlotWholeBuffer(x, y):write(fh, body):reset()
	end)

	with(("%s-C.svg"):format(pathPrefix), "w", function (fh)
		svgPlotWithBuffer(x, y):write(fh, body)
	end)
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

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
	sampleWriter("results/3dgraphA", m*2 + n*4, m + n*3, parameters, style)

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
	sampleWriter("results/3dgraphB", m*2 + n*4, m + n*5, parameters, style)

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
	sampleWriter("results/3dgraphC", m*2 + n*4, m - n, parameters, style)
end
