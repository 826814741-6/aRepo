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
--
--	:plotStart
--	:plotEnd
--							:reset
--							:write, :writeOneByOne
--
--	and some extensions for basic shapes	are	:circle, :ellipse, :line, :rect
--

local H = require '_helper'

local isFh, isFun, isNum, isStr, isTbl = H.isFh, H.isFun, H.isNum, H.isStr, H.isTbl
local mustBeBool, mustBeNum, mustBeStr = H.mustBeBool, H.mustBeNum, H.mustBeStr

local t_concat = table.concat
local t_insert = table.insert

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

local function pathEnd(isClosePath, style)
	return ([[%s" %s />
]]):format(mustBeBool(isClosePath) and "Z" or "", mustBeStr(style))
end

local function gMove(height)
	return function (x, y)
		return ("M %g %g "):format(x, height - y)
	end
end

local function moveRel(x, y)
	return ("m %g %g "):format(x, -y)
end

local function gDraw(height)
	return function (x, y)
		return ("L %g %g "):format(x, height - y)
	end
end

local function drawRel(x, y)
	return ("l %g %g "):format(x, -y)
end

local function circle(cx, cy, r, style)
	return ([[<circle cx="%g" cy="%g" r="%g" %s/>
]]):format(cx, cy, r, isStr(style) and style or "")
end

local function ellipse(cx, cy, rx, ry, style)
	return ([[<ellipse cx="%g" cy="%g" rx="%g" ry="%g" %s/>
]]):format(cx, cy, rx, ry, isStr(style) and style or "")
end

local function line(x1, y1, x2, y2, style)
	return ([[<line x1="%g" y1="%g" x2="%g" y2="%g" %s/>
]]):format(x1, y1, x2, y2, isStr(style) and style or "")
end

local function rect(x, y, w, h, rx, ry, style)
	return ([[<rect x="%g" y="%g" width="%g" height="%g" rx="%g" ry="%g" %s/>
]]):format(x, y, w, h, rx, ry, isStr(style) and style or "")
end

--

local function mustBePlotter(T)
	assert(
		isFun(T.pathStart)
		and isFun(T.pathEnd)
		and isFun(T.move)
		and isFun(T.moveRel)
		and isFun(T.draw)
		and isFun(T.drawRel)
		--
		and isFun(T.circle)
		and isFun(T.ellipse)
		and isFun(T.line)
		and isFun(T.rect)
	)
	return T
end

local function mustBeSvgPlot(T)
	assert(
		T.buffer == nil
		--
		and isFun(T.plotStart)
		and isFun(T.plotEnd)
	)
	return mustBePlotter(T)
end

local function mustBeSvgPlotWholeBuffer(T)
	assert(
		isTbl(T.buffer)
		and T.buffer.buffer == nil
		--
		and isFun(T.reset)
		and isFun(T.write)
		and isFun(T.writeOneByOne)
	)
	return mustBePlotter(T)
end

local function mustBeSvgPlotWithBuffer(T)
	assert(
		isTbl(T.buffer)
		and isTbl(T.buffer.buffer)
		--
		and isFun(T.plotStart)
		and isFun(T.plotEnd)
	)
	return mustBePlotter(T)
end

local function assertInitialValue(w, h)
	assert(isNum(w), "'width' must be a number.")
	assert(isNum(h), "'height' must be a number.")
end

--
-- local function makeMethod(fmt)
-- 	return function (self, ...)
-- 		self.fh:write(fmt(...))
-- 		return self
-- 	end
-- end
--
-- local function makeMethodForWhole(fmt)
-- 	return function (self, ...)
-- 		t_insert(self.buffer, fmt(...))
-- 		return self
-- 	end
-- end
--
-- local function makeMethodForWith(fmt)
-- 	return function (self, ...)
-- 		self.buffer:writer(fmt(...))
-- 		return self
-- 	end
-- end
--
-- Note:
-- Although variadic functions have some overhead compared to non-variadic
-- functions, the three utility functions above can be useful in implementing
-- each method during prototyping.
--

