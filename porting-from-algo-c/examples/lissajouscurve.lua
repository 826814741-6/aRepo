--
--	from src/lissaj.c
--
--	a part of main		to	lissajousCurve
--

local M0 = require 'svgplot'
local M1 = require 'lissajouscurve'

local svgPlot = M0.svgPlot
local lissajousCurve = M1.lissajousCurve

function sampleWriter(path, n, offset)
	local plotter = svgPlot((n + offset) * 2, (n + offset) * 2)

	function sample(fh)
		plotter:plotStart(fh)
		lissajousCurve(plotter, n, offset)
		plotter:plotEnd()
	end

	return function()
		local fh = io.open(path, "w")
		local ret = pcall(sample, fh)
		fh:close()
		assert(ret == true)
	end
end

do
	local n, offset = 300, 10

	local writer = sampleWriter("results/lissajouscurve.svg", n, offset)

	writer()
end
