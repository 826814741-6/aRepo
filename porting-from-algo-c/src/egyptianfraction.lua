--
--  from src/egypfrac.c
--
--    a part of main    to  egyptianFraction
--    egyptianFraction  to  egyptianFractionT
--    egyptianFraction  to  egyptianFractionM (depends on lbc(*))
--    egyptianFraction  to  egyptianFractionCo
--    egyptianFraction  to  egyptianFractionCoM (depends on lbc(*))
--
--  *) lbc-102; https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc
--

local i_write = io.write
local t_insert = table.insert

local function egyptianFraction(n0, d0)
	local n, d = n0, d0
	while d % n ~= 0 do
		local t = d // n + 1
		i_write(("1/%d + "):format(t))
		n, d = n * t - d, d * t
	end
	i_write(("1/%d\n"):format(d // n))
end

local function egyptianFractionT(n0, d0)
	local r, n, d = {}, n0, d0
	while d % n ~= 0 do
		local t = d // n + 1
		t_insert(r, ("1/%d"):format(t))
		n, d = n * t - d, d * t
	end
	t_insert(r, ("1/%d"):format(d // n))
	return r
end

local hasBC, bc = pcall(require, "bc")
local isZero = hasBC and bc.iszero or nil
local bn1 = hasBC and bc.new(1) or nil

local egyptianFractionM = hasBC and function (n0, d0)
	local n, d = bc.new(n0), bc.new(d0)
	while not isZero(d % n) do
		local t = d / n + bn1
		i_write(("1/%s + "):format(t)) -- see below
		n, d = n * t - d, d * t
	end
	i_write(("1/%s\n"):format(d / n)) -- see below
end or nil

--
--  > The specifier 's' expects a string; if its argument is not a string,
--  > it is converted to one following the same rules of 'tostring'.
--
--  -- Lua 5.4 Reference manual > string.format
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

local bodyM = hasBC and function (n0, d0)
	local n, d = bc.new(n0), bc.new(d0)
	while not isZero(d % n) do
		local t = d / n + bn1
		co_yield(t)
		n, d = n * t - d, d * t
	end
	return d / n
end or nil

local function gStep(body)
	return function (n, d)
		local co = co_create(body)

		local _, v = co_resume(co, n, d)
		i_write(("1/%s"):format(v))

		while co_status(co) == "suspended" do
			_, v = co_resume(co)
			i_write((" + 1/%s"):format(v))
		end

		i_write("\n")
	end
end

local egyptianFractionCo, egyptianFractionCoM =
	gStep(bodyR), hasBC and gStep(bodyM) or nil

return {
	egyptianFraction = egyptianFraction,
	egyptianFractionT = egyptianFractionT,
	egyptianFractionM = egyptianFractionM,
	egyptianFractionCo = egyptianFractionCo,
	egyptianFractionCoM = egyptianFractionCoM
}
