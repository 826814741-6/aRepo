local function abs(n) return n<0 and -n or n end

local function atLeastOne(n) return n>1 and n or 1 end

local sethook = debug.sethook

local function count(f, ...)
	local c = 0
	sethook(function() c = c + 1 end, "c")
	f(...)
	sethook()
	return c
end

local function decrement(x) return x - 1 end

local function id(x) return x end

local function increment(x) return x + 1 end

local function isNum(v)
	return type(v) == "number"
end

local function isStr(v)
	return type(v) == "string"
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
-- 	...
-- end
-- see: http://lua-users.org/wiki/ReadOnlyTables
--      https://www.lua.org/pil/13.4.5.html
--      (the last part of) https://www.lua.org/pil/13.3.html

--
--	tableWriter(x, y, w, f, vFmt)
--
--	x	= { number, number, number[, "L"] }
--	y	= { number, number, number }
--	w	= { number, number }
--	f	= { function, function, function }
--	vFmt	= { string, string, string }
--
local function tableWriter(x, y, w, f, vFmt)
	function fmt(n, s, f)
		local t = ("%%%d%s"):format(n, s)
		return function (...) return t:format(f(...)) end
	end

	function count(l, r, step)
		local t=0 for _=l,r,step do t=t+1 end return t
	end

	local padding = (" "):rep(w[1] + 2)
	local border = ("-"):rep(w[2] * count(x[1],x[2],x[3]))

	local th = fmt(w[1], vFmt[1].." |", f[1])
	local tdH = fmt(w[2], vFmt[2], f[2])
	local tdB = fmt(w[2], vFmt[3], f[3])

	local isL = x[4] == "L"

	return function (fh)
		fh = fh ~= nil and fh or io.stdout

		-- header
		fh:write(padding)
		for i=x[1],x[2],x[3] do fh:write(tdH(i)) end
		fh:write("\n", padding, border, "\n")

		-- body
		for j=y[1],y[2],y[3] do
			fh:write(th(j))
			for i=x[1],isL and j or x[2],x[3] do fh:write(tdB(i, j)) end
			fh:write("\n")
		end
	end
end

local function with(path, mode, f)
	local fh = io.open(path, mode)
	local ret = pcall(f, fh)
	fh:close()
	assert(ret == true)
end

local function withPlotter(path, plotter, n)
	if type(plotter.plotStart) == "function"
		and type(plotter.plotEnd) == "function" then
		return function (aFunc)
			with(path, "w", function (fh)
				plotter:plotStart(fh, n)
				aFunc(plotter)
				plotter:plotEnd()
			end)
		end
	elseif type(plotter.write) == "function"
		and type(plotter.writeOneByOne) == "function" then
		return function (aFunc)
			aFunc(plotter)
			with(path, "w", function (fh) plotter:write(fh) end)
		end
	else
		error("withPlotter: 'plotter' must be an instance of svgPlot{,WholeBuffer,WithBuffer}")
	end
end

return {
	abs = abs,
	atLeastOne = atLeastOne,
	count = count,
	decrement = decrement,
	id = id,
	increment = increment,
	isNum = isNum,
	isStr = isStr,
	mustBeNum = mustBeNum,
	mustBeStr = mustBeStr,
	tableWriter = tableWriter,
	with = with,
	withPlotter = withPlotter
}
