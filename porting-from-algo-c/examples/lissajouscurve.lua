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

	plotter:plotStart()
	lissajousCurve(plotter, n, offset)
	plotter:plotEnd()

	local fh = io.open(path, "w")
	plotter:write(fh)
	fh:close()
end

do
	local n, offset = 300, 10
	sampleWriter("results/lissajouscurve.svg", n, offset)
end
