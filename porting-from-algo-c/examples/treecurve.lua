--
--  from src/treecurv.c
--
--    void tree(int, double, double)  to  treeCurve
--

local M = require 'svgplot'

local SvgPlotA = M.SvgPlot
local SvgPlotB = M.SvgPlotWholeBuffer
local SvgPlotC = M.SvgPlotWithBuffer
local treeCurve = require 'treecurve'.treeCurve
local file = require '_helper'.file

local function sampleWriter(pathPrefix, style)
	local pltA, pltB, pltC =
		SvgPlotA(400, 350), SvgPlotB(400, 350), SvgPlotC(400, 350)

	return function (n)
		function body(plotter)
			plotter:pathStart()
			plotter:move(200, 0)
			treeCurve(plotter, n, 100, 0, 0.7, 0.5)
			plotter:pathEnd(false, M.SV.PRESET_PLAIN)
		end

		file(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			pltA:write(fh, body)
		end)

		file(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			pltB:write(fh, body):reset()
		end)

		file(("%s-C-%d.svg"):format(pathPrefix, n), "w", function (fh)
			pltC:write(fh, body)
		end)
	end
end

do
	local writer = sampleWriter("results/treecurve", style)

	for n=6,10,2 do
		writer(n)
	end
end
