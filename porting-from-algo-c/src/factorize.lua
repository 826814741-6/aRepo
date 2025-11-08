--
--  from src/factoriz.c
--
--    void factorize(int)  to  factorize
--    factorize            to  factorizeM (depends on lbc(*))
--    factorize            to  factorizeT (depends on lbc(*))
--
--  *) lbc-102; https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc
--

local function chain1(init, ...)
	local t = ({...})[1](init)
	for _,v in ipairs({select(2, ...)}) do
		t = v(t)
	end
	return t
end

local function gStep(div, isZero, initB, fnA, fnB)
	function recA(n)
		if isZero(n % 2) and 4 <= n then
			fnA(n)
			return recA(div(n, 2))
		else
			return n
		end
	end

	function recB(n, d)
		local q = div(n, d)
		if q >= d then
			if isZero(n % d) then
				fnB(d)
				return recB(q, d)
			else
				return recB(n, d + 2)
			end
		else
			return n
		end
	end

	return recA, function (n) return recB(n, initB(3)) end
end

local i_write = io.write

local function factorize(x)
	function div(n, d) return n // d end
	function isZero(v) return v == 0 end
	function id(v) return v end

	function fA(_) i_write("2 * ") end
	function fB(n) i_write(("%d * "):format(n)) end
	function fC(n) i_write(("%d\n"):format(n)) end

	local stepA, stepB = gStep(div, isZero, id, fA, fB)

	chain1(x, stepA, stepB, fC)
end

local hasBC, bc = pcall(require, 'bc')

local factorizeM = hasBC and function (x)
	function div(n, d) return n / d end

	function fA(_) i_write("2 * ") end
	function fB(n) i_write(("%s * "):format(n)) end
	function fC(n) i_write(("%s\n"):format(n)) end

	local stepA, stepB = gStep(div, bc.iszero, bc.new, fA, fB)

	chain1(x, bc.new, stepA, stepB, fC)
end or nil

local t_insert = table.insert

local factorizeT = hasBC and function (x)
	function div(n, d) return n / d end

	local r = {}

	function fA(_) t_insert(r, "2") end
	function fB(n) t_insert(r, tostring(n)) end

	local stepA, stepB = gStep(div, bc.iszero, bc.new, fA, fB)

	chain1(x, bc.new, stepA, stepB, fB)

	return r
end or nil

local co_yield = coroutine.yield
local bn2 = hasBC and bc.new(2) or nil

local bodyM = hasBC and function (x)
	function div(n, d) return n / d end

	function fA(_) co_yield(bn2) end
	function fB(n) co_yield(n) end

	local stepA, stepB = gStep(div, bc.iszero, bc.new, fA, fB)

	return chain1(x, bc.new, stepA, stepB)
end or nil

local co_create = coroutine.create
local co_resume = coroutine.resume

local demo = hasBC and function (n)
	local co = co_create(bodyM)

	local _, v = co_resume(co, bn2^n * 997 * 10007)
	assert(v == bn2)

	for i=2,n do
		_, v = co_resume(co)
		assert(v == bn2, i)
	end

	_, v = co_resume(co)
	assert(v == bc.new(997))

	_, v = co_resume(co)
	assert(v == bc.new(10007))
end or nil

return {
	factorize = factorize,
	factorizeM = factorizeM,
	factorizeT = factorizeT,
	--
	demo = demo
}
