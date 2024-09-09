--
--	from src/factoriz.c
--
--	void factorize(int)	to	factorize
--	factorize		to	factorizeM (depends on lbc(*))
--	factorize		to	factorizeT (depends on lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local i_write = io.write

local function factorize(x)
	local n = x

	while n >= 4 and n % 2 == 0 do
		i_write("2 * ")
		n = n // 2
	end

	local d = 3
	local q = n // d
	while q >= d do
		if n % d == 0 then
			i_write(("%d * "):format(d))
			n = q
		else
			d = d + 2
		end
		q = n // d
	end

	i_write(("%d\n"):format(n))
end

local hasBC, bc = pcall(require, 'bc')
local isZero = hasBC and bc.iszero or nil
local bc_new = hasBC and bc.new or nil
local bn2 = hasBC and bc_new(2) or nil
local bn4 = hasBC and bc_new(4) or nil

local factorizeM = hasBC and function (x)
	local bn = bc_new(x)

	while bn >= bn4 and isZero(bn % bn2) do
		i_write("2 * ")
		bn = bn / bn2
	end

	local d = bc_new(3)
	local q = bn / d
	while q >= d do
		if isZero(bn % d) then
			i_write(("%s * "):format(d))
			bn = q
		else
			d = d + bn2
		end
		q = bn / d
	end

	i_write(("%s\n"):format(bn))
end or nil

local t_insert = table.insert

local factorizeT = hasBC and function (x)
	local bn, t = bc_new(x), {}

	while bn >= bn4 and isZero(bn % bn2) do
		t_insert(t, "2")
		bn = bn / bn2
	end

	local d = bc_new(3)
	local q = bn / d
	while q >= d do
		if isZero(bn % d) then
			t_insert(t, tostring(d))
			bn = q
		else
			d = d + bn2
		end
		q = bn / d
	end

	t_insert(t, tostring(bn))

	return t
end or nil

local co_create = coroutine.create
local co_resume = coroutine.resume
local co_yield = coroutine.yield

local bodyM = hasBC and function (x)
	local bn = bc_new(x)

	while bn >= bn4 and isZero(bn % bn2) do
		co_yield(bn2)
		bn = bn / bn2
	end

	local d = bc_new(3)
	local q = bn / d
	while q >= d do
		if isZero(bn % d) then
			co_yield(d)
			bn = q
		else
			d = d + bn2
		end
		q = bn / d
	end

	return bn
end or nil

local demo = hasBC and function (n)
	local co = co_create(bodyM)

	local _, v = co_resume(co, bn2^n * 997 * 10007)
	assert(v == bn2)

	for i=2,n do
		_, v = co_resume(co)
		assert(v == bn2)
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
