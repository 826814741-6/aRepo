--
--	from src/svgplot.c
--
--	void plot_start(int, int)		to	:plotStart
--	void plot_end(int)			to	:plotEnd
--	void move(double, double)		to	:move
--	void move_rel(double, double)		to	:moveRel
--	void draw(double, double)		to	:draw
--	void draw_rel(double, double)		to	:drawRel
--
--	svgPlot,svgPlotWithBuffering		to	svgPlotWholeBuffering
--	:plotStart
--	:plotEnd				to	[:plotEnd]
--	:move					to	:move
--	:moveRel				to	:moveRel
--	:draw					to	:draw
--	:drawRel				to	:drawRel
--							:reset
--							:write, :writeOneByOne
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

local function svgPlot(X, Y)
	local T = { fh = nil }

	function T:plotStart(fh)
		T.fh = fh ~= nil and fh or io.stdout
		T.fh:write(header(X, Y))
		T.fh:write(pathStart())
	end

	function T:plotEnd(isClosePath)
		T.fh:write(pathEnd(isClosePath))
		T.fh:write(footer())
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

local T_concat = table.concat
local T_insert = table.insert

local function svgPlotWholeBuffering(X, Y)
	local T = {
		buffer = {},
		isClosePath = false
	}

	-- function T:plotStart()
	-- end

	function T:plotEnd(isClosePath)
		T.isClosePath = isClosePath
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

		fh:write(header(X, Y))
		fh:write(pathStart())
		fh:write(T_concat(T.buffer))
		fh:write(pathEnd(T.isClosePath))
		fh:write(footer())
	end

	function T:writeOneByOne(fh)
		fh = fh ~= nil and fh or io.stdout

		fh:write(header(X, Y))
		fh:write(pathStart())
		for _,v in ipairs(T.buffer) do
			fh:write(v)
		end
		fh:write(pathEnd(T.isClosePath))
		fh:write(footer())
	end

	return T
end

local function svgPlotWithBuffering(X, Y)
	local T = {
		fh = nil,
		buffer = {},
		counter = 0,
		limit = 1
	}

	function writer()
		T.counter = T.counter + 1
		if T.counter >= T.limit then
			T.fh:write(T_concat(T.buffer))
			reset()
		end
	end

	function reset()
		T.buffer, T.counter = {}, 0
	end

	function T:plotStart(fh, limit)
		reset()
		T.limit = limit ~= nil and limit or 1
		T.fh = fh ~= nil and fh or io.stdout
		T.fh:write(header(X, Y))
		T.fh:write(pathStart())
	end

	function T:plotEnd(isClosePath)
		if #T.buffer > 0 then
			T.fh:write(T_concat(T.buffer))
		end
		T.fh:write(pathEnd(isClosePath))
		T.fh:write(footer())
		T.fh, T.limit = nil, 1
		reset()
	end

	function T:move(x, y)
		T_insert(T.buffer, ("M %g %g "):format(x, Y - y))
		writer()
	end

	function T:moveRel(x, y)
		T_insert(T.buffer, ("m %g %g "):format(x, -y))
		writer()
	end

	function T:draw(x, y)
		T_insert(T.buffer, ("L %g %g "):format(x, Y - y))
		writer()
	end

	function T:drawRel(x, y)
		T_insert(T.buffer, ("l %g %g "):format(x, -y))
		writer()
	end

	return T
end

return {
	svgPlot = svgPlot,
	svgPlotWholeBuffering = svgPlotWholeBuffering,
	svgPlotWithBuffering = svgPlotWithBuffering
}
