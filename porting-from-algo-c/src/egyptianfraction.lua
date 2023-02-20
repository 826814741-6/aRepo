--
--	from src/egypfrac.c
--
--	a part of main		to	egyptianFraction
--	egyptianFraction	to	egyptianFractionB
--	egyptianFraction	to	egyptianFractionM
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
		write(("1/%s\n"):format(v))      -- %s and number; see below
	else
		write(("1/%s + "):format(v))     -- %s and number; see below
	end
end

local function allAtOnce()
	local buf = {}
	return function (co, ...)
		local _, v, isEnd = resume(co, ...)
		insert(buf, ("1/%s"):format(v))  -- %s and [bc's] number; see below
		if isEnd == true then
			write(concat(buf, " + "), "\n")
		end
	end
end

--
--	> The specifier 's' expects a string; if its argument is not a string,
--	> it is converted to one following the same rules of 'tostring'.
--
--	-- Lua 5.4 Reference manual > String.format
--

return {
	egyptianFraction = g(f, oneByOne),
	egyptianFractionB = g(f, allAtOnce()),
	egyptianFractionM = g(fM, allAtOnce())
}
