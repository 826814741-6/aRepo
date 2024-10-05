--
--	from src/line.c
--
--	void gr_line(int, int, int, int, long)		to	BMP; :line
--

local BMP = require 'grBMP'.BMP
local BLACK = require 'grBMP'.PRESET_COLORS.BLACK
local makeColor = require 'grBMP'.makeColor

local svgPlotA = require 'svgplot'.svgPlot
local svgPlotB = require 'svgplot'.svgPlotWholeBuffer
local svgPlotC = require 'svgplot'.svgPlotWithBuffer
local styleMaker = require 'svgplot'.styleMaker
local SV = require 'svgplot'.StyleValue

local RAND = require 'rand'.RAND
local with = require '_helper'.with
local withPlotter = require '_helper'.withPlotter

function toRGB(n)
	return n >> 16, (n >> 8) & 0xff, n & 0xff
end

function loop(lineMethod, n, x, y, formatFunction)
	local r = RAND()
	for _=1,n do
		lineMethod(
			self,
			r:rand() % x,
			r:rand() % y,
			r:rand() % x,
			r:rand() % y,
			formatFunction(r:randRaw() % (0xffffff + 1))
		)
	end
end

do
	local n, x, y = 100, 640, 400
	local bmp = BMP(x, y)

	bmp:clear(BLACK)
	loop(bmp.line, n, x, y, makeColor)

	with("results/line.bmp", "wb", function (fh)
		bmp:write(fh)
	end)

	local pltA, pltB, pltC =
		withPlotter("results/line-A.svg", svgPlotA(x, y)),
		withPlotter("results/line-B.svg", svgPlotB(x, y)),
		withPlotter("results/line-C.svg", svgPlotC(x, y), 100)
	local styleR, styleL =
		styleMaker()
			:fill(SV.Black)
			:get(),
		styleMaker()
			:fill(SV.Transparent)
			:stroke(SV.RawRGB)
			:strokeWidth(1)
			:get()
	local fmtL = function (n) return styleL:format(toRGB(n)) end

	function body(plotter)
		plotter:rect(0, 0, x, y, 0, 0, styleR)
		loop(plotter.line, n, x, y, fmtL)
	end

	pltA(body)
	pltB(body)
	pltC(body)
end
