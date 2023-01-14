--
--	from src/svgplot.c
--
--	void plot_start(int, int)		to	svgPlot; :plotStart
--	void plot_end(int)			to	svgPlot; :plotEnd
--	void move(double, double)		to	svgPlot; :move
--	void move_rel(double, double)		to	svgPlot; :moveRel
--	void draw(double, double)		to	svgPlot; :draw
--	void draw_rel(double, double)		to	svgPlot; :drawRel
--

local function header(x, y)
	return ([[
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="%d" height="%d">]]):format(x, y)
end

local function footer()
	return "</svg>"
end

local function pathStart()
	return [[<path d="]]
end

local function pathEnd(isClosePath)
	return ([[%s" fill="none" stroke="black" />]]):format(isClosePath and "Z" or "")
end

local function svgPlot(X, Y)
	local T = { fh = nil }

	function T:plotStart(fileHandler)
		T.fh = fileHandler ~= nil and fileHandler or io.stdout
		T.fh:write(header(X, Y), "\n")
		T.fh:write(pathStart())
	end

	function T:plotEnd(isClosePath)
		T.fh:write(pathEnd(isClosePath), "\n")
		T.fh:write(footer(), "\n")
		T.fh = nil
	end

	function T:move(x, y)
		T.fh:write(("M %g %g "):format(x, Y - y))
	end

	function T:moveRel(x, y)
		T.fh:write(("m %g %g "):format(x, -y))
	end

	function T:draw(x, y)
		T.fh:write(("L %g %g "):format(x, Y - y))
	end

	function T:drawRel(x, y)
		T.fh:write(("l %g %g "):format(x, -y))
	end

	return T
end

return {
	svgPlot = svgPlot
}
