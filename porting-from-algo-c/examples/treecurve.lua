--
--  from src/treecurv.c
--
--    void tree(int, double, double)  to  treeCurve
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local treeCurve = require 'treecurve'.treeCurve
local file = require '_helper'.file

local function sampleWriter(pathPrefix, style)
	return function (n)
		function body(plotter)
			plotter:pathStart()
			plotter:move(200, 0)
			treeCurve(plotter, n, 100, 0, 0.7, 0.5)
			plotter:pathEnd(false, style)
		end

		file(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlot(400, 350):write(fh, body)
		end)

		file(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWholeBuffer(400, 350):write(fh, body):reset()
		end)

		file(("%s-C-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWithBuffer(400, 350):write(fh, body)
		end)
	end
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/treecurve", style)

	for n=1,10 do
		writer(n)
	end
end
