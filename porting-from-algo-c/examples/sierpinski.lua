--
--	from src/sierpin.c
--
--	void urd(int)		to	sierpinski; urd
--	void lur(int)		to	sierpinski; lur
--	void dlu(int)		to	sierpinski; dlu
--	void rdl(int)		to	sierpinski; rdl
--

local M0 = require 'svgplot'
local M1 = require 'sierpinski'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local sierpinski = M1.sierpinski
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

function sampleWriter(pathPrefix, size, offset, style)
	local plotter = extension(svgPlot(size + offset, size + offset))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			sierpinski(plotter, n, size)
			plotter:pathEnd(true, style)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:sierpinski(n, size)
				:pathEnd(true, style)
				:plotEnd()
		end)

		withPlotter(
			("%s-C-%d.svg"):format(pathPrefix, n),
			plotter
		)(function (plotter)
			plotter
				:pathStart()
				:sierpinski(n, size)
				:pathEnd(true, style)
		end)
	end
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/sierpinski", 600, 2, style)

	for n=1,6 do
		writer(n)
	end
end
