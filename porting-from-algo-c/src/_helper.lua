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

return {
	abs = abs,
	atLeastOne = atLeastOne,
	count = count,
	decrement = decrement,
	id = id,
	increment = increment,
	tableWriter = tableWriter,
	with = with
}
