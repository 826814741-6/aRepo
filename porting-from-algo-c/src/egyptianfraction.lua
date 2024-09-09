--
--	from src/egypfrac.c
--
--	a part of main		to	egyptianFraction
--	egyptianFraction	to	egyptianFractionT
--	egyptianFraction	to	egyptianFractionM (depends on lbc(*))
--	egyptianFraction	to	egyptianFractionCO
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local i_write = io.write
local t_insert = table.insert

local function egyptianFraction(n, d)
	while d % n ~= 0 do
		local t = d // n + 1
		i_write(("1/%d + "):format(t))
		n, d = n * t - d, d * t
	end
	i_write(("1/%d\n"):format(d // n))
end

local function egyptianFractionT(n, d)
	local r = {}
	while d % n ~= 0 do
		local t = d // n + 1
		t_insert(r, ("1/%d"):format(t))
		n, d = n * t - d, d * t
	end
	t_insert(r, ("1/%d"):format(d // n))
	return r
end

local hasBC, M = pcall(require, "bc")
local isZero = hasBC and M.iszero or nil
local bn1 = hasBC and M.new(1) or nil

local egyptianFractionM = hasBC and function (n, d)
	local n, d = M.new(n), M.new(d)
	while not isZero(d % n) do
		local t = d / n + bn1
		i_write(("1/%s + "):format(t)) -- %s and tostring; see below
		n, d = n * t - d, d * t
	end
	i_write(("1/%s\n"):format(d / n))      -- %s and tostring; see below
end

--
--	> The specifier 's' expects a string; if its argument is not a string,
--	> it is converted to one following the same rules of 'tostring'.
--
--	-- Lua 5.4 Reference manual > string.format
--

local co_create = coroutine.create
local co_status = coroutine.status
local co_resume = coroutine.resume
local co_yield = coroutine.yield

local function bodyR(n, d)
	if d % n ~= 0 then
		local t = d // n + 1
		co_yield(t)
		return bodyR(n * t - d, d * t)
	end
	return d // n
end

-- local bodyM = hasBC and function (n, d)
-- 	local n, d = M.new(n), M.new(d)
-- 	while not isZero(d % n) do
-- 		local t = d / n + bn1
-- 		co_yield(t)
-- 		n, d = n * t - d, d * t
-- 	end
-- 	return d / n
-- end or nil

local function egyptianFractionCO(n, d)
	local co = co_create(bodyR)

	local _, v = co_resume(co, n, d)
	i_write(("1/%s"):format(v))

	while co_status(co) == "suspended" do
		_, v = co_resume(co)
		i_write((" + 1/%s"):format(v))
	end

	i_write("\n")
end

return {
	egyptianFraction = egyptianFraction,
	egyptianFractionT = egyptianFractionT,
	egyptianFractionM = egyptianFractionM,
	egyptianFractionCO = egyptianFractionCO
}
