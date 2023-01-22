--
--	from src/koch.c
--
--	void koch(void)		to	koch
--

local M0 = require 'svgplot'
local M1 = require 'koch'

local svgPlot, koch = M0.svgPlot, M1.koch

function sampleWriter(path)
	local plotter = svgPlot(1200, 360)

	plotter:plotStart()
	plotter:move(0, 0)
	koch(plotter, 1200, 0, 3)
	plotter:plotEnd()

	local fh = io.open(path, "w")
	plotter:write(fh)
	fh:close()
end

do
	sampleWriter("results/koch.svg")
end
