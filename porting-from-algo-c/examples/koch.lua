--
--	from src/koch.c
--
--	void koch(void)		to	koch
--

local M0 = require 'svgplot'
local M1 = require 'koch'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local koch = M1.koch
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	with("results/koch-A.svg", "w", function (fh)
		local plotter = svgPlot(1200, 360)
		plotter:plotStart(fh)
		plotter:pathStart()
		plotter:move(0, 0)
		koch(plotter, 1200, 0, 3)
		plotter:pathEnd(false, style)
		plotter:plotEnd()
	end)

	with("results/koch-B.svg", "w", function (fh)
		extension(svgPlot(1200, 360))
			:plotStart(fh)
			:pathStart()
			:move(0, 0)
			:koch(1200, 0, 3)
			:pathEnd(false, style)
			:plotEnd()
	end)

	withPlotter(
		"results/koch-C.svg",
		extension(svgPlot(1200, 360))
	)(function (plotter)
		plotter
			:pathStart()
			:move(0, 0)
			:koch(1200, 0, 3)
			:pathEnd(false, style)
	end)
end
