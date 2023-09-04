--
--	from src/egypfrac.c
--
--	a part of main		to	egyptianFraction
--	egyptianFraction	to	egyptianFractionR
--	egyptianFraction	to	egyptianFractionB
--	egyptianFraction	to	egyptianFractionM (depends on lbc(*))
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

local function body(n, d)
	while d % n ~= 0 do
		local t = d // n + 1
		yield(t)
		n, d = n * t - d, d * t
	end
	return d // n
end

local function bodyR(n, d)
	if d % n ~= 0 then
		local t = d // n + 1
		yield(t)
		return bodyR(n * t - d, d * t)
	end
	return d // n
end

local hasBC, M = pcall(require, "bc")
local isZero = hasBC and M.iszero or nil
local bn1 = hasBC and M.new(1) or nil

local bodyM = hasBC and function (n, d)
	local n, d = M.new(n), M.new(d)
	while not isZero(d % n) do
		local t = d / n + bn1
		yield(t)
		n, d = n * t - d, d * t
	end
	return d / n
end or nil

--

local function coStepsA(coBody, coFirst, coRest, coPost)
	return function (n, d)
		local co = create(coBody)

		coFirst(co, n, d)
		while status(co) == "suspended" do
			coRest(co)
		end
		coPost()
	end
end

local function coFirst(co, n, d)
	local _, v = resume(co, n, d)
	write(("1/%s"):format(v))
end

local function coRest(co)
	local _, v = resume(co)
	write((" + 1/%s"):format(v))
end

local function coPost()
	write("\n")
end

--

local function coStepsB(coBody, coResume)
	return function (n, d)
		local co = create(coBody)

		coResume(co, n, d)
		while status(co) == "suspended" do
			coResume(co)
		end
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

--

return {
	egyptianFraction = coStepsA(body, coFirst, coRest, coPost),
	egyptianFractionR = coStepsA(bodyR, coFirst, coRest, coPost),
	egyptianFractionB = function (n, d)
		local b = makeBuffer()
		coStepsB(body, buffering(b))(n, d)
		b:writeln()
	end,
	egyptianFractionM = hasBC and function (n, d)
		local b = makeBuffer()
		coStepsB(bodyM, buffering(b))(n, d)
		b:writeln()
	end or nil
}
