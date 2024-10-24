--
--	from src/hilbert.c
--
--	void rul(int)		to	hilbert; rul
--	void dlu(int)		to	hilbert; dlu
--	void ldr(int)		to	hilbert; ldr
--	void urd(int)		to	hilbert; urd
--

local function hilbert(plotter, order, n, offset)
	local rul, dlu, ldr, urd, h

	rul = function (i) -- RightUpLeft
		if i == 0 then return end
		urd(i - 1)
		plotter:drawRel(h, 0)
		rul(i - 1)
		plotter:drawRel(0, h)
		rul(i - 1)
		plotter:drawRel(-h, 0)
		dlu(i - 1)
	end

	dlu = function (i) -- DownLeftUp
		if i == 0 then return end
		ldr(i - 1)
		plotter:drawRel(0, -h)
		dlu(i - 1)
		plotter:drawRel(-h, 0)
		dlu(i - 1)
		plotter:drawRel(0, h)
		rul(i - 1)
	end

	ldr = function (i) -- LeftDownRight
		if i == 0 then return end
		dlu(i - 1)
		plotter:drawRel(-h, 0)
		ldr(i - 1)
		plotter:drawRel(0, -h)
		ldr(i - 1)
		plotter:drawRel(h, 0)
		urd(i - 1)
	end

	urd = function (i) -- UpRightDown
		if i == 0 then return end
		rul(i - 1)
		plotter:drawRel(0, h)
		urd(i - 1)
		plotter:drawRel(h, 0)
		urd(i - 1)
		plotter:drawRel(0, -h)
		ldr(i - 1)
	end

	h = n
	for _=2,order do
		h = h / (2 + h / n)
	end

	plotter:move(1 + offset // 2, 1)
	rul(order)
end

local mustBePlotter = require 'svgplot'.mustBePlotter

local function extension(T)
	mustBePlotter(T)
	function T:hilbert(order, n, offset)
		hilbert(T, order, n, offset)
		return T
	end
	return T
end

return {
	hilbert = hilbert,
	extension = extension
}
