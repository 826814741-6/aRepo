--
--	from src/ellipse.c
--
--	void gr_ellipse(int, int, int, int, long)	to	BMP; :ellipse
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

function loop(instance, n, x, y, formatFunction)
	local r = RAND()
	for _=1,n do
		instance:ellipse(
			r:rand() % x,
			r:rand() % y,
			r:rand() % 100,
			r:rand() % 100,
			formatFunction(r:randRaw() % (0xffffff + 1))
		)
	end
end

do
	local n, x, y = 100, 640, 400
	local bmp = BMP(x, y)

	bmp:clear(BLACK)
	loop(bmp, n, x, y, makeColor)

	with("results/ellipse.bmp", "wb", function (fh)
		bmp:write(fh)
	end)

	local pltA, pltB, pltC =
		withPlotter("results/ellipse-A.svg", svgPlotA(x, y)),
		withPlotter("results/ellipse-B.svg", svgPlotB(x, y)),
		withPlotter("results/ellipse-C.svg", svgPlotC(x, y))
	local styleR, styleE =
		styleMaker()
			:fill(SV.Black)
			:get(),
		styleMaker()
			:fill(SV.Transparent)
			:stroke(SV.RawRGB)
			:strokeWidth(1)
			:get()
	local fmtE = function (n) return styleE:format(toRGB(n)) end

	function body(plotter)
		plotter:rect(0, 0, x, y, 0, 0, styleR)
		loop(plotter, n, x, y, fmtE)
	end

	pltA(body)
	pltB(body)
	pltC(body)
end
