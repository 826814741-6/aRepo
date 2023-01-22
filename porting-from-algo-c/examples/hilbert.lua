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

	function sample(order)
		plotter:reset()

		plotter:plotStart()
		hilbert(plotter, order, n, offset)
		plotter:plotEnd()
	end

	return function (n)
		sample(n)

		local fh = io.open(("%s%d.svg"):format(pathPrefix, n), "w")
		plotter:write(fh)
		fh:close()
	end
end

do
	local writer = sampleWriter("results/hilbert", 600, 3)

	for n=1,8 do writer(n) end
end
