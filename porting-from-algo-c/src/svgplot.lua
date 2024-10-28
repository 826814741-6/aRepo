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

local isBool, isFh, isFun, isNum, isStr, isTbl =
	H.isBool, H.isFh, H.isFun, H.isNum, H.isStr, H.isTbl
local isFhOrNil, isNumOrNil = H.isFhOrNil, H.isNumOrNil
local mustBeNum, mustBeStr = H.mustBeNum, H.mustBeStr
local getNumOfParams, wrapWithValidator = H.getNumOfParams, H.wrapWithValidator

local t_concat = table.concat
local t_insert = table.insert

--

local isWrapWithValidator = false
--
-- When you toggle the value 'isWrapWithValidator' above, the following format
-- functions:
--   header, footer, pathStart, pathEnd, move, moveRel, draw, drawRel,
--   circle, ellipse, line, rect
-- and the following writer method functions:
--   plotStart, plotEnd           (in writer or writerWithBuffer)
--   reset, write, writeOneByOne  (in writerWholeBuffer)
-- are wrapped with several validators.
--
-- Note:
-- The format functions are not called directly by the user. However, since
-- each plotter method is implemented as a thin wrapper around a format
-- function, this trick can be useful for prototyping or debugging.
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

local function pathEnd(isClosePath, style)
	return ([[%s" %s />
]]):format(isClosePath and "Z" or "", style)
end

local function gMove(height)
	mustBeNum(height)
	function move (x, y)
		return ("M %g %g "):format(x, height - y)
	end
	return isWrapWithValidator
		and wrapWithValidator(move, {isNum, isNum}, {isStr})
		or move
end

local function moveRel(x, y)
	return ("m %g %g "):format(x, -y)
end

local function gDraw(height)
	mustBeNum(height)
	function draw (x, y)
		return ("L %g %g "):format(x, height - y)
	end
	return isWrapWithValidator
		and wrapWithValidator(draw, {isNum, isNum}, {isStr})
		or draw
end

local function drawRel(x, y)
	return ("l %g %g "):format(x, -y)
end

local function circle(cx, cy, r, style)
	return ([[<circle cx="%g" cy="%g" r="%g" %s/>
]]):format(cx, cy, r, style)
end

local function ellipse(cx, cy, rx, ry, style)
	return ([[<ellipse cx="%g" cy="%g" rx="%g" ry="%g" %s/>
]]):format(cx, cy, rx, ry, style)
end

local function line(x1, y1, x2, y2, style)
	return ([[<line x1="%g" y1="%g" x2="%g" y2="%g" %s/>
]]):format(x1, y1, x2, y2, style)
end

local function rect(x, y, w, h, rx, ry, style)
	return ([[<rect x="%g" y="%g" width="%g" height="%g" rx="%g" ry="%g" %s/>
]]):format(x, y, w, h, rx, ry, style)
end

--

if isWrapWithValidator then
	header = wrapWithValidator(header, {isNum, isNum}, {isStr})
	footer = wrapWithValidator(footer, {}, {isStr})
	pathStart = wrapWithValidator(pathStart, {}, {isStr})
	pathEnd = wrapWithValidator(pathEnd, {isBool, isStr}, {isStr})
	moveRel = wrapWithValidator(moveRel, {isNum, isNum}, {isStr})
	drawRel = wrapWithValidator(drawRel, {isNum, isNum}, {isStr})
	circle = wrapWithValidator(circle, {isNum, isNum, isNum, isStr}, {isStr})
	ellipse = wrapWithValidator(ellipse, {isNum, isNum, isNum, isNum, isStr}, {isStr})
	line = wrapWithValidator(line, {isNum, isNum, isNum, isNum, isStr}, {isStr})
	rect = wrapWithValidator(rect, {isNum, isNum, isNum, isNum, isNum, isNum, isStr}, {isStr})
end

local checkNumOfParamsDyad = isWrapWithValidator
	and function (methodFunction, target)
		return isFun(methodFunction) and isTbl(target)
			and getNumOfParams(methodFunction) == 1 + target.numOfParams
	end
	or function (methodFunction, target)
		return isFun(methodFunction) and isFun(target)
			and getNumOfParams(methodFunction) == 1 + getNumOfParams(target)
	end
