--
--  from src/circle.c
--
--    void gr_circle(int, int, int, long)   to   BMP; :circle
--
--  from src/svgplot.c
--
--    ... some extensions for basic shapes  are  :circle, :ellipse, :line, :rect
--

local BMP = require 'grBMP'.BMP
local BLACK = require 'grBMP'.PRESET_COLORS.BLACK
local makeColor = require 'grBMP'.makeColor

local SvgPlot = require 'svgplot'.SvgPlot
local SV = require 'svgplot'.SV

local RAND = require 'rand'.RAND
local file = require '_helper'.file

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

	file("results/circle.bmp", "wb", function (fh)
		bmp:write(fh)
	end)

	--

	local styleR, styleC = SV.PRESET_FillBLACK, SV.PRESET_RawRGB
	local fmtC = function (n) return styleC:format(toRGB(n)) end

	function body(plotter)
		plotter:rect(0, 0, x, y, 0, 0, styleR)
		loop(plotter, n, x, y, fmtC)
	end

	file("results/circle.svg", "w", function (fh)
		SvgPlot(x, y):write(fh, body)
	end)
end
