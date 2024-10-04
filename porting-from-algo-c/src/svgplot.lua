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

local mustBeNum = require '_helper'.mustBeNum
local mustBeStr = require '_helper'.mustBeStr

local function header(w, h)
	return ([[
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="%d" height="%d">
]]):format(mustBeNum(w), mustBeNum(h))
end

local function footer()
	return [[</svg>
]]
end

local function pathStart()
	return [[<path d="]]
end

local function pathEnd(isClosePath, style)
	return ([[%s" %s />
]]):format(isClosePath and "Z" or "", mustBeStr(style))
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

local function mustBePlotter(T)
	assert(
		type(T.pathStart) == "function"
		and type(T.pathEnd) == "function"
		and type(T.move) == "function"
		and type(T.moveRel) == "function"
		and type(T.draw) == "function"
		and type(T.drawRel) == "function"
	)
	return T
end

local function mustBeSvgPlot(T)
	assert(
		type(T.buffer) == "nil"
		and type(T.plotStart) == "function"
		and type(T.plotEnd) == "function"
	)
	return mustBePlotter(T)
end

local function mustBeSvgPlotWholeBuffer(T)
	assert(
		type(T.buffer) == "table"
		and type(T.buffer.buffer) == "nil"
		and type(T.reset) == "function"
		and type(T.write) == "function"
		and type(T.writeOneByOne) == "function"
	)
	return mustBePlotter(T)
end

local function mustBeSvgPlotWithBuffer(T)
	assert(
		type(T.buffer) == "table"
		and type(T.buffer.buffer) == "table"
		and type(T.plotStart) == "function"
		and type(T.plotEnd) == "function"
	)
	return mustBePlotter(T)
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

	function T:pathEnd(isClosePath, style)
		T.fh:write(pathEnd(isClosePath, style))
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

	return mustBeSvgPlot(T)
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

	function T:pathEnd(isClosePath, style)
		t_insert(T.buffer, pathEnd(isClosePath, style))
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

	return mustBeSvgPlotWholeBuffer(T)
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

	function T:pathEnd(isClosePath, style)
		T.buffer:writer(T.fh, pathEnd(isClosePath, style))
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

	return mustBeSvgPlotWithBuffer(T)
end

--

local function styleMaker()
	local T = { buf = {}; attr = {} }

	function T:fill(sv)
		if T.attr.fill ~= true then
			T.attr.fill = true
			t_insert(
				T.buf,
				([[fill="%s"]]):format(mustBeStr(sv()))
			)
		end
		return T
	end

	function T:paintOrder(sv)
		if T.attr.paintOrder ~= true then
			T.attr.paintOrder = true
			t_insert(
				T.buf,
				([[paint-order="%s"]]):format(mustBeStr(sv()))
			)
		end
		return T
	end

	function T:stroke(sv)
		if T.attr.stroke ~= true then
			T.attr.stroke = true
			t_insert(
				T.buf,
				([[stroke="%s"]]):format(mustBeStr(sv()))
			)
		end
		return T
	end

	function T:strokeWidth(n)
		if T.attr.strokeWidth ~= true then
			T.attr.strokeWidth = true
			t_insert(
				T.buf,
				([[stroke-width="%d"]]):format(mustBeNum(n))
			)
		end
		return T
	end

	function T:get()
		return t_concat(T.buf, " ")
	end

	return T
end
--
-- ref:
-- https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Fills_and_Strokes
--

local StyleValue = {}

StyleValue.None = function () return "none" end
StyleValue.Transparent = function () return "transparent" end
StyleValue.Black = function () return "black" end
StyleValue.White = function () return "white" end
StyleValue.Raw = function (s) return function () return s end end

local m_floor, m_random = math.floor, math.random

StyleValue.RandomRGB = function ()
	local n = m_floor(m_random() * 0xffffff)
	return ("rgb(%d %d %d)"):format(n >> 16, (n >> 8) & 0xff, n & 0xff)
end

return {
	mustBePlotter = mustBePlotter,
	mustBeSvgPlot = mustBeSvgPlot,
	mustBeSvgPlotWholeBuffer = mustBeSvgPlotWholeBuffer,
	mustBeSvgPlotWithBuffer = mustBeSvgPlotWithBuffer,
	svgPlot = svgPlot,
	svgPlotWholeBuffer = svgPlotWholeBuffer,
	svgPlotWithBuffer = svgPlotWithBuffer,
	styleMaker = styleMaker,
	StyleValue = StyleValue
}
