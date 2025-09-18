--
--  from src/lissaj.c
--
--    a part of main  to  lissajousCurve
--

local M = require 'svgplot'

local SvgPlotA = M.SvgPlot
local SvgPlotB = M.SvgPlotWholeBuffer
local SvgPlotC = M.SvgPlotWithBuffer
local lissajousCurve = require 'lissajouscurve'.lissajousCurve
local file = require '_helper'.file

do
	local n, offset = 300, 10

	function body(plotter)
		plotter:pathStart()
		lissajousCurve(plotter, n, offset)
		plotter:pathEnd(false, M.SV.PRESET_PLAIN)
	end

	local m = (n + offset) * 2

	file("results/lissajouscurve-A.svg", "w", function (fh)
		SvgPlotA(m, m):write(fh, body)
	end)

	file("results/lissajouscurve-B.svg", "w", function (fh)
		SvgPlotB(m, m):write(fh, body):reset()
	end)

	file("results/lissajouscurve-C.svg", "w", function (fh)
		SvgPlotC(m, m):write(fh, body, 30)
	end)
end
