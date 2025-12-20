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
--                                               :file, :write(, :reset)
--
--    and some extensions for basic shapes  are  :circle, :ellipse, :line, :rect
--

local H = require '_helper'
local M = require 'svgplot_helper'

local isFh, isNum = H.isFh, H.isNum
local mustBeFun, mustBeNum, mustBeStr = H.mustBeFun, H.mustBeNum, H.mustBeStr
local DEFAULT_LIMIT = 50
local makeBuffer, toRGB = M.gMakeBuffer(DEFAULT_LIMIT), M.toRGB

local m_floor, m_random = math.floor, math.random
local t_concat, t_insert = table.concat, table.insert

local function header(w, h)
	return ([[
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="%d" height="%d">
]]):format(w, h)
end

local function footer()
	return [[</svg>
]]
end

local function pathStart(self)
	self.o:write([[<path d="]])
	return self
end

local function pathEnd(self, isClosePath, style)
	self.o:write(([[%s" %s />
]]):format(isClosePath and "Z" or "", style))
	return self
end

local function move(self, x, y)
	self.o:write(("M %g %g "):format(x, self.h - y))
	return self
end

local function moveRel(self, x, y)
	self.o:write(("m %g %g "):format(x, -y))
	return self
end

local function draw(self, x, y)
	self.o:write(("L %g %g "):format(x, self.h - y))
	return self
end

local function drawRel(self, x, y)
	self.o:write(("l %g %g "):format(x, -y))
	return self
end

local function circle(self, cx, cy, r, style)
	self.o:write(([[<circle cx="%g" cy="%g" r="%g" %s/>
]]):format(cx, cy, r, style))
	return self
end

local function ellipse(self, cx, cy, rx, ry, style)
	self.o:write(([[<ellipse cx="%g" cy="%g" rx="%g" ry="%g" %s/>
]]):format(cx, cy, rx, ry, style))
	return self
end

local function line(self, x1, y1, x2, y2, style)
	self.o:write(([[<line x1="%g" y1="%g" x2="%g" y2="%g" %s/>
]]):format(x1, y1, x2, y2, style))
	return self
end

local function rect(self, x, y, w, h, rx, ry, style)
	self.o:write(([[<rect x="%g" y="%g" width="%g" height="%g" rx="%g" ry="%g" %s/>
]]):format(x, y, w, h, rx, ry, style))
	return self
end

local function file(self, path, body, ...)
	local _, fh = pcall(io.open, path, "w")
	assert(isFh(fh), "file(): Something wrong with your 'path'.")

	local ret, v = pcall(self.write, self, fh, body, ...)
	fh:close()
	assert(ret == true, v)

	return self
end

--
--  writeA for gSvgPlot(makeNil)
--  writeB for gSvgPlot(makeBuffer)
--

local function writeA(self, fh, body)
	self.o = isFh(fh) and fh or io.stdout
	self.o:write(header(self.w, self.h))
	body(self)
	self.o:write(footer())
	self.o = nil
	return self
end
local function writeB(self, fh, body, limit)
	fh = isFh(fh) and fh or io.stdout
	limit = isNum(limit) and limit or DEFAULT_LIMIT
	self.o
		:startStep(fh, limit)
		:write(header(self.w, self.h))
	body(self)
	self.o
		:write(footer())
		:endStep()
	return self
end

local function makeMethod(v)
	return pathStart, pathEnd, move, moveRel, draw, drawRel,
		circle, ellipse, line, rect,
		file, v == nil and writeA or writeB
end

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
		T.file, T.write = makeMethod(T.o)

		return T
	end
end

local function makeNil() return nil end

local SvgPlot, SvgPlotWithBuffer = gSvgPlot(makeNil), gSvgPlot(makeBuffer)

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
	local T = { buf = {}, attr = {} }

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
SV.RandomRGB = function ()
	return ("rgb(%d %d %d)"):format(toRGB(m_floor(m_random() * 0xffffff)))
end

SV.PRESET_PLAIN = Styler:fill(SV.None):stroke(SV.Black)()
SV.PRESET_FillBLACK = Styler:fill(SV.Black)()
local fmt_RawRGB = Styler:fill(SV.Transparent):stroke(SV.RawRGB):strokeWidth(1)()
SV.PRESET_RawRGB = function (n) return fmt_RawRGB:format(toRGB(n)) end

return {
	SvgPlot = SvgPlot,
	SvgPlotWithBuffer = SvgPlotWithBuffer,
	Styler = Styler,
	SV = SV
}
