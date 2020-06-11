--
--	from src/circle.c
--
--	void gr_circle(int, int, int, long)		to	BMP; :circle
--

local M = require 'grBMP'
local H = require 'rand'

local BMP, PRESETCOLORS = M.BMP, M.PRESETCOLORS
local RAND = H.RAND

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:clear(PRESETCOLORS.BLACK)

	local r = RAND()
	for _=1,100 do
		bmp:circle(
			r:rand() % x,
			r:rand() % y,
			r:rand() % 100,
			r:randRaw() % (PRESETCOLORS.WHITE + 1)
		)
	end

	local fh = io.open("results/circle.bmp", "w")
	bmp:write(fh)
	fh:close()
end