--

local function svgPlot(width, height)
	assertInitialValue(width, height)

	local T = { fh = nil }

	function T:plotStart(fh)
		T.fh = isFh(fh) and fh or io.stdout
		T.fh:write(header(width, height))
		return T
	end

	function T:plotEnd()
		T.fh:write(footer())
		T.fh = nil
		return T
	end

	--

	function T:pathStart()
		T.fh:write(pathStart())
		return T
	end

	function T:pathEnd(isClosePath, style)
		T.fh:write(pathEnd(isClosePath, style))
		return T
	end

	local move, draw = gMove(height), gDraw(height)

	function T:move(x, y)
		T.fh:write(move(x, y))
		return T
	end

	function T:moveRel(x, y)
		T.fh:write(moveRel(x, y))
		return T
	end

	function T:draw(x, y)
		T.fh:write(draw(x, y))
		return T
	end

	function T:drawRel(x, y)
		T.fh:write(drawRel(x, y))
		return T
	end

	function T:circle(cx, cy, r, style)
		T.fh:write(circle(cx, cy, r, style))
		return T
	end

	function T:ellipse(cx, cy, rx, ry, style)
		T.fh:write(ellipse(cx, cy, rx, ry, style))
		return T
	end

	function T:line(x1, y1, x2, y2, style)
		T.fh:write(line(x1, y1, x2, y2, style))
		return T
	end

	function T:rect(x, y, w, h, rx, ry, style)
		T.fh:write(rect(x, y, w, h, rx, ry, style))
		return T
	end

	return mustBeSvgPlot(T)
end

local function svgPlotWholeBuffer(width, height)
	assertInitialValue(width, height)

	local T = {
		buffer = {}
	}

	function T:reset()
		T.buffer = {}
		return T
	end

	function T:write(fh)
		fh = isFh(fh) and fh or io.stdout

		fh:write(header(width, height))
		fh:write(t_concat(T.buffer))
		fh:write(footer())

		return T
	end

	function T:writeOneByOne(fh)
		fh = isFh(fh) and fh or io.stdout

		fh:write(header(width, height))
		for _,v in ipairs(T.buffer) do
			fh:write(v)
		end
		fh:write(footer())

		return T
	end

	--

	function T:pathStart()
		t_insert(T.buffer, pathStart())
		return T
	end

	function T:pathEnd(isClosePath, style)
		t_insert(T.buffer, pathEnd(isClosePath, style))
		return T
	end

	local move, draw = gMove(height), gDraw(height)

	function T:move(x, y)
		t_insert(T.buffer, move(x, y))
		return T
	end

	function T:moveRel(x, y)
		t_insert(T.buffer, moveRel(x, y))
		return T
	end

	function T:draw(x, y)
		t_insert(T.buffer, draw(x, y))
		return T
	end

	function T:drawRel(x, y)
		t_insert(T.buffer, drawRel(x, y))
		return T
	end

	function T:circle(cx, cy, r, style)
		t_insert(T.buffer, circle(cx, cy, r, style))
		return T
	end

	function T:ellipse(cx, cy, rx, ry, style)
		t_insert(T.buffer, ellipse(cx, cy, rx, ry, style))
		return T
	end

	function T:line(x1, y1, x2, y2, style)
		t_insert(T.buffer, line(x1, y1, x2, y2, style))
		return T
	end

	function T:rect(x, y, w, h, rx, ry, style)
		t_insert(T.buffer, rect(x, y, w, h, rx, ry, style))
		return T
	end

	return mustBeSvgPlotWholeBuffer(T)
end

local DefaultLimit = 50

