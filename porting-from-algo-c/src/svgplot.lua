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
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="%d" height="%d">
]]):format(x, y)
end

local function footer()
	return [[</svg>
]]
end

local function pathStart()
	return [[<path d="]]
end

local function pathEnd(isClosePath)
	return ([[%s" fill="none" stroke="black" />
]]):format(isClosePath and "Z" or "")
end

local T_insert = table.insert

local function svgPlot(X, Y)
	local T = { buffer = {} }

	function T:plotStart()
		T_insert(T.buffer, header(X, Y))
		T_insert(T.buffer, pathStart())
	end

	function T:plotEnd(isClosePath)
		T_insert(T.buffer, pathEnd(isClosePath))
		T_insert(T.buffer, footer())
	end

	function T:move(x, y)
		T_insert(T.buffer, ("M %g %g "):format(x, Y - y))
	end

	function T:moveRel(x, y)
		T_insert(T.buffer, ("m %g %g "):format(x, -y))
	end

	function T:draw(x, y)
		T_insert(T.buffer, ("L %g %g "):format(x, Y - y))
	end

	function T:drawRel(x, y)
		T_insert(T.buffer, ("l %g %g "):format(x, -y))
	end

	function T:reset()
		T.buffer = {}
	end

	function T:write(fh)
		fh = fh ~= nil and fh or io.stdout
		for _,v in ipairs(T.buffer) do
			fh:write(v)
		end
	end

	return T
end

return {
	svgPlot = svgPlot
}
