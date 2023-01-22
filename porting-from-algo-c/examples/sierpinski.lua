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

local svgPlot = M0.svgPlot
local sierpinski = M1.sierpinski

function sampleWriter(pathPrefix, n, offset)
	local plotter = svgPlot(n + offset, n + offset)

	function sample(order)
		plotter:reset()

		plotter:plotStart()
		sierpinski(plotter, order, n)
		plotter:plotEnd(true)
	end

	return function (n)
		sample(n)

		local fh = io.open(("%s%d.svg"):format(pathPrefix, n), "w")
		plotter:write(fh)
		fh:close()
	end
end

do
	local writer = sampleWriter("results/sierpinski", 600, 2)

	for n=1,6 do writer(n) end
end
