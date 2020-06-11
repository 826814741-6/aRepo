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

local svgPlot, hilbert = M0.svgPlot, M1.hilbert

function sampleWriter(pathPrefix, n, offset)
	local plotter = svgPlot(n + offset, n + offset)

	function sample(fh, order)
		plotter:plotStart(fh)
		hilbert(plotter, order, n, offset)
		plotter:plotEnd()
	end

	return function (order)
		local fh = io.open(("%s%d.svg"):format(pathPrefix, order), "w")
		local ret = pcall(sample, fh, order)
		fh:close()
		assert(ret == true)
	end
end

do
	local writer = sampleWriter("results/hilbert", 600, 3)

	for order=1,8 do writer(order) end
end
