--
--  from src/koch.c
--
--    void koch(void)  to  koch
--

local M = require 'svgplot'

local SvgPlotA = M.SvgPlot
local SvgPlotB = M.SvgPlotWholeBuffer
local SvgPlotC = M.SvgPlotWithBuffer
local koch = require 'koch'.koch
local file = require '_helper'.file

do
	function body(plotter)
		plotter:pathStart()
		plotter:move(0, 0)
		koch(plotter, 1200, 0, 3)
		plotter:pathEnd(false, M.SV.PRESET_PLAIN)
	end

	file("results/koch-A.svg", "w", function (fh)
		SvgPlotA(1200, 360):write(fh, body)
	end)

	file("results/koch-B.svg", "w", function (fh)
		SvgPlotB(1200, 360):write(fh, body):reset()
	end)

	file("results/koch-C.svg", "w", function (fh)
		SvgPlotC(1200, 360):write(fh, body)
	end)
end
