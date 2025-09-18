--
--  from src/ccurve.c
--
--    void c(int, double, double)  to  cCurve
--

local M = require 'svgplot'

local SvgPlotA = M.SvgPlot
local SvgPlotB = M.SvgPlotWholeBuffer
local SvgPlotC = M.SvgPlotWithBuffer
local cCurve = require 'ccurve'.cCurve
local file = require '_helper'.file

local function sampleWriter(pathPrefix)
	local pltA, pltB, pltC =
		SvgPlotA(400, 250), SvgPlotB(400, 250), SvgPlotC(400, 250)

	return function (n)
		function body(plotter)
			plotter:pathStart()
			plotter:move(100, 200)
			cCurve(plotter, n, 200, 0)
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
	local writer = sampleWriter("results/ccurve")

	for n=6,10,2 do
		writer(n)
	end
end
