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

	function sample(fh, order)
		plotter:plotStart(fh)
		sierpinski(plotter, order, n)
		plotter:plotEnd(true)
	end

	return function (order)
		local fh = io.open(("%s%d.svg"):format(pathPrefix, order), "w")
		local ret = pcall(sample, fh, order)
		fh:close()
		assert(ret == true)
	end
end

do
	local writer = sampleWriter("results/sierpinski", 600, 2)

	for order=1,6 do writer(order) end
end
