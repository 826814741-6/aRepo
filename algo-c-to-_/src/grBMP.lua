--
--	from src/grBMP.c
--
--	void putbytes(FILE *, int, unsigned long)		to	NBWriter
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

local H = require '_helper'

local readOnlyTable = H.readOnlyTable
local unpack = table.unpack
local abs = math.abs
local floor = math.floor

local function NBWriter(n)
	local fmt, t = ("B"):rep(n), {}
	return function (fh, x)
		for i=1,n do t[i], x = x & 255, x >> 8 end
		fh:write(fmt:pack(unpack(t)))
	end
end

local write2B = NBWriter(2)
local write4B = NBWriter(4)

local function BMP(X, Y)
	local T = {
		data = {},
		--
		xfac = 1,
		yfac = 1,
		xconst = 0,
		yconst = 0
	}

	function header(fh)
		fh:write("BM")
		write4B(fh, X * Y * 4 + 54)
		write4B(fh, 0)
		write4B(fh, 54)
		write4B(fh, 40)
		write4B(fh, X)
		write4B(fh, Y)
		write2B(fh, 1)
		write2B(fh, 32)
		write4B(fh, 0)
		write4B(fh, X * Y * 4)
		write4B(fh, 3780)
		write4B(fh, 3780)
		write4B(fh, 0)
		write4B(fh, 0)
	end

	function body(fh)
		for y=1,Y do
			for x=1,X do
				-- assert(T.data[y][x] ~= nil, ("data[%d][%d] is nil"):format(y, x))
				write4B(fh, T.data[y][x])
			end
		end
	end

	function inRange(x, y)
		return x >= 1 and x <= X and y >= 1 and y <= Y
	end

	function T:dot(x, y, color)
		if inRange(x, y) then
			if T.data[y] == nil then T.data[y] = {} end
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

	function T:circle(cX, cY, r, color)
		local x, y = r, 0
		while x >= y do
			T:dot(cX + x, cY + y, color)
			T:dot(cX + x, cY - y, color)
			T:dot(cX - x, cY + y, color)
			T:dot(cX - x, cY - y, color)
			T:dot(cX + y, cY + x, color)
			T:dot(cX + y, cY - x, color)
			T:dot(cX - y, cY + x, color)
			T:dot(cX - y, cY - x, color)
			r, y = r - ((y << 1) + 1), y + 1
			if r <= 0 then
				x = x - 1
				r = r + (x << 1)
			end
		end
	end

	function T:ellipse(cX, cY, rX, rY, color)
		local step = (function ()
			function _step(a, b, c, d)
				T:dot(cX + a, cY + b, color)
				T:dot(cX + a, cY - b, color)
				T:dot(cX - a, cY + b, color)
				T:dot(cX - a, cY - b, color)
				T:dot(cX + c, cY + d, color)
				T:dot(cX + c, cY - d, color)
				T:dot(cX - c, cY + d, color)
				T:dot(cX - c, cY - d, color)
			end
			return rX > rY and function (x, y)
				_step(x, y * rY // rX, y, x * rY // rX)
			end or function (x, y)
				_step(x * rX // rY, y, y * rX // rY, x)
			end
		end)()

		local x = rX > rY and rX or rY
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

	function T:line(x1, y1, x2, y2, color)
		function loop(a1, a2, b1, b2, dA, dB, dotter)
			local step
			if a1 > a2 then
				step = b1 > b2 and 1 or -1
				a1, a2, b1 = a2, a1, b2
			else
				step = b1 < b2 and 1 or -1
			end

			dotter(a1, b1)

			local t = dA >> 1
			for a=a1+1,a2 do
				t = t - dB
				if t < 0 then
					t, b1 = t + dA, b1 + step
				end
				dotter(a, b1)
			end
		end

		local dX, dY = abs(x2 - x1), abs(y2 - y1)

		if dX > dY then
			loop(x1, x2, y1, y2, dX, dY, function (a,b) T:dot(a,b,color) end)
		else
			loop(y1, y2, x1, x2, dY, dX, function (a,b) T:dot(b,a,color) end)
		end
	end

	function adjustX(x) return floor(T.xfac * x + T.xconst) end
	function adjustY(y) return floor(T.yfac * y + T.yconst) end

	function T:setWindow(left, right, top, bottom, isSquareWindow)
		isSquareWindow = isSquareWindow ~= nil and isSquareWindow or false

		T.xfac, T.yfac = X / (right - left), Y / (top - bottom)
		if isSquareWindow then
			if abs(T.xfac) > abs(T.yfac) then
				T.xfac = T.xfac * abs(T.yfac / T.xfac)
			else
				T.yfac = T.yfac * abs(T.xfac / T.yfac)
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

local PRESETCOLORS = readOnlyTable({
	BLACK = 0x000000,
	WHITE = 0xffffff,
	RED   = 0xff0000,
	GREEN = 0x00ff00,
	BLUE  = 0x0000ff
})

return {
	BMP = BMP,
	PRESETCOLORS = PRESETCOLORS
}
