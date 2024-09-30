--
--	from src/line.c
--
--	void gr_line(int, int, int, int, long)		to	BMP; :line
--

local BMP = require 'grBMP'.BMP
local BLACK = require 'grBMP'.PRESET_COLORS.BLACK
local makeColor = require 'grBMP'.makeColor

local svgPlot = require 'svgplot'.svgPlot
local svgPlotWholeBuffer = require 'svgplot'.svgPlotWholeBuffer
local svgPlotWithBuffer = require 'svgplot'.svgPlotWithBuffer

local ext = require 'basicshapes'.extensionForSvgPlot
local extForWhole = require 'basicshapes'.extensionForSvgPlotWholeBuffer
local extForWith = require 'basicshapes'.extensionForSvgPlotWithBuffer
local makeStyle = require 'basicshapes'.makeStyle

local RAND = require 'rand'.RAND
local with = require '_helper'.with
local withPlt = require '_helper'.withPlt

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:clear(BLACK)

	local r = RAND()
	for _=1,100 do
		bmp:line(
			r:rand() % x,
			r:rand() % y,
			r:rand() % x,
			r:rand() % y,
			makeColor(r:randRaw() % (0xffffff + 1))
		)
	end

	with("results/line.bmp", "wb", function (fh)
		bmp:write(fh)
	end)
end

function toRGB(n)
	return n >> 16, (n >> 8) & 0xFF, n & 0xFF
end

function sample(plotter, n, x, y, styleR, styleL)
	plotter:rect(0, 0, x, y, 0, 0, styleR)
	local r = RAND()
	for _=1,n do
		plotter:line(
			r:rand() % x,
			r:rand() % y,
			r:rand() % x,
			r:rand() % y,
			styleL:format(toRGB(r:randRaw() % (0xffffff + 1)))
		)
	end
end

do
	local n, x, y = 100, 640, 400

	local styleR, styleL =
		makeStyle()
			:fill("black")
			:get(),
		makeStyle()
			:fill("transparent")
			:stroke("rgb(%d %d %d)")
			:strokeWidth(1)
			:get()

	withPlt("results/line.svg", ext(svgPlot(x, y)))
		(function (plotter)
			sample(plotter, n, x, y, styleR, styleL)
		end)

	do
		local plotter = extForWhole(svgPlotWholeBuffer(x, y))
		sample(plotter, n, x, y, styleR, styleL)
		with("results/line-WB-A.svg", "w", function (fh)
			plotter:write(fh)
		end)
	end

	withPlt("results/line-WB-B.svg", extForWith(svgPlotWithBuffer(x, y)), 100)
		(function (plotter)
			sample(plotter, n, x, y, styleR, styleL)
		end)
end
