--
--  from src/sierpin.c
--
--    void urd(int)                to  sierpinski; urd
--    void lur(int)                to  sierpinski; lur
--    void dlu(int)                to  sierpinski; dlu
--    void rdl(int)                to  sierpinski; rdl
--

local M = require 'svgplot'

local SvgPlotA = M.SvgPlot
local SvgPlotB = M.SvgPlotWholeBuffer
local SvgPlotC = M.SvgPlotWithBuffer
local sierpinski = require 'sierpinski'.sierpinski
local file = require '_helper'.file

local function sampleWriter(pathPrefix, size, offset)
	local m = size + offset
	local pltA, pltB, pltC = SvgPlotA(m, m), SvgPlotB(m, m), SvgPlotC(m, m)

	return function (n)
		function body(plotter)
			plotter:pathStart()
			sierpinski(plotter, n, size)
			plotter:pathEnd(true, M.SV.PRESET_PLAIN)
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
	local writer = sampleWriter("results/sierpinski", 600, 2)

	for n=2,6,2 do
		writer(n)
	end
end
