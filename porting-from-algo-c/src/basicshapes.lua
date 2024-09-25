--
--	some extensions of basic shapes for src/svgplot.lua
--

local isStr = require '_helper'.isStr
local mustBeNum = require '_helper'.mustBeNum
local mustBeStr = require '_helper'.mustBeStr

local t_concat = table.concat
local t_insert = table.insert

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

local function extension(T)
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

	return T
end

local function extensionForWhole(T)
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

	return T
end

local function extensionForWith(T)
	function T:circle(cx, cy, r, style)
		T.buffer:writer(T.fh, circle(cx, cy, r, style))
		return T
	end

	function T:ellipse(cx, cy, rx, ry, style)
		T.buffer:writer(T.fh, ellipse(cx, cy, rx, ry, style))
		return T
	end

	function T:line(x1, y1, x2, y2, style)
		T.buffer:writer(T.fh, line(x1, y1, x2, y2, style))
		return T
	end

	function T:rect(x, y, w, h, rx, ry, style)
		T.buffer:writer(T.fh, rect(x, y, w, h, rx, ry, style))
		return T
	end

	return T
end

local function makeStyle()
	local T = { buf = {}; tag = {} }

	function T:fill(s)
		if T.tag.fill ~= true then
			T.tag.fill = true
			t_insert(
				T.buf,
				([[fill="%s"]]):format(mustBeStr(s))
			)
		end
		return T
	end

	function T:paintOrder(s)
		if T.tag.paintOrder ~= true then
			T.tag.paintOrder = true
			t_insert(
				T.buf,
				([[paint-order="%s"]]):format(mustBeStr(s))
			)
		end
		return T
	end

	function T:stroke(s)
		if T.tag.stroke ~= true then
			T.tag.stroke = true
			t_insert(
				T.buf,
				([[stroke="%s"]]):format(mustBeStr(s))
			)
		end
		return T
	end

	function T:strokeWidth(n)
		if T.tag.strokeWidth ~= true then
			T.tag.strokeWidth = true
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

return {
	extensionForSvgPlot = extension,
	extensionForSvgPlotWholeBuffering = extensionForWhole,
	extensionForSvgPlotWithBuffering = extensionForWith,
	makeStyle = makeStyle
}
