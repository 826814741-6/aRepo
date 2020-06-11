--
--	from src/grBMP.c
--
--	void putbytes(FILE *, int, unsigned long)	to	NBWriter
--	void gr_dot(int, int, long)			to	BMP; :dot
--	void gr_clear(long)				to	BMP; :clear
--	void gr_BMP(char *)				to	BMP; :write
--

local M = require 'grBMP'

local BMP, PRESETCOLORS = M.BMP, M.PRESETCOLORS

do
	local x, y = 640, 400
	local bmp = BMP(x, y)

	bmp:rect(1, x//2, 1, y//2, PRESETCOLORS.GREEN)
	bmp:rect(x//2, x, 1, y//2, PRESETCOLORS.BLUE)
	bmp:rect(1, x//2, y//2, y, PRESETCOLORS.RED)
	bmp:rect(x//2, x, y//2, y, PRESETCOLORS.WHITE)

	local fh = io.open("results/grBMP.bmp", "w")
	bmp:write(fh)
	fh:close()
end
