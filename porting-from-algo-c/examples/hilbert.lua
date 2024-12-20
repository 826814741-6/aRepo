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
local svgPlotWholeBuffer = M0.svgPlotWholeBuffer
local svgPlotWithBuffer = M0.svgPlotWithBuffer
local styleMaker = M0.styleMaker
local SV = M0.StyleValue
local hilbert = M1.hilbert
local extension = M1.extension
local with = H.with
local withPlotter = H.withPlotter

function sampleWriter(pathPrefix, size, offset, style)
	local plotter = extension(svgPlot(size + offset, size + offset))

	return function (n)
		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter:plotStart(fh)
			plotter:pathStart()
			hilbert(plotter, n, size, offset)
			plotter:pathEnd(false, style)
			plotter:plotEnd()
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			plotter
				:plotStart(fh)
				:pathStart()
				:hilbert(n, size, offset)
				:pathEnd(false, style)
				:plotEnd()
		end)

		withPlotter(
			("%s-C-%d.svg"):format(pathPrefix, n),
			plotter
		)(function (plotter)
			plotter
				:pathStart()
				:hilbert(n, size, offset)
				:pathEnd(false, style)
		end)
	end
end

local style = styleMaker()
	:fill(SV.None)
	:stroke(SV.Black)
	:get()

do
	local writer = sampleWriter("results/hilbert", 600, 3, style)

	for n=1,8 do
		writer(n)
	end
end

do
	local size, offset = 1000, 3

	local pltB = extension(svgPlotWholeBuffer(size + offset, size + offset))
	local wpA, wpB, wpC50, wpC20000 =
		withPlotter(
			"results/hilbert-dummy-A.svg",
			extension(svgPlot(size + offset, size + offset))
		),
		withPlotter(
			"results/hilbert-dummy-B.svg",
			pltB
		),
		withPlotter(
			"results/hilbert-dummy-C.svg",
			extension(svgPlotWithBuffer(size + offset, size + offset))
		),
		withPlotter(
			"results/hilbert-dummy-D.svg",
			extension(svgPlotWithBuffer(size + offset, size + offset)),
			20000
		)

	function body(plotter)
		plotter
			:pathStart()
			:hilbert(9, size, offset)
			:pathEnd(false, style)
	end

	function getElapsedTime(wp) -- in a naive way
		local start = os.clock()
		wp(body)
		return os.clock() - start
	end

	for _=1,3 do
		print("A:", getElapsedTime(wpA))
		print("B:", getElapsedTime(wpB))
		print("C50:", getElapsedTime(wpC50))
		print("C20000:", getElapsedTime(wpC20000))
		--
		pltB:reset()
	end
end
--
-- Note:
--
-- > ("%d %g"):format(-0, -0)
-- 0 0
-- >
--
