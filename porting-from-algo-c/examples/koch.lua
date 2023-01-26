--
--	from src/koch.c
--
--	void koch(void)		to	koch
--

local M0 = require 'svgplot'
local M1 = require 'koch'
local H = require '_helper'

local svgPlot = M0.svgPlot
local koch = M1.koch
local fileWriter = H.fileWriter

do
	fileWriter("results/koch.svg", "w", function (fh)
		local plotter = svgPlot(1200, 360)
		plotter:plotStart(fh)
		plotter:move(0, 0)
		koch(plotter, 1200, 0, 3)
		plotter:plotEnd()
	end)
end
