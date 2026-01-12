--
--  from src/grBMP.c
--
--    void gr_dot(int, int, long)                          to  BMP; :dot
--    void gr_clear(long)                                  to  BMP; :clear(, :rect)
--    void gr_BMP(char *)                                  to  BMP; :file(, :write)
--
--  from src/circle.c
--
--    void gr_circle(int, int, int, long)                  to  BMP; :circle
--
--  from src/ellipse.c
--
--    void gr_ellipse(int, int, int, int, long)            to  BMP; :ellipse
--
--  from src/line.c
--
--    void gr_line(int, int, int, int, long)               to  BMP; :line
--
--  from src/window.c
--
--    void gr_window(double, double, double, double, int)  to  BMP; :setWindow
--    void gr_wdot(double, double, long)                   to  BMP; :wdot
--    void gr_wline(double, double, double, double, long)  to  BMP; :wline
--

local H = require '_helper'

local getValueOrInit, isBool, isFh, mustBeNum =
	H.getValueOrInit, H.isBool, H.isFh, H.mustBeNum

local m_abs, m_floor = math.abs, math.floor

local function dot(bmp, x, y, color)
	if x >= 1 and x <= bmp.w and y >= 1 and y <= bmp.h then
		bmp.data[y][x] = color
	end
end

local function rect(bmp, lX, rX, lY, rY, color)
	for x=lX,rX do
		for y=lY,rY do
			dot(bmp, x, y, color)
		end
	end
end

local function clear(bmp, color)
	rect(bmp, 1, bmp.w, 1, bmp.h, color)
end

local function stepC(bmp, cX, cY, color, a, b, c, d)
	dot(bmp, cX + a, cY + b, color)
	dot(bmp, cX + a, cY - b, color)
	dot(bmp, cX - a, cY + b, color)
	dot(bmp, cX - a, cY - b, color)
	dot(bmp, cX + c, cY + d, color)
	dot(bmp, cX + c, cY - d, color)
	dot(bmp, cX - c, cY + d, color)
	dot(bmp, cX - c, cY - d, color)
end

local function circle(bmp, cX, cY, r, color)
	local x, y = r, 0
	while x >= y do
		stepC(bmp, cX, cY, color, x, y, y, x)
		r, y = r - (y * 2 + 1), y + 1
		if r <= 0 then
			x = x - 1
			r = r + x * 2
		end
	end
end

local function initE(bmp, cX, cY, rX, rY, color)
	if rX > rY then
		return rX, function (x, y)
			stepC(bmp, cX, cY, color,
			      x, m_floor(y * rY / rX), y, m_floor(x * rY / rX))
		end
	else
		return rY, function (x, y)
			stepC(bmp, cX, cY, color,
			      m_floor(x * rX / rY), y, m_floor(y * rX / rY), x)
		end
	end
end

local function ellipse(bmp, cX, cY, rX, rY, color)
	local x, step = initE(bmp, cX, cY, rX, rY, color)
	local r, y = x, 0
	while x >= y do
		step(x, y)
		r, y = r - (y * 2 + 1), y + 1
		if r <= 0 then
			x = x - 1
			r = r + x * 2
		end
	end
end

local function initL(x1, x2, y1, y2)
	local step
	if x1 > x2 then
		step = y1 > y2 and 1 or -1
		x1, x2, y1 = x2, x1, y2
	else
		step = y1 < y2 and 1 or -1
	end
	return step, x1, x2, y1
end

local function loopL(x1, x2, y1, y2, dX, dY, dotter)
	local step, a1, a2, b1 = initL(x1, x2, y1, y2)

	dotter(a1, b1)

	local t = m_floor(dX / 2)
	for a=a1+1,a2 do
		t = t - dY
		if t < 0 then
			t, b1 = t + dX, b1 + step
		end
		dotter(a, b1)
	end
end

local function line(bmp, x1, y1, x2, y2, color)
	local dX, dY = m_abs(x2 - x1), m_abs(y2 - y1)
	if dX > dY then
		loopL(x1, x2, y1, y2, dX, dY,
		      function (a, b) dot(bmp, a, b, color) end)
	else
		loopL(y1, y2, x1, x2, dY, dX,
		      function (a, b) dot(bmp, b, a, color) end)
	end
end

local function adjustX(bmp, x) return m_floor(bmp.xfac * x + bmp.xconst) end
local function adjustY(bmp, y) return m_floor(bmp.yfac * y + bmp.yconst) end

local function setWindow(bmp, left, right, top, bottom, isSquareWindow)
	isSquareWindow = getValueOrInit(isBool, isSquareWindow, false)

	bmp.xfac, bmp.yfac = bmp.w / (right - left), bmp.h / (top - bottom)
	if isSquareWindow then
		if m_abs(bmp.xfac) > m_abs(bmp.yfac) then
			bmp.xfac = bmp.xfac * m_abs(bmp.yfac / bmp.xfac)
		else
			bmp.yfac = bmp.yfac * m_abs(bmp.xfac / bmp.yfac)
		end
	end
	bmp.xconst, bmp.yconst = 0.5 - bmp.xfac * left, 0.5 - bmp.yfac * bottom
end

local function wDot(bmp, x, y, color)
	dot(bmp, adjustX(bmp, x), adjustY(bmp, y), color)
end

local function wLine(bmp, x1, y1, x2, y2, color)
	line(
		bmp,
		adjustX(bmp, x1), adjustY(bmp, y1),
		adjustX(bmp, x2), adjustY(bmp, y2),
		color
	)
end

local function file(self, path)
	local _, fh = pcall(io.open, path, "wb")
	assert(isFh(fh), "file(): Something wrong with your 'path'.")

	local ret, v = pcall(self.write, self, fh)
	fh:close()
	assert(ret == true, v)

	return self
end

local function gBMP(init)
	return function (width, height)
		mustBeNum(width) mustBeNum(height)

		local T = init(width, height)

		T.dot = dot
		T.rect = rect
		T.clear = clear
		T.circle = circle
		T.ellipse = ellipse
		T.line = line

		T.setWindow = setWindow
		T.wDot = wDot
		T.wLine = wLine

		T.file = file

		return T
	end
end

return {
	gBMP = gBMP
}
