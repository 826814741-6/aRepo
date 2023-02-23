--
--	from src/egypfrac.c
--
--	a part of main		to	egyptianFraction
--	egyptianFraction	to	egyptianFractionR
--	egyptianFraction	to	egyptianFractionB
--	egyptianFraction	to	egyptianFractionM (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local create = coroutine.create
local resume = coroutine.resume
local status = coroutine.status
local yield = coroutine.yield
local write = io.write
local concat = table.concat
local insert = table.insert

local function f(n, d)
	while d % n ~= 0 do
		local t = d // n + 1
		yield(t)
		n, d = n * t - d, d * t
	end
	return d // n, true
end

local function fR(n, d)
	if d % n ~= 0 then
		local t = d // n + 1
		yield(t)
		return fR(n * t - d, d * t)
	end
	return d // n, true
end

local hasBC, M = pcall(require, "bc")
local isZero = hasBC and M.iszero or nil

local fM = hasBC and function (n, d)
	local n, d, one = M.new(n), M.new(d), M.new(1)
	while not isZero(d % n) do
		local t = d / n + one
		yield(t)
		n, d = n * t - d, d * t
	end
	return d / n, true
end or nil

local function g(funcA, funcB)
	return function (n, d)
		local co = create(funcA)

		funcB(co, n, d)
		while status(co) == "suspended" do
			funcB(co)
		end
	end
end

local function oneByOne(co, ...)
	local _, v, isEnd = resume(co, ...)
	if isEnd == true then
		write(("1/%s\n"):format(v))      -- %s and [bc's] number; see below
	else
		write(("1/%s + "):format(v))     -- %s and [bc's] number; see below
	end
end

local function buffering(buf)
	return function (co, ...)
		local _, v = resume(co, ...)
		buf:insert(("1/%s"):format(v))   -- %s and [bc's] number; see below
	end
end

--
--	> The specifier 's' expects a string; if its argument is not a string,
--	> it is converted to one following the same rules of 'tostring'.
--
--	-- Lua 5.4 Reference manual > string.format
--

local function makeBuffer()
	local T = { buf = {} }

	function T:insert(s)
		insert(T.buf, s)
	end

	function T:writeln()
		write(concat(T.buf, " + "), "\n")
	end

	return T
end

return {
	egyptianFraction = g(f, oneByOne),
	egyptianFractionR = g(fR, oneByOne),
	egyptianFractionB = function (n, d)
		local b = makeBuffer()
		g(f, buffering(b))(n, d)
		b:writeln()
	end,
	egyptianFractionM = hasBC and function (n, d)
		local b = makeBuffer()
		g(fM, buffering(b))(n, d)
		b:writeln()
	end or nil
}
