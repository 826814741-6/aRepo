--
--  from src/grBMP.c
--
--    void putbytes(FILE *, int, unsigned long)  to  (string.pack)
--    void gr_BMP(char *)                        to  BMP; :file(, :write)
--

local gBMP = require 'grBMP_common'.gBMP

local t_unpack = table.unpack

local function write(bmp, fh)
	-- header
	fh:write(("<BBIIIIIIHHIIIIII"):pack(
		66, -- "B"
		77, -- "M"
		bmp.w * bmp.h * 4 + 54,
		0,
		54,
		40,
		bmp.w,
		bmp.h,
		1,
		32,
		0,
		bmp.w * bmp.h * 4,
		3780,
		3780,
		0,
		0
	))
	-- body
	for j=1,bmp.h do
		fh:write(t_unpack(bmp.data[j]))
	end
end

local function init(width, height)
	local T = {
		w = width,
		h = height,
		--
		data = {},
		xfac = 1,
		yfac = 1,
		xconst = 0,
		yconst = 0
	}

	for i=1,height do
		T.data[i] = {}
	end

	T.write = write

	return T
end

local function makeColor(rgb)
	return ("<I"):pack(rgb)
end

local PRESET_COLOR = {
	BLACK = ("<I"):pack(0x000000),
	WHITE = ("<I"):pack(0xffffff),
	RED   = ("<I"):pack(0xff0000),
	GREEN = ("<I"):pack(0x00ff00),
	BLUE  = ("<I"):pack(0x0000ff)
}

return {
	BMP = gBMP(init),
	PRESET_COLOR = PRESET_COLOR,
	makeColor = makeColor
}
