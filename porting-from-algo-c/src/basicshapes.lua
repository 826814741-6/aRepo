--
--	some extensions of basic shapes for src/svgplot.lua
--

local function isStr(e)
	return e ~= nil and type(e) == "string"
end

local function circle(r, cx, cy, style)
	return ([[<circle r="%g" cx="%g" cy="%g" %s/>
]]):format(r, cx, cy, isStr(style) and style or "")
end

local function ellipse(...)
	return ([[<ellipse ... />
]]):format(...)
end

local function line(...)
	return ([[<line ... />
]]):format(...)
end

local function rect(...)
	return ([[<rect ... />
]]):format(...)
end

local function extension(T)
	function T:circle(r, cx, cy, style)
		T.fh:write(circle(r, cx, cy, style))
		return T
	end
	return T
end

local function extensionForWhole(T)
	function T:circle(r, cx, cy, style)
		T_insert(T.buffer, circle(r, cx, cy, style))
		return T
	end
	return T
end

local function extensionForWith(T)
	function T:circle(r, cx, cy, style)
		T.buffer:writer(T.fh, circle(r, cx, cy, style))
		return T
	end
	return T
end

return {
	extensionForSvgPlot = extension,
	extensionForSvgPlotWholeBuffering = extensionForWhole,
	extensionForSvgPlotWithBuffering = extensionForWith
}