--
-- Note:
-- The magic number '1' above comes from the implicit extra parameter 'self'.
-- (ref: the last part of https://www.lua.org/manual/5.4/manual.html#3.4.11)
--

local moveDummy, drawDummy = gMove(0), gDraw(0)

local function mustBePlotter(T)
	assert(
		checkNumOfParamsDyad(T.pathStart, pathStart)
		and checkNumOfParamsDyad(T.pathEnd, pathEnd)
		and checkNumOfParamsDyad(T.move, moveDummy)
		and checkNumOfParamsDyad(T.moveRel, moveRel)
		and checkNumOfParamsDyad(T.draw, drawDummy)
		and checkNumOfParamsDyad(T.drawRel, drawRel)
		--
		and checkNumOfParamsDyad(T.circle, circle)
		and checkNumOfParamsDyad(T.ellipse, ellipse)
		and checkNumOfParamsDyad(T.line, line)
		and checkNumOfParamsDyad(T.rect, rect)
	)
	return T
end

local function mustBeWriter(T)
	assert(T.buffer == nil)

	if isWrapWithValidator then
		T.plotStart = wrapWithValidator(T.plotStart, {isTbl, isFhOrNil}, {isTbl})
		T.plotEnd = wrapWithValidator(T.plotEnd, {isTbl}, {isTbl})
	end

	return T
end

local function mustBeWriterWholeBuffer(T)
	assert(isTbl(T.buffer) and T.buffer.buffer == nil)

	if isWrapWithValidator then
		T.reset = wrapWithValidator(T.reset, {isTbl}, {isTbl})
		T.write = wrapWithValidator(T.write, {isTbl, isFhOrNil}, {isTbl})
		T.writeOneByOne = wrapWithValidator(T.writeOneByOne, {isTbl, isFhOrNil}, {isTbl})
	end

	return T
end

local function mustBeWriterWithBuffer(T)
	assert(isTbl(T.buffer) and isTbl(T.buffer.buffer))

	if isWrapWithValidator then
		T.plotStart = wrapWithValidator(T.plotStart, {isTbl, isFhOrNil, isNumOrNil}, {isTbl})
		T.plotEnd = wrapWithValidator(T.plotEnd, {isTbl}, {isTbl})
	end

	return T
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
-- local function makeMethodForWholeBuffer(fmt)
-- 	return function (self, ...)
-- 		t_insert(self.buffer, fmt(...))
-- 		return self
-- 	end
-- end
--
-- local function makeMethodForWithBuffer(fmt)
-- 	return function (self, ...)
-- 		self.buffer:writer(fmt(...))
-- 		return self
-- 	end
-- end
--
-- Note:
-- Although variadic functions have some overhead compared to non-variadic
-- functions, the three utility functions above can be useful in implementing
-- each plotter method during prototyping.
--

--

local function writer(w, h)
	local T = { fh = nil }

	function T:plotStart(fh)
		T.fh = isFh(fh) and fh or io.stdout
		T.fh:write(header(w, h))
		return T
	end

	function T:plotEnd()
		T.fh:write(footer())
		T.fh = nil
		return T
	end

	return mustBeWriter(T)
end

local function writerWholeBuffer(w, h)
	local T = { buffer = {} }

	function T:reset()
		T.buffer = {}
		return T
	end

	function T:write(fh)
		fh = isFh(fh) and fh or io.stdout

		fh:write(header(w, h))
		fh:write(t_concat(T.buffer))
		fh:write(footer())

		return T
	end

	function T:writeOneByOne(fh)
		fh = isFh(fh) and fh or io.stdout

		fh:write(header(w, h))
		for _,v in ipairs(T.buffer) do
			fh:write(v)
		end
		fh:write(footer())

		return T
	end

	return mustBeWriterWholeBuffer(T)
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

local function writerWithBuffer(w, h)
	local T = { buffer = makeBuffer() }

	function T:plotStart(fh, limit)
		T.buffer:startStep(fh, limit)
		T.buffer:writer(header(w, h))
		return T
	end

	function T:plotEnd()
		T.buffer:writer(footer())
		T.buffer:endStep()
		return T
	end

	return mustBeWriterWithBuffer(T)
end

--

local function svgPlot(width, height)
	assertInitialValue(width, height)

	local T = writer(width, height)

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

	return mustBePlotter(T)
end

local function svgPlotWholeBuffer(width, height)
	assertInitialValue(width, height)

	local T = writerWholeBuffer(width, height)

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

	return mustBePlotter(T)
end

local function svgPlotWithBuffer(width, height)
	assertInitialValue(width, height)

	local T = writerWithBuffer(width, height)

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

	return mustBePlotter(T)
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
