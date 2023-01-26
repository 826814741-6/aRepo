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
local sierpinski = M1.sierpinski
local fileWriter = H.fileWriter

function sampleWriter(pathPrefix, size, offset)
	local plotter = svgPlot(size + offset, size + offset)

	return function (n)
		fileWriter(("%s%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			sierpinski(plotter, n, size)
			plotter:plotEnd(true)
		end)
	end
end

do
	local writer = sampleWriter("results/sierpinski", 600, 2)

	for n=1,6 do
		writer(n)
	end
end