local function makeBuffer()
	local T = {
		buffer = {},
		counter = 0,
		fh = nil,
		limit = DefaultLimit
	}

	function T:writer(s)
		t_insert(T.buffer, s)

		T.counter = T.counter + 1
		if T.counter >= T.limit then
			T.fh:write(t_concat(T.buffer))
			T:reset()
		end
	end

	function T:reset()
		T.buffer, T.counter = {}, 0
	end

	function T:startStep(fh, limit)
		T:reset()
		T.fh = isFh(fh) and fh or io.stdout
		T.limit = isNum(limit) and limit or DefaultLimit
	end

	function T:endStep()
		if #T.buffer > 0 then
			T.fh:write(t_concat(T.buffer))
		end
		T.fh = nil
		T:reset()
	end

	return T
end

local function svgPlotWithBuffer(width, height)
	assertInitialValue(width, height)

	local T = {
		buffer = makeBuffer()
	}

	function T:plotStart(fh, limit)
		T.buffer:startStep(fh, limit)
		T.buffer:writer(header(width, height))
		return T
	end

	function T:plotEnd()
		T.buffer:writer(footer())
		T.buffer:endStep()
		return T
	end

	--

	function T:pathStart()
		T.buffer:writer(pathStart())
		return T
	end

	function T:pathEnd(isClosePath, style)
		T.buffer:writer(pathEnd(isClosePath, style))
		return T
	end

	local move, draw = gMove(height), gDraw(height)

	function T:move(x, y)
		T.buffer:writer(move(x, y))
		return T
	end

	function T:moveRel(x, y)
		T.buffer:writer(moveRel(x, y))
		return T
	end

	function T:draw(x, y)
		T.buffer:writer(draw(x, y))
		return T
	end

	function T:drawRel(x, y)
		T.buffer:writer(drawRel(x, y))
		return T
	end

	function T:circle(cx, cy, r, style)
		T.buffer:writer(circle(cx, cy, r, style))
		return T
	end

	function T:ellipse(cx, cy, rx, ry, style)
		T.buffer:writer(ellipse(cx, cy, rx, ry, style))
		return T
	end

	function T:line(x1, y1, x2, y2, style)
		T.buffer:writer(line(x1, y1, x2, y2, style))
		return T
	end

	function T:rect(x, y, w, h, rx, ry, style)
		T.buffer:writer(rect(x, y, w, h, rx, ry, style))
		return T
	end

	return mustBeSvgPlotWithBuffer(T)
end

--

local function makeSVMethod(s)
	local fmt = ([[%s="%%s"]]):format(mustBeStr(s))
	return function (self, sv)
		if self.attr[s] ~= true then
			self.attr[s] = true
			t_insert(
				self.buf,
				fmt:format(mustBeStr(sv()))
			)
		end
		return self
	end
end

local function makeRawNumMethod(s)
	local fmt = ([[%s="%%g"]]):format(mustBeStr(s))
	return function (self, v)
		if self.attr[s] ~= true then
			self.attr[s] = true
			t_insert(
				self.buf,
				fmt:format(mustBeNum(v))
			)
		end
		return self
	end
end

local function styleMaker()
	local T = { buf = {}; attr = {} }

	function T:get()
		return t_concat(T.buf, " ")
	end

	T.fill = makeSVMethod("fill")
	T.paintOrder = makeSVMethod("paint-order")
	T.stroke = makeSVMethod("stroke")
	T.strokeWidth = makeRawNumMethod("stroke-width")

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
StyleValue.Raw = function (v) return function () return v end end
StyleValue.RawRGB = function () return "rgb(%d %d %d)" end

local m_floor, m_random = math.floor, math.random

StyleValue.RandomRGB = function ()
	local n = m_floor(m_random() * 0xffffff)
	return ("rgb(%d %d %d)"):format(n >> 16, (n >> 8) & 0xff, n & 0xff)
end

return {
	mustBePlotter = mustBePlotter,
	svgPlot = svgPlot,
	svgPlotWholeBuffer = svgPlotWholeBuffer,
	svgPlotWithBuffer = svgPlotWithBuffer,
	styleMaker = styleMaker,
	StyleValue = StyleValue
}
