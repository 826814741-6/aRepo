--
--	from src/ccurve.c
--
--	void c(int, double, double)	to	cCurve
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local cCurve = require 'ccurve'.cCurve
local with = require '_helper'.with

local function sampleWriter(pathPrefix, style)
	return function (n)
		function body(plotter)
			plotter:pathStart()
			plotter:move(100, 200)
			cCurve(plotter, n, 200, 0)
			plotter:pathEnd(false, style)
		end

		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlot(400, 250):write(fh, body)
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWholeBuffer(400, 250):write(fh, body):reset()
		end)

		with(("%s-C-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWithBuffer(400, 250):write(fh, body)
		end)
	end
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/ccurve", style)

	for n=1,10 do
		writer(n)
	end
end
