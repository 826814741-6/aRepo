--
--  from src/ellipse.c
--
--    void gr_ellipse(int, int, int, int, long)  to   BMP; :ellipse
--
--  from src/svgplot.c
--
--    ... some extensions for basic shapes       are  :circle, :ellipse, :line, :rect
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
local file = require '_helper'.file

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

	file("results/ellipse.bmp", "wb", function (fh)
		bmp:write(fh)
	end)

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

	file("results/ellipse-A.svg", "w", function (fh)
		svgPlotA(x, y):write(fh, body)
	end)
	file("results/ellipse-B.svg", "w", function (fh)
		svgPlotB(x, y):write(fh, body):reset()
	end)
	file("results/ellipse-C.svg", "w", function (fh)
		svgPlotC(x, y):write(fh, body)
	end)
end
