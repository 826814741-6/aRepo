--
--  from src/svgplot.c
--
--    void plot_start(int, int)             to   :pathStart
--    void plot_end(int)                    to   :pathEnd
--    void move(double, double)             to   :move
--    void move_rel(double, double)         to   :moveRel
--    void draw(double, double)             to   :draw
--    void draw_rel(double, double)         to   :drawRel
--
--                                               :write(, :reset)
--
--    and some extensions for basic shapes  are  :circle, :ellipse, :line, :rect
--

local H = require '_helper'

local isFh, isNum, isTbl = H.isFh, H.isNum, H.isTbl
local mustBeFun, mustBeNum, mustBeStr = H.mustBeFun, H.mustBeNum, H.mustBeStr

local t_concat = table.concat
local t_insert = table.insert

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

local function move(x, y, height)
	return ("M %g %g "):format(x, height - y)
end

local function moveRel(x, y)
	return ("m %g %g "):format(x, -y)
end

local function draw(x, y, height)
	return ("L %g %g "):format(x, height - y)
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
--  ___A for SvgPlot, SvgPlotWithBuffer
--
--    function ___A(self, ...)
--        self.o:write(fmt(...))
--        return self
--    end
--
--  ___B for SvgPlotWholeBuffer
--
--    function ___B(self, ...)
--        t_insert(self.o, fmt(...))
--        return self
--    end
--

local function pathStartA(self)
	self.o:write(pathStart())
	return self
end
local function pathStartB(self)
	t_insert(self.o, pathStart())
	return self
end

local function pathEndA(self, isClosePath, style)
	self.o:write(pathEnd(isClosePath, style))
	return self
end
local function pathEndB(self, isClosePath, style)
	t_insert(self.o, pathEnd(isClosePath, style))
	return self
end

local function moveA(self, x, y)
	self.o:write(move(x, y, self.h))
	return self
end
local function moveB(self, x, y)
	t_insert(self.o, move(x, y, self.h))
	return self
end

local function moveRelA(self, x, y)
	self.o:write(moveRel(x, y))
	return self
end
local function moveRelB(self, x, y)
	t_insert(self.o, moveRel(x, y))
	return self
end

local function drawA(self, x, y)
	self.o:write(draw(x, y, self.h))
	return self
end
local function drawB(self, x, y)
	t_insert(self.o, draw(x, y, self.h))
	return self
end

local function drawRelA(self, x, y)
	self.o:write(drawRel(x, y))
	return self
end
local function drawRelB(self, x, y)
	t_insert(self.o, drawRel(x, y))
	return self
end

local function circleA(self, cx, cy, r, style)
	self.o:write(circle(cx, cy, r, style))
	return self
end
local function circleB(self, cx, cy, r, style)
	t_insert(self.o, circle(cx, cy, r, style))
	return self
end

local function ellipseA(self, cx, cy, rx, ry, style)
	self.o:write(ellipse(cx, cy, rx, ry, style))
	return self
end
local function ellipseB(self, cx, cy, rx, ry, style)
	t_insert(self.o, ellipse(cx, cy, rx, ry, style))
	return self
end

local function lineA(self, x1, y1, x2, y2, style)
	self.o:write(line(x1, y1, x2, y2, style))
	return self
end
local function lineB(self, x1, y1, x2, y2, style)
	t_insert(self.o, line(x1, y1, x2, y2, style))
	return self
end

local function rectA(self, x, y, w, h, rx, ry, style)
	self.o:write(rect(x, y, w, h, rx, ry, style))
	return self
end
local function rectB(self, x, y, w, h, rx, ry, style)
	t_insert(self.o, rect(x, y, w, h, rx, ry, style))
	return self
end

--
--  writeA         for SvgPlot
--  writeB, resetB for SvgPlotWholeBuffer
--  writeC         for SvgPlotWithBuffer
--

local function writeA(self, fh, body)
	self.o = isFh(fh) and fh or io.stdout
	self.o:write(header(self.w, self.h))
	body(self)
	self.o:write(footer())
	self.o = nil
	return self
end
local function writeB(self, fh, body, isOneByOne)
	body(self)
	fh = isFh(fh) and fh or io.stdout
	fh:write(header(self.w, self.h))
	if isOneByOne then
		for _,v in ipairs(self.o) do
			fh:write(v)
		end
	else
		fh:write(t_concat(self.o))
	end
	fh:write(footer())
	return self
end
local function writeC(self, fh, body, limit)
	self.o
		:startStep(fh, limit)
		:write(header(self.w, self.h))
	body(self)
	self.o
		:write(footer())
		:endStep()
	return self
end

local function resetB(self)
	self.o = {}
	return self
end

--

local function isA(v) return v == nil end
local function isB(v) return isTbl(v) and v.buf == nil end
local function isC(v) return isTbl(v) and isTbl(v.buf) end

