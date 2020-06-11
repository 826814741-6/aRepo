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

	function sample(fh)
		plotter:plotStart(fh)
		plotter:move(0, 0)
		koch(plotter, 1200, 0, 3)
		plotter:plotEnd()
	end

	return function ()
		local fh = io.open(path, "w")
		local ret = pcall(sample, fh)
		fh:close()
		assert(ret == true)
	end
end

do
	local writer = sampleWriter("results/koch.svg")

	writer()
end
