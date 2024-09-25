--
--	from src/ellipse.c
--
--	void gr_ellipse(int, int, int, int, long)	to	BMP; :ellipse
--

local BMP = require 'grBMP'.BMP
local BLACK = require 'grBMP'.PRESET_COLORS.BLACK
local makeColor = require 'grBMP'.makeColor

local svgPlot = require 'svgplot'.svgPlot
local extension = require 'basicshapes'.extensionForSvgPlot
local makeStyle = require 'basicshapes'.makeStyle

local RAND = require 'rand'.RAND
local with = require '_helper'.with

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:clear(BLACK)

	local r = RAND()
	for _=1,100 do
		bmp:ellipse(
			r:rand() % x,
			r:rand() % y,
			r:rand() % 100,
			r:rand() % 100,
			makeColor(r:randRaw() % (0xffffff + 1))
		)
	end

	with("results/ellipse.bmp", "wb", function (fh)
		bmp:write(fh)
	end)
end

do
	local styleR, styleE =
		makeStyle()
			:fill("black")
			:get(),
		makeStyle()
			:fill("transparent")
			:stroke("rgb(%d %d %d)")
			:strokeWidth(1)
			:get()

	function toRGB(n)
		return n >> 16, (n >> 8) & 0xFF, n & 0xFF
	end

	with("results/ellipse.svg", "w", function (fh)
		local x, y = 640, 400
		local plotter = extension(svgPlot(x, y))

		plotter:plotStart(fh)

		plotter:rect(0, 0, x, y, 0, 0, styleR)

		local r = RAND()
		for _=1,100 do
			plotter:ellipse(
				r:rand() % x,
				r:rand() % y,
				r:rand() % 100,
				r:rand() % 100,
				styleE:format(toRGB(r:randRaw() % (0xffffff + 1)))
			)
		end

		plotter:plotEnd()
	end)
end
