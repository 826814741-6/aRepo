--
--	from src/sierpin.c
--
--	void urd(int)			to	sierpinski; urd
--	void lur(int)			to	sierpinski; lur
--	void dlu(int)			to	sierpinski; dlu
--	void rdl(int)			to	sierpinski; rdl
--
--	from src/gasket.c
--
--	triangle and a part of main	to	sierpinskiGasket
--

local function sierpinski(plotter, order, n)
	local urd, lur, dlu, rdl, h

	urd = function (i) -- UpRightDown
		if i == 0 then return end
		urd(i - 1)
		plotter:drawRel(h, h)
		lur(i - 1)
		plotter:drawRel(2 * h, 0)
		rdl(i - 1)
		plotter:drawRel(h, -h)
		urd(i - 1)
	end

	lur = function (i) -- LeftUpRight
		if i == 0 then return end
		lur(i - 1)
		plotter:drawRel(-h, h)
		dlu(i - 1)
		plotter:drawRel(0, 2 * h)
		urd(i - 1)
		plotter:drawRel(h, h)
		lur(i - 1)
	end

	dlu = function (i) -- DownLeftUp
		if i == 0 then return end
		dlu(i - 1)
		plotter:drawRel(-h, -h)
		rdl(i - 1)
		plotter:drawRel(-2 * h, 0)
		lur(i - 1)
		plotter:drawRel(-h, h)
		dlu(i - 1)
	end

	rdl = function (i) -- RightDownLeft
		if i == 0 then return end
		rdl(i - 1)
		plotter:drawRel(h, -h)
		urd(i - 1)
		plotter:drawRel(0, -2 * h)
		dlu(i - 1)
		plotter:drawRel(-h, -h)
		rdl(i - 1)
	end

	h, n = 1, n // 6
	for _=2,order do
		h = 3 * h / (6 + h)
	end
	h = h * n

	plotter:move(h + 1, 1)
	urd(order)
	plotter:drawRel(h, h)
	lur(order)
	plotter:drawRel(-h, h)
	dlu(order)
	plotter:drawRel(-h, -h)
	rdl(order)
	plotter:drawRel(h, -h)
end

local mustBePlotter = require 'svgplot'.mustBePlotter

local function extension(T)
	mustBePlotter(T)
	function T:sierpinski(order, n)
		sierpinski(T, order, n)
		return T
	end
	return T
end

local function sierpinskiGasket(bmp, n, fgColor, bgColor)
	function triangle(i, j)
		bmp:wLine(i, j+1, i-1, j, fgColor)
		bmp:wLine(i-1, j, i+1, j, fgColor)
		bmp:wLine(i+1, j, i, j+1, fgColor)
	end

	bmp:clear(bgColor)
	bmp:setWindow(0, 2 * n, n, 0, true)

	local a, b = {}, {}
	for i=0,2*n do a[i] = false end
	a[n] = true

	for j=1,n-1 do
		for i=n-j,n+j do
			if a[i] == true then
				triangle(i, n - j)
			end
		end
		for i=n-j,n+j do
			b[i] = a[i - 1] ~= a[i + 1]
		end
		for i=n-j,n+j do
			a[i] = b[i]
		end
	end
end

return {
	sierpinski = sierpinski,
	extension = extension,
	sierpinskiGasket = sierpinskiGasket
}
