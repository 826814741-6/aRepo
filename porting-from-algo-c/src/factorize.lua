--
--	from src/factoriz.c
--
--	void factorize(int)	to	factorize
--	factorize		to	factorizeM (depends lbc(*))
--	factorize		to	factorizeT
--	factorize		to	factorizeCO (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local create = coroutine.create
local resume = coroutine.resume
local status = coroutine.status
local yield = coroutine.yield
local insert = table.insert

local function f(initialNumber)
	local n = initialNumber

	while n >= 4 and n%2 == 0 do
		yield(2)
		n = n // 2
	end

	local d = 3
	local q = n // d
	while q >= d do
		if n%d == 0 then
			yield(d)
			n = q
		else
			d = d + 2
		end
		q = n // d
	end

	return n
end

local hasBC, bc = pcall(require, 'bc')
local isZero = hasBC and bc.iszero or nil

local fM = hasBC and function (initialValue)
	local bn = bc.new(initialValue)
	local bn2, bn3, bn4 = bc.new(2), bc.new(3), bc.new(4)

	while bn >= bn4 and isZero(bn % bn2) do
		yield(bn2)
		bn = bn / bn2
	end

	local d = bn3
	local q = bn / d
	while q >= d do
		if isZero(bn % d) then
			yield(d)
			bn = q
		else
			d = d + bn2
		end
		q = bn / d
	end

	return bn
end or nil

local function g(co, ...)
	local _, v = resume(co, ...)
	return v
end

local function factorize(n)
	local co = create(f)

	io.write(g(co, n))
	while status(co) == "suspended" do
		io.write(" * ", g(co))
	end
	io.write("\n")
end

local factorizeM = hasBC and function (v)
	local co = create(fM)

	io.write(tostring(g(co, v)))
	while status(co) == "suspended" do
		io.write(" * ", tostring(g(co)))
	end
	io.write("\n")
end or nil

local function factorizeT(n)
	local t = {}
	local co = create(f)

	insert(t, g(co, n))
	while status(co) == "suspended" do
		insert(t, g(co))
	end

	return t
end

local factorizeCO = hasBC and function ()
	return create(fM)
end or nil

return {
	factorize = factorize,
	factorizeM = factorizeM,
	factorizeT = factorizeT,
	factorizeCO = factorizeCO
}