local function makeMethod(v)
	if isA(v) then
		return pathStartA, pathEndA, moveA, moveRelA, drawA, drawRelA,
			circleA, ellipseA, lineA, rectA,
			writeA
	elseif isB(v) then
		return pathStartB, pathEndB, moveB, moveRelB, drawB, drawRelB,
			circleB, ellipseB, lineB, rectB,
			writeB, resetB
	elseif isC(v) then
		return pathStartA, pathEndA, moveA, moveRelA, drawA, drawRelA,
			circleA, ellipseA, lineA, rectA,
			writeC
	else
		error("'v' must be a value above.")
		-- Please see the arguments for the function 'gSvgPlot' below.
	end
end

--

local function makeNil() return nil end
local function makeTable() return {} end

local DefaultLimit = 50

local function bufStart(self, fh, limit)
	self.buf, self.cnt = {}, 0
	self.fh = isFh(fh) and fh or io.stdout
	self.limit = isNum(limit) and limit or DefaultLimit
	return self
end

local function bufWrite(self, s)
	t_insert(self.buf, s)
	self.cnt = self.cnt + 1
	if self.cnt >= self.limit then
		self.fh:write(t_concat(self.buf))
		self.buf, self.cnt = {}, 0
	end
	return self
end

local function bufEnd(self)
	if self.cnt > 0 then
		self.fh:write(t_concat(self.buf))
	end
	self.buf, self.cnt, self.fh = {}, 0, nil
	return self
end

local function makeBuffer()
	local T = {
		buf = {},
		cnt = 0,
		fh = nil,
		limit = DefaultLimit
	}

	T.startStep, T.write, T.endStep = bufStart, bufWrite, bufEnd

	return T
end

--

local function gSvgPlot(initializer)
	return function (width, height)
		mustBeNum(width) mustBeNum(height)

		local T = {
			w = width,
			h = height,
			--
			o = initializer()
		}

		T.pathStart, T.pathEnd, T.move, T.moveRel, T.draw, T.drawRel,
		T.circle, T.ellipse, T.line, T.rect,
		T.write, T.reset = makeMethod(T.o)

		return T
	end
end

local SvgPlot, SvgPlotWholeBuffer, SvgPlotWithBuffer =
	gSvgPlot(makeNil), gSvgPlot(makeTable), gSvgPlot(makeBuffer)

--

local function gMakeStyleMethod(specifier, filter)
	mustBeStr(specifier) mustBeFun(filter)

	return function (s)
		mustBeStr(s)

		local fmt, errStr =
			([[%s="%%%s"]]):format(s, specifier),
			([[Attribute '%s' already exists.]]):format(s)

		return function (self, v)
			if self.attr[s] ~= true then
				self.attr[s] = true
				t_insert(
					self.buf,
					fmt:format(filter(v))
				)
			else
				error(errStr)
			end
			return self
		end
	end
end

local makeMethodSV, makeMethodN =
	gMakeStyleMethod("s", function (v) return mustBeStr(v()) end),
	gMakeStyleMethod("g", mustBeNum)

local stFill, stPaintOrder, stStroke, stStrokeWidth =
	makeMethodSV("fill"), makeMethodSV("paint-order"), makeMethodSV("stroke"),
	makeMethodN("stroke-width")

local function stDone(self)
	local r = t_concat(self.buf, " ")
	self.buf, self.attr = {}, {}
	return r
end

local Styler = (function ()
	local T = { buf = {}; attr = {} }

	setmetatable(T, { __call = stDone })

	T.fill = stFill
	T.paintOrder = stPaintOrder
	T.stroke = stStroke
	T.strokeWidth = stStrokeWidth

	return T
end)()
--
-- ref:
-- https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Fills_and_Strokes
--

local SV = {}

SV.None = function () return "none" end
SV.Transparent = function () return "transparent" end
SV.Black = function () return "black" end
SV.White = function () return "white" end
SV.Raw = function (v) return function () return v end end
SV.RawRGB = function () return "rgb(%d %d %d)" end

local m_floor, m_random = math.floor, math.random

local function toRGB(n)
	return n >> 16, (n >> 8) & 0xff, n & 0xff
end

SV.RandomRGB = function ()
	return ("rgb(%d %d %d)"):format(toRGB(m_floor(m_random() * 0xffffff)))
end

SV.PRESET_PLAIN = Styler:fill(SV.None):stroke(SV.Black)()
SV.PRESET_FillBLACK = Styler:fill(SV.Black)()
local fmt_RawRGB = Styler:fill(SV.Transparent):stroke(SV.RawRGB):strokeWidth(1)()
SV.PRESET_RawRGB = function (n) return fmt_RawRGB:format(toRGB(n)) end

return {
	SvgPlot = SvgPlot,
	SvgPlotWholeBuffer = SvgPlotWholeBuffer,
	SvgPlotWithBuffer = SvgPlotWithBuffer,
	Styler = Styler,
	SV = SV
}
