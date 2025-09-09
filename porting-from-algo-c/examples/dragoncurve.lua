--
--  from src/dragon2.c
--
--    a part of main                         to  dragonCurve
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local dragonCurve = require 'dragoncurve'.dragonCurve
local file = require '_helper'.file

local function sampleWriter(pathPrefix, x, y, x0, y0, style)
	return function (n)
		function body(plotter)
			plotter:pathStart()
			dragonCurve(plotter, n, x0, y0)
			plotter:pathEnd(false, style)
		end

		file(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlot(x, y):write(fh, body)
		end)

		file(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWholeBuffer(x, y):write(fh, body):reset()
		end)

		file(("%s-C-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWithBuffer(x, y):write(fh, body)
		end)
	end
end

do
	local x, y, x0, y0 = 510, 350, 120, 120
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/dragoncurve", x, y, x0, y0, style)

	for n=1,10 do
		writer(n)
	end
end
