--
--	from src/koch.c
--
--	void koch(void)		to	koch
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local koch = require 'koch'.koch
local with = require '_helper'.with

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	function body(plotter)
		plotter:pathStart()
		plotter:move(0, 0)
		koch(plotter, 1200, 0, 3)
		plotter:pathEnd(false, style)
	end

	with("results/koch-A.svg", "w", function (fh)
		svgPlot(1200, 360):write(fh, body)
	end)

	with("results/koch-B.svg", "w", function (fh)
		svgPlotWholeBuffer(1200, 360):write(fh, body):reset()
	end)

	with("results/koch-C.svg", "w", function (fh)
		svgPlotWithBuffer(1200, 360):write(fh, body)
	end)
end
