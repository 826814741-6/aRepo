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
local extension = M1.extension
local with = H.with

do
	with("results/koch-A.svg", "w", function (fh)
		local plotter = svgPlot(1200, 360)
		plotter:plotStart(fh)
		plotter:move(0, 0)
		koch(plotter, 1200, 0, 3)
		plotter:plotEnd()
	end)

	with("results/koch-B.svg", "w", function (fh)
		extension(svgPlot(1200, 360))
			:plotStart(fh)
			:move(0, 0)
			:koch(1200, 0, 3)
			:plotEnd()
	end)
end
