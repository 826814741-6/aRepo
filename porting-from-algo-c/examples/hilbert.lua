--
--	from src/hilbert.c
--
--	void rul(int)		to	hilbert; rul
--	void dlu(int)		to	hilbert; dlu
--	void ldr(int)		to	hilbert; ldr
--	void urd(int)		to	hilbert; urd
--

local M = require 'svgplot'

local svgPlot = M.svgPlot
local svgPlotWholeBuffer = M.svgPlotWholeBuffer
local svgPlotWithBuffer = M.svgPlotWithBuffer
local styleMaker = M.styleMaker
local SV = M.StyleValue
local hilbert = require 'hilbert'.hilbert
local with = require '_helper'.with

local function sampleWriter(pathPrefix, size, offset, style)
	local m = size + offset
	return function (n)
		function body(plotter)
			plotter:pathStart()
			hilbert(plotter, n, size, offset)
			plotter:pathEnd(false, style)
		end

		with(("%s-A-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlot(m, m):write(fh, body)
		end)

		with(("%s-B-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWholeBuffer(m, m):write(fh, body):reset()
		end)

		with(("%s-C-%d.svg"):format(pathPrefix, n), "w", function (fh)
			svgPlotWithBuffer(m, m):write(fh, body)
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
	local n = size + offset

	local A, B, C =
		svgPlot(n, n), svgPlotWholeBuffer(n, n), svgPlotWithBuffer(n, n)

	function body(plotter)
		plotter:pathStart()
		hilbert(plotter, 9, size, offset)
		plotter:pathEnd(false, style)
	end

	function getElapsedTime(path, plotter, limit) -- in a naive way
		local start = os.clock()
		with(path, "w", function (fh)
			plotter:write(fh, body, limit)
		end)
		return os.clock() - start
	end

	for _=1,3 do
		print("A:", getElapsedTime("results/hilbert-dummy-A.svg", A))
		print("B:", getElapsedTime("results/hilbert-dummy-B.svg", B))
		print("C50:", getElapsedTime("results/hilbert-dummy-C.svg", C))
		print("C20000:", getElapsedTime("results/hilbert-dummy-D.svg", C, 20000))
		--
		B:reset()
	end
end
--
-- Note:
--
-- > ("%d %g"):format(-0, -0)
-- 0 0
-- >
--
