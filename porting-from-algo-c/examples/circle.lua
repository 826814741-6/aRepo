--
--	from src/circle.c
--
--	void gr_circle(int, int, int, long)		to	BMP; :circle
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

function toRGB(n)
	return n >> 16, (n >> 8) & 0xff, n & 0xff
end

function loop(instance, n, x, y, formatFunction)
	local r = RAND()
	for _=1,n do
		instance:circle(
			r:rand() % x,
			r:rand() % y,
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

	with("results/circle.bmp", "wb", function (fh)
		bmp:write(fh)
	end)

	local styleR, styleC =
		styleMaker()
			:fill(SV.Black)
			:get(),
		styleMaker()
			:fill(SV.Transparent)
			:stroke(SV.RawRGB)
			:strokeWidth(1)
			:get()
	local fmtC = function (n) return styleC:format(toRGB(n)) end

	function body(plotter)
		plotter:rect(0, 0, x, y, 0, 0, styleR)
		loop(plotter, n, x, y, fmtC)
	end

	with("results/circle-A.svg", "w", function (fh)
		svgPlotA(x, y):write(fh, body)
	end)
	with("results/circle-B.svg", "w", function (fh)
		svgPlotB(x, y):write(fh, body):reset()
	end)
	with("results/circle-C.svg", "w", function (fh)
		svgPlotC(x, y):write(fh, body)
	end)
end
