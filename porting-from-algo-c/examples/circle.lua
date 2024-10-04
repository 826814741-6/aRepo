--
--	from src/circle.c
--
--	void gr_circle(int, int, int, long)		to	BMP; :circle
--

local BMP = require 'grBMP'.BMP
local BLACK = require 'grBMP'.PRESET_COLORS.BLACK
local makeColor = require 'grBMP'.makeColor

local svgPlot = require 'svgplot'.svgPlot
local svgPlotWholeBuffer = require 'svgplot'.svgPlotWholeBuffer
local svgPlotWithBuffer = require 'svgplot'.svgPlotWithBuffer
local styleMaker = require 'svgplot'.styleMaker
local SV = require 'svgplot'.StyleValue

local ext = require 'basicshapes'.extensionForSvgPlot
local extForWhole = require 'basicshapes'.extensionForSvgPlotWholeBuffer
local extForWith = require 'basicshapes'.extensionForSvgPlotWithBuffer

local RAND = require 'rand'.RAND
local with = require '_helper'.with
local withPlotter = require '_helper'.withPlotter

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:clear(BLACK)

	local r = RAND()
	for _=1,100 do
		bmp:circle(
			r:rand() % x,
			r:rand() % y,
			r:rand() % 100,
			makeColor(r:randRaw() % (0xffffff + 1))
		)
	end

	with("results/circle.bmp", "wb", function (fh)
		bmp:write(fh)
	end)
end

function toRGB(n)
	return n >> 16, (n >> 8) & 0xFF, n & 0xFF
end

function sample(plotter, n, x, y, styleR, styleC)
	plotter:rect(0, 0, x, y, 0, 0, styleR)
	local r = RAND()
	for _=1,n do
		plotter:circle(
			r:rand() % x,
			r:rand() % y,
			r:rand() % 100,
			styleC:format(toRGB(r:randRaw() % (0xffffff + 1)))
		)
	end
end

do
	local n, x, y = 100, 640, 400

	local styleR, styleC =
		styleMaker()
			:fill(SV.Black)
			:get(),
		styleMaker()
			:fill(SV.Transparent)
			:stroke(SV.Raw("rgb(%d %d %d)"))
			:strokeWidth(1)
			:get()

	withPlotter(
		"results/circle.svg",
		ext(svgPlot(x, y))
	)(function (plotter)
		sample(plotter, n, x, y, styleR, styleC)
	end)

	do
		local plotter = extForWhole(svgPlotWholeBuffer(x, y))
		sample(plotter, n, x, y, styleR, styleC)
		with("results/circle-WB-A.svg", "w", function (fh)
			plotter:write(fh)
		end)
	end

	withPlotter(
		"results/circle-WB-B.svg",
		extForWith(svgPlotWithBuffer(x, y)),
		100
	)(function (plotter)
		sample(plotter, n, x, y, styleR, styleC)
	end)
end
