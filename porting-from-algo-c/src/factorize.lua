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

local create = coroutine.create
local resume = coroutine.resume
local status = coroutine.status
local yield = coroutine.yield
local write = io.write
local concat = table.concat
local insert = table.insert

local function body(initialNumber)
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
local bn2 = hasBC and bc.new(2) or nil
local bn3 = hasBC and bc.new(3) or nil
local bn4 = hasBC and bc.new(4) or nil

local bodyM = hasBC and function (initialValue)
	local bn = bc.new(initialValue)

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

--

local function coStepsA(coBody, coFirst, coRest, coPost)
	return function (n)
		local co = create(coBody)

		coFirst(co, n)
		while status(co) == "suspended" do
			coRest(co)
		end
		coPost()
	end
end

local function coFirst(co, n)
	local _, v = resume(co, n)
	write(("%s"):format(v))
end

local function coRest(co)
	local _, v = resume(co)
	write((" * %s"):format(v))
end

local function coPost()
	write("\n")
end

--

local function coStepsB(coBody, coResume)
	return function (n)
		local co = create(coBody)

		coResume(co, n)
		while status(co) == "suspended" do
			coResume(co)
		end
	end
end

local function buffering(buf)
	return function (co, ...)
		local _, v = resume(co, ...)
		buf:insert(("%s"):format(v))
	end
end

local function makeBuffer()
	local T = { buf = {} }

	function T:insert(s)
		insert(T.buf, s)
	end

	function T:writeln()
		write(concat(T.buf, " * "), "\n")
	end

	return T
end

local function demo(n)
	local co = create(bodyM)

	local _, v = resume(co, bn2 ^ n * 997 * 10007)
	assert(v == bn2)

	for i=2,n do
		_, v = resume(co)
		assert(v == bn2)
	end

	_, v = resume(co)
	assert(v == bc.new(997))

	_, v = resume(co)
	assert(v == bc.new(10007))
end

--

return {
	factorize = coStepsA(body, coFirst, coRest, coPost),
	factorizeM = hasBC and coStepsA(bodyM, coFirst, coRest, coPost) or nil,
	factorizeT = hasBC and function (n)
		local b = makeBuffer()
		coStepsB(bodyM, buffering(b))(n)
		b:writeln()
	end or nil,
	demo = hasBC and demo or nil
}
