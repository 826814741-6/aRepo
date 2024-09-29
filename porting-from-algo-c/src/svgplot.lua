--
--	from src/svgplot.c
--
--	void plot_start(int, int)		to	:plotStart, :pathStart
--	void plot_end(int)			to	:plotEnd, :pathEnd
--	void move(double, double)		to	:move
--	void move_rel(double, double)		to	:moveRel
--	void draw(double, double)		to	:draw
--	void draw_rel(double, double)		to	:drawRel
--
--	svgPlot,svgPlotWithBuffer		to	svgPlotWholeBuffer
--	:plotStart
--	:plotEnd
--							:reset
--							:write, :writeOneByOne
--

local function header(w, h)
	return ([[
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="%d" height="%d">
]]):format(w, h)
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

local function move(x, y)
	return ("M %g %g "):format(x, y)
end

local function moveRel(x, y)
	return ("m %g %g "):format(x, y)
end

local function draw(x, y)
	return ("L %g %g "):format(x, y)
end

local function drawRel(x, y)
	return ("l %g %g "):format(x, y)
end

--

local function svgPlot(width, height)
	local T = { fh = nil }

	function T:plotStart(fh)
		T.fh = fh ~= nil and fh or io.stdout
		T.fh:write(header(width, height))
		return T
	end

	function T:plotEnd()
		T.fh:write(footer())
		T.fh = nil
		return T
	end

	function T:pathStart()
		T.fh:write(pathStart())
		return T
	end

	function T:pathEnd(isClosePath)
		T.fh:write(pathEnd(isClosePath))
		return T
	end

	function T:move(x, y)
		T.fh:write(move(x, height - y))
		return T
	end

	function T:moveRel(x, y)
		T.fh:write(moveRel(x, -y))
		return T
	end

	function T:draw(x, y)
		T.fh:write(draw(x, height - y))
		return T
	end

	function T:drawRel(x, y)
		T.fh:write(drawRel(x, -y))
		return T
	end

	return T
end

local t_concat = table.concat
local t_insert = table.insert

local function svgPlotWholeBuffer(width, height)
	local T = {
		buffer = {}
	}

	function T:pathStart()
		t_insert(T.buffer, pathStart())
		return T
	end

	function T:pathEnd(isClosePath)
		t_insert(T.buffer, pathEnd(isClosePath))
		return T
	end

	function T:move(x, y)
		t_insert(T.buffer, move(x, height - y))
		return T
	end

	function T:moveRel(x, y)
		t_insert(T.buffer, moveRel(x, -y))
		return T
	end

	function T:draw(x, y)
		t_insert(T.buffer, draw(x, height - y))
		return T
	end

	function T:drawRel(x, y)
		t_insert(T.buffer, drawRel(x, -y))
		return T
	end

	function T:reset()
		T.buffer = {}
		return T
	end

	function T:write(fh)
		fh = fh ~= nil and fh or io.stdout

		fh:write(header(width, height))
		fh:write(t_concat(T.buffer))
		fh:write(footer())

		return T
	end

	function T:writeOneByOne(fh)
		fh = fh ~= nil and fh or io.stdout

		fh:write(header(width, height))
		for _,v in ipairs(T.buffer) do
			fh:write(v)
		end
		fh:write(footer())

		return T
	end

	return T
end

local function makeBuffer()
	local T = {
		buffer = {},
		counter = 0,
		limit = 1
	}

	function T:writer(fh, s)
		t_insert(T.buffer, s)

		T.counter = T.counter + 1
		if T.counter >= T.limit then
			fh:write(t_concat(T.buffer))
			T:reset()
		end
	end

	function T:reset()
		T.buffer, T.counter = {}, 0
	end

	function T:setLimit(limit)
		T.limit = limit ~= nil and limit or 1
	end

	function T:tailStep(fh)
		if #T.buffer > 0 then
			fh:write(t_concat(T.buffer))
		end
	end

	return T
end

local function svgPlotWithBuffer(width, height)
	local T = {
		fh = nil,
		buffer = makeBuffer()
	}

	function T:plotStart(fh, limit)
		T.buffer:reset()
		T.buffer:setLimit(limit)
		T.fh = fh ~= nil and fh or io.stdout
		T.fh:write(header(width, height))
		return T
	end

	function T:plotEnd()
		T.buffer:tailStep(T.fh)
		T.fh:write(footer())
		T.fh = nil
		T.buffer:setLimit()
		T.buffer:reset()
		return T
	end

	function T:pathStart()
		T.buffer:writer(T.fh, pathStart())
		return T
	end

	function T:pathEnd(isClosePath)
		T.buffer:writer(T.fh, pathEnd(isClosePath))
		return T
	end

	function T:move(x, y)
		T.buffer:writer(T.fh, move(x, height - y))
		return T
	end

	function T:moveRel(x, y)
		T.buffer:writer(T.fh, moveRel(x, -y))
		return T
	end

	function T:draw(x, y)
		T.buffer:writer(T.fh, draw(x, height - y))
		return T
	end

	function T:drawRel(x, y)
		T.buffer:writer(T.fh, drawRel(x, -y))
		return T
	end

	return T
end

return {
	svgPlot = svgPlot,
	svgPlotWholeBuffer = svgPlotWholeBuffer,
	svgPlotWithBuffer = svgPlotWithBuffer
}
