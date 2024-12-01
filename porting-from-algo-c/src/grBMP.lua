--
--	from src/grBMP.c
--
--	void putbytes(FILE *, int, unsigned long)		to	(string.pack)
--	void gr_dot(int, int, long)				to	BMP; :dot
--	void gr_clear(long)					to	BMP; :clear
--	void gr_BMP(char *)					to	BMP; :write
--
--	from src/circle.c
--
--	void gr_circle(int, int, int, long)			to	BMP; :circle
--
--	from src/ellipse.c
--
--	void gr_ellipse(int, int, int, int, long)		to	BMP; :ellipse
--
--	from src/line.c
--
--	void gr_line(int, int, int, int, long)			to	BMP; :line
--
--	from src/window.c
--
--	void gr_window(double, double, double, double, int)	to	BMP; :setWindow
--	void gr_wdot(double, double, long)			to	BMP; :wdot
--	void gr_wline(double, double, double, double, long)	to	BMP; :wline
--

local getValueOrInit = require '_helper'.getValueOrInit
local isBool = require '_helper'.isBool

local t_unpack = table.unpack
local m_abs = math.abs
local m_floor = math.floor

local function BMP(X, Y)
	local T = {
		data = {},
		--
		xfac = 1,
		yfac = 1,
		xconst = 0,
		yconst = 0
	}

	for i=1,Y do
		T.data[i] = {}
	end

	function header(fh)
		fh:write(("<BBIIIIIIHHIIIIII"):pack(
			66, -- "B"
			77, -- "M"
			X * Y * 4 + 54,
			0,
			54,
			40,
			X,
			Y,
			1,
			32,
			0,
			X * Y * 4,
			3780,
			3780,
			0,
			0
		))
	end

	function body(fh)
		for y=1,Y do
			fh:write(t_unpack(T.data[y]))
		end
	end

	function inRange(x, y)
		return x >= 1 and x <= X and y >= 1 and y <= Y
	end

	function T:dot(x, y, color)
		if inRange(x, y) then
			T.data[y][x] = color
		end
	end

	function T:rect(lX, rX, lY, rY, color)
		for x=lX,rX do
			for y=lY,rY do
				T:dot(x, y, color)
			end
		end
	end

	function T:clear(color)
		T:rect(1, X, 1, Y, color)
	end

	function stepC(cX, cY, color, a, b, c, d)
		T:dot(cX + a, cY + b, color)
		T:dot(cX + a, cY - b, color)
		T:dot(cX - a, cY + b, color)
		T:dot(cX - a, cY - b, color)
		T:dot(cX + c, cY + d, color)
		T:dot(cX + c, cY - d, color)
		T:dot(cX - c, cY + d, color)
		T:dot(cX - c, cY - d, color)
	end

	function T:circle(cX, cY, r, color)
		local x, y = r, 0
		while x >= y do
			stepC(cX, cY, color, x, y, y, x)
			r, y = r - ((y << 1) + 1), y + 1
			if r <= 0 then
				x = x - 1
				r = r + (x << 1)
			end
		end
	end

	function initE(cX, cY, rX, rY, color)
		if rX > rY then
			return rX, function (x, y)
				stepC(cX, cY, color,
				      x, y * rY // rX, y, x * rY // rX)
			end
		else
			return rY, function (x, y)
				stepC(cX, cY, color,
				      x * rX // rY, y, y * rX // rY, x)
			end
		end
	end

	function T:ellipse(cX, cY, rX, rY, color)
		local x, step = initE(cX, cY, rX, rY, color)
		local r, y = x, 0
		while x >= y do
			step(x, y)
			r, y = r - ((y << 1) + 1), y + 1
			if r <= 0 then
				x = x - 1
				r = r + (x << 1)
			end
		end
	end

	function initL(x1, x2, y1, y2)
		local step
		if x1 > x2 then
			step = y1 > y2 and 1 or -1
			x1, x2, y1 = x2, x1, y2
		else
			step = y1 < y2 and 1 or -1
		end
		return step, x1, x2, y1
	end

	function loopL(x1, x2, y1, y2, dX, dY, dotter)
		local step, a1, a2, b1 = initL(x1, x2, y1, y2)

		dotter(a1, b1)

		local t = dX >> 1
		for a=a1+1,a2 do
			t = t - dY
			if t < 0 then
				t, b1 = t + dX, b1 + step
			end
			dotter(a, b1)
		end
	end

	function T:line(x1, y1, x2, y2, color)
		local dX, dY = m_abs(x2 - x1), m_abs(y2 - y1)
		if dX > dY then
			loopL(x1, x2, y1, y2, dX, dY,
			      function (a, b) T:dot(a, b, color) end)
		else
			loopL(y1, y2, x1, x2, dY, dX,
			      function (a, b) T:dot(b, a, color) end)
		end
	end

	function adjustX(x) return m_floor(T.xfac * x + T.xconst) end
	function adjustY(y) return m_floor(T.yfac * y + T.yconst) end

	function T:setWindow(left, right, top, bottom, isSquareWindow)
		isSquareWindow = getValueOrInit(isBool, isSquareWindow, false)

		T.xfac, T.yfac = X / (right - left), Y / (top - bottom)
		if isSquareWindow then
			if m_abs(T.xfac) > m_abs(T.yfac) then
				T.xfac = T.xfac * m_abs(T.yfac / T.xfac)
			else
				T.yfac = T.yfac * m_abs(T.xfac / T.yfac)
			end
		end
		T.xconst, T.yconst = 0.5 - T.xfac * left, 0.5 - T.yfac * bottom
	end

	function T:wDot(x, y, color)
		T:dot(adjustX(x), adjustY(y), color)
	end

	function T:wLine(x1, y1, x2, y2, color)
		T:line(adjustX(x1), adjustY(y1), adjustX(x2), adjustY(y2), color)
	end

	function T:write(fh)
		header(fh)
		body(fh)
	end

	return T
end

local function makeColor(rgb)
	return ("<I"):pack(rgb)
end

local PRESET_COLORS = {
	BLACK = ("<I"):pack(0x000000),
	WHITE = ("<I"):pack(0xffffff),
	RED   = ("<I"):pack(0xff0000),
	GREEN = ("<I"):pack(0x00ff00),
	BLUE  = ("<I"):pack(0x0000ff)
}

return {
	BMP = BMP,
	PRESET_COLORS = PRESET_COLORS,
	makeColor = makeColor
}
