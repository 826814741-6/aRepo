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
	function move(x, y)
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
	function draw(x, y)
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

local getNum = isWrapWithValidator
	and function (v) return v.numOfParams end
	or getNumOfParams

local s_char = string.char

local function initP(v)
	local r = {}
	for i=1,getNum(v) do
		r[i] = s_char(96 + i)
	end
	return r
end

local function initE(name, target, prelude)
	local r = { [name] = target }
	if isTbl(prelude) then
		for k,v in pairs(prelude) do
			r[k] = v
		end
	end
	return r
end

local function gMakeMethod(template, prelude)
	return function (name, target)
		local param = t_concat(initP(target), ", ")
		return load(([[return function (self%s%s)
			%s
			return self
		end]]):format(
			param ~= "" and ", " or "",
			param,
			template:format(name, param)
		), "", "t", initE(name, target, prelude))()
	end
end

local makeMethod, makeMethodForWholeBuffer, makeMethodForWithBuffer =
	gMakeMethod([[self.fh:write(%s(%s))]]),
	gMakeMethod([[t_insert(self.buffer, %s(%s))]], {t_insert = t_insert}),
	gMakeMethod([[self.buffer:writer(%s(%s))]])

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

	T.pathStart = makeMethod("pathStart", pathStart)
	T.pathEnd = makeMethod("pathEnd", pathEnd)

	local move, draw = gMove(height), gDraw(height)

	T.move = makeMethod("move", move)
	T.moveRel = makeMethod("moveRel", moveRel)
	T.draw = makeMethod("draw", draw)
	T.drawRel = makeMethod("drawRel", drawRel)
	T.circle = makeMethod("circle", circle)
	T.ellipse = makeMethod("ellipse", ellipse)
	T.line = makeMethod("line", line)
	T.rect = makeMethod("rect", rect)

	return mustBePlotter(T)
end

local function svgPlotWholeBuffer(width, height)
	assertInitialValue(width, height)

	local T = writerWholeBuffer(width, height)

	T.pathStart = makeMethodForWholeBuffer("pathStart", pathStart)
	T.pathEnd = makeMethodForWholeBuffer("pathEnd", pathEnd)

	local move, draw = gMove(height), gDraw(height)

	T.move = makeMethodForWholeBuffer("move", move)
	T.moveRel = makeMethodForWholeBuffer("moveRel", moveRel)
	T.draw = makeMethodForWholeBuffer("draw", draw)
	T.drawRel = makeMethodForWholeBuffer("drawRel", drawRel)
	T.circle = makeMethodForWholeBuffer("circle", circle)
	T.ellipse = makeMethodForWholeBuffer("ellipse", ellipse)
	T.line = makeMethodForWholeBuffer("line", line)
	T.rect = makeMethodForWholeBuffer("rect", rect)

	return mustBePlotter(T)
end

local function svgPlotWithBuffer(width, height)
	assertInitialValue(width, height)

	local T = writerWithBuffer(width, height)

	T.pathStart = makeMethodForWithBuffer("pathStart", pathStart)
	T.pathEnd = makeMethodForWithBuffer("pathEnd", pathEnd)

	local move, draw = gMove(height), gDraw(height)

	T.move = makeMethodForWithBuffer("move", move)
	T.moveRel = makeMethodForWithBuffer("moveRel", moveRel)
	T.draw = makeMethodForWithBuffer("draw", draw)
	T.drawRel = makeMethodForWithBuffer("drawRel", drawRel)
	T.circle = makeMethodForWithBuffer("circle", circle)
	T.ellipse = makeMethodForWithBuffer("ellipse", ellipse)
	T.line = makeMethodForWithBuffer("line", line)
	T.rect = makeMethodForWithBuffer("rect", rect)

	return mustBePlotter(T)
end

--

local function gMakeStyleMethod(specifier, filter)
	return function (s)
		local fmt = ([[%s="%%%s"]]):format(mustBeStr(s), specifier)
		return function (self, v)
			if self.attr[s] ~= true then
				self.attr[s] = true
				t_insert(
					self.buf,
					fmt:format(filter(v))
				)
			end
			return self
		end
	end
end

local makeSVMethod, makeRawNumMethod =
	gMakeStyleMethod("s", function (v) return mustBeStr(v()) end),
	gMakeStyleMethod("g", function (v) return mustBeNum(v) end)

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
