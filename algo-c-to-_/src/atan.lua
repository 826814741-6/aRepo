--
--	from src/atan.c
--
--	long double latan(long double)		to	atan
--	atan					to	atanR
--	atan					to	atanM (depends lbc(*))
--	atanR					to	atanMR (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/)
--

local N = 20 -- see the result of guessProperLoopCount()

local function loop(x, a, n)
	local r = a
	for i=n,1,-1 do
		r = (i*i*x*x) / (2*i + 1 + r)
	end
	return r
end

local function iter(x, a, i)
	if i > 0 then
		return iter(x, (i*i*x*x) / (2*i + 1 + a), i-1)
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
		return pi / 2 - (1/x) / (1 + iter(1/x, 0, n))
	elseif x < -1 then
		return -pi / 2 - (1/x) / (1 + iter(1/x, 0, n))
	else
		return x / (1 + iter(x, 0, n))
	end
end

local ret0, M = pcall(require, "bc")
local ret1, H = pcall(require, "pi")

local atanM = (ret0 and ret1) and function (x, n, digit)
	M.digits(digit)
	return atan(M.new(x), n, H.machinLikeM(digit))
end or nil

local atanMR = (ret0 and ret1) and function (x, n, digit)
	M.digits(digit)
	return atanR(M.new(x), n, H.machinLikeM(digit))
end or nil

local function guessProperLoopCount(l, r, d, border, verbose)
	local t = 0

	for i=l,r do
		local m, n = i/d, 1
		for j=2,24 do
			n = j
			if math.abs(atan(m,n) - math.atan(m)) <= border then
				break
			end
		end
		t = t < n and n or t

		if verbose == true then
			local a, b, c = atan(m,n), atanR(m,n), math.atan(m)
			assert(a == b,
				("atan(%g,%g) ~= atanR(%g,%g)"):format(m,n,m,n))
			assert(math.abs(a - c) <= border,
				("math.abs(atan(%g,%g) - math.atan(%g)) > %g"):format(m,n,m,border))
			print(("%5.2f % .14f % 5g (LOOPCOUNT:%2d) (delta:%g)"):format(
				m, atan(m,n), math.tan(atan(m,n)), n, math.abs(a-c)))
		end
	end

	if verbose == true then
		print(("MAXLOOPCOUNT: %d"):format(t))
	else
		return t
	end
end

local guessProperLoopCountM = (ret0 and ret1) and function (l, r, d, border, digit, verbose)
	local t = 0

	for i=l,r do
		local m, n = i/d, 1
		local prev = atanM(m, n, digit)
		for j=2,border do
			n = j
			local u = atanM(m, n, digit)
			if M.iszero(u - prev) then break end
			prev = u
		end
		t = t < n and n or t

		if verbose == true then
			local a, b = atanM(m,n,digit), atanMR(m,n,digit)
			assert(M.iszero(a - b),
				("atanM(%g,%g,%g) ~= atanMR(%g,%g,%g)"):format(m,n,digit,m,n,digit))
			print(("%5.2f %s (LOOPCOUNT:%d)"):format(m, a, n))
		end
	end

	if verbose == true then
		print(("MAXLOOPCOUNT: %d"):format(t))
	else
		return t
	end
end or nil

return {
	atan = atan,
	atanR = atanR,
	atanM = atanM,
	atanMR = atanMR,
	--
	guessProperLoopCount = guessProperLoopCount,
	guessProperLoopCountM = guessProperLoopCountM
}
