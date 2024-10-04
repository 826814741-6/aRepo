--
--	from src/hilbert.c
--
--	void rul(int)		to	hilbert; rul
--	void dlu(int)		to	hilbert; dlu
--	void ldr(int)		to	hilbert; ldr
--	void urd(int)		to	hilbert; urd
--

local M0 = require 'svgplot'
local M1 = require 'hilbert'
local H = require '_helper'

local svgPlot = M0.svgPlot
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local hilbert = M1.hilbert
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

function sampleWriter(pathPrefix, size, offset, style)
	local plotter = extension(svgPlot(size + offset, size + offset))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			hilbert(plotter, n, size, offset)
			plotter:pathEnd(false, style)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:hilbert(n, size, offset)
				:pathEnd(false, style)
				:plotEnd()
		end)

		withPlotter(
			("%s-C-%d.svg"):format(pathPrefix, n),
			plotter
		)(function (plotter)
			plotter
				:pathStart()
				:hilbert(n, size, offset)
				:pathEnd(false, style)
		end)
	end
end

do
	local style = styleMaker()
		:fill(SV.None)
		:stroke(SV.Black)
		:get()

	local writer = sampleWriter("results/hilbert", 600, 3, style)

	for n=1,8 do
		writer(n)
	end
end
