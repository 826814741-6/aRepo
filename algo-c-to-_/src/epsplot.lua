--
--	from src/epsplot.c
--
--	void plot_start(int, int)		to	epsPlot; :plotStart
--	void plot_end(int)			to	epsPlot; :plotEnd
--	void move(double, double)		to	epsPlot; :move
--	void move_rel(double, double)		to	epsPlot; :moveRel
--	void draw(double, double)		to	epsPlot; :draw
--	void draw_rel(double, double)		to	epsPlot; :drawRel
--

local function header(x, y)
	return ([[
%%!PS-Adobe-3.0 EPSF-3.0
%%%%BoundingBox: 0 0 %d %d
]]):format(x, y)
end

local function epsPlot(X, Y)
	local T = { fh = nil }

	function T:plotStart(fileHandler)
		T.fh = fileHandler ~= nil and fileHandler or io.stdout
		T.fh:write(header(X, Y), "newpath", "\n")
	end

	function T:plotEnd(isClosePath)
		T.fh:write(isClosePath and "closepath" or "", "\n", "stroke", "\n")
		T.fh = nil
	end

	function T:move(x, y)
		T.fh:write(("%g %g moveto"):format(x, y), "\n")
	end

	function T:moveRel(x, y)
		T.fh:write(("%g %g rmoveto"):format(x, y), "\n")
	end

	function T:draw(x, y)
		T.fh:write(("%g %g lineto"):format(x, y), "\n")
	end

	function T:drawRel(x, y)
		T.fh:write(("%g %g rlineto"):format(x, y), "\n")
	end

	return T
end

return {
	epsPlot = epsPlot
}
