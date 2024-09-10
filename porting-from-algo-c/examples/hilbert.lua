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
local hilbert = M1.hilbert
local extension = M1.extension
local with = H.with

function sampleWriter(pathPrefix, size, offset)
	local plotter = extension(svgPlot(size + offset, size + offset))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			hilbert(plotter, n, size, offset)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:hilbert(n, size, offset)
				:plotEnd()
		end)
	end
end

do
	local writer = sampleWriter("results/hilbert", 600, 3)

	for n=1,8 do
		writer(n)
	end
end
