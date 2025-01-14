--
--	from src/dragon.c
--
--	void dragon(int, double, double, int)	to	dragonCurveR
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local dragonCurveR = require 'dragoncurve'.dragonCurveR
local with = require '_helper'.with

local function sampleWriter(pathPrefix, x, y, dx, dy, sign, x0, y0, style)
	return function (n)
		function body(plotter)
			plotter:pathStart()
			dragonCurveR(plotter, n, dx, dy, sign, x0, y0)
			plotter:pathEnd(false, style)
		end

		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlot(x, y):write(fh, body)
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWholeBuffer(x, y):write(fh, body):reset()
		end)

		with(("%s-C-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWithBuffer(x, y):write(fh, body)
		end)
	end
end

do
	local x, y, dx, dy = 400, 250, 200, 0
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100, style)

	for n=1,10 do
		writer(n)
	end

	sampleWriter("results/dragoncurveR", x, y, dx, dy, 1, 100, 100, style)(12)
	sampleWriter("results/dragoncurveRN", x, y, dx, dy, -1, 70, 160, style)(12)
end
