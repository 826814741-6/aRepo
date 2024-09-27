--
--	from src/atan.c
--
--	long double latan(long double)		to	atan
--	atan					to	atanR
--	atan					to	atanM (depends on lbc(*))
--	atanR					to	atanMR (depends on lbc(*))
--
--							sampleLoopCount
--							sampleLoopCountM
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local N = 20 -- see the result of sampleLoopCount()

local function loop(x, a, n)
	local r = a
	for i=n,1,-1 do
		r = (i*i*x*x) / (2*i + 1 + r)
	end
	return r
end

local function rec(x, a, i)
	if i > 0 then
		return rec(x, (i*i*x*x) / (2*i + 1 + a), i-1)
	end
	return a
end

local function atan(x, n, pi)
	n = n == nil and N or n
	pi = pi == nil and math.pi or pi
	if x > 1 then
		return pi / 2 - (1/x) / (1 + loop(1/x, 0, n))
	elseif x < -1 then
		return -pi / 2 - (1/x) / (1 + loop(1/x, 0, n))
	else
		return x / (1 + loop(x, 0, n))
	end
end

local function atanR(x, n, pi)
	n = n == nil and N or n
	pi = pi == nil and math.pi or pi
	if x > 1 then
		return pi / 2 - (1/x) / (1 + rec(1/x, 0, n))
	elseif x < -1 then
		return -pi / 2 - (1/x) / (1 + rec(1/x, 0, n))
	else
		return x / (1 + rec(x, 0, n))
	end
end

local hasBC, bc = pcall(require, "bc")
local hasPI, pi = pcall(require, "pi")

local atanM = (hasBC and hasPI) and function (x, n, digit)
	bc.digits(digit)
	return atan(bc.new(x), n, pi.machinLikeM(digit))
end or nil

local atanMR = (hasBC and hasPI) and function (x, n, digit)
	bc.digits(digit)
	return atanR(bc.new(x), n, pi.machinLikeM(digit))
end or nil

--

local function pVerbose(m, n)
	print(
		("%5.2f % .14f % 5g (LOOPCOUNT:%2d) (delta:%g)")
			:format(
				m,
				atan(m, n),
				math.tan(atan(m, n)),
				n,
				math.abs(atan(m, n) - math.atan(m))
			)
	)
end

local function pVerboseM(m, n)
	print(
		("%5.2f %s (LOOPCOUNT:%d)")
			:format(m, atanM(m, n, digit), n)
	)
end

local function sampleLoopCount(l, r, d, border, verbose)
	local t = 0

	for i=l,r do
		local m, n = i/d, 1
		while math.abs(atan(m, n) - math.atan(m)) > border do
			n = n + 1
		end
		t = t < n and n or t

		assert(atan(m, n) == atanR(m, n))

		if verbose == true then
			pVerbose(m, n)
		end
	end

	print(("MAXLOOPCOUNT: %d"):format(t))
end

local sampleLoopCountM = (hasBC and hasPI) and function (l, r, d, digit, verbose)
	local t = 0

	for i=l,r do
		local m, n = i/d, 1
		local curr, prev = atanM(m, n, digit)
		repeat
			n = n + 1
			curr, prev = atanM(m, n, digit), curr
		until bc.iszero(curr - prev)
		n = n - 1
		t = t < n and n or t

		assert(atanM(m, n, digit) == atanMR(m, n, digit))

		if verbose == true then
			pVerboseM(m, n)
		end
	end

	print(("MAXLOOPCOUNT: %d"):format(t))
end or nil

return {
	atan = atan,
	atanR = atanR,
	atanM = atanM,
	atanMR = atanMR,
	--
	sampleLoopCount = sampleLoopCount,
	sampleLoopCountM = sampleLoopCountM
}
