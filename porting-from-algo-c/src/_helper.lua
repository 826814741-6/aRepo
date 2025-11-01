--
--  _helper.lua: some helper functions for toy scripts
--

--
-- >> math.abs (x)
-- >> Returns the maximum value between x and -x. (integer/float)
-- >> -- https://www.lua.org/manual/5.4/manual.html#pdf-math.abs
--
-- > print(math.abs(0), math.abs(-0), math.abs(0.0), math.abs(-0.0))
-- 0       0       0.0     0.0
-- > print(math.type(math.abs(-0)), math.type(math.abs(-0.0)))
-- integer float
--
-- > print(("%d %f %g %a"):format(-0, -0, -0, -0))
-- 0 0.000000 0 0x0p+0
-- > print(("%d %f %g %a"):format(-0.0, -0.0, -0.0, -0.0))
-- 0 -0.000000 -0 -0x0p+0
--

local function isBool(v)
	return type(v) == "boolean"
end

local function isFh(v)
	return io.type(v) == "file"
end

local function isFun(v)
	return type(v) == "function"
end

local function isNum(v)
	return type(v) == "number"
end

local function isStr(v)
	return type(v) == "string"
end

local function isTbl(v)
	return type(v) == "table"
end

local function isUd(v)
	return type(v) == "userdata"
end

local function getValueOrInit(predicate, v, initialValue)
	if predicate(v) then
		return v
	else
		return initialValue
	end
end

local function mustBeBool(v)
	assert(type(v) == "boolean", "Must be a boolean.")
	return v
end

local function mustBeFun(v)
	assert(type(v) == "function", "Must be a function.")
	return v
end

local function mustBeNum(v)
	assert(type(v) == "number", "Must be a number.")
	return v
end

local function mustBeStr(v)
	assert(type(v) == "string", "Must be a string.")
	return v
end

-- local function readOnlyTable(t)
--   ...
-- end
-- see: http://lua-users.org/wiki/ReadOnlyTables
--      https://www.lua.org/pil/13.4.5.html
--      (the last part of) https://www.lua.org/pil/13.3.html

local function file(path, mode, body)
	local _, fh = pcall(io.open, path, mode)
	assert(isFh(fh), "file(): Something wrong with your 'path' or/and 'mode'.")

	local ret, v = pcall(body, fh)
	fh:close()
	assert(ret == true, v)
end

local function template_forBasicShapes(loop)
	local M1, M2 = require 'grBMP', require 'svgplot'

	local fmt1 = M1.makeColor ~= nil and M1.makeColor or tonumber -- .lua or .luajit
	local fmt2 = M2.SV.PRESET_RawRGB

	return function (prefix, n, x, y)
		local bmp, svg = M1.BMP(x, y), M2.SvgPlot(x, y)

		bmp:clear(M1.PRESET_COLOR.BLACK)
		loop(bmp, n, x, y, fmt1)

		function body(svg)
			svg:rect(0, 0, x, y, 0, 0, M2.SV.PRESET_FillBLACK)
			loop(svg, n, x, y, fmt2)
		end

		bmp:file(prefix .. ".bmp")
		svg:file(prefix .. ".svg", body)
	end
end

return {
	isBool = isBool,
	isFh = isFh,
	isFun = isFun,
	isNum = isNum,
	isStr = isStr,
	isTbl = isTbl,
	isUd = isUd,
	getValueOrInit = getValueOrInit,
	mustBeBool = mustBeBool,
	mustBeFun = mustBeFun,
	mustBeNum = mustBeNum,
	mustBeStr = mustBeStr,
	file = file,
	template_forBasicShapes = template_forBasicShapes
}
