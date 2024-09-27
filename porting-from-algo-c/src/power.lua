--
--	from src/power.c
--
--	double ipower(double, int)	to	iPow
--	iPow				to	iPowR
--	double power(double, double)	to	fPow
--

local abs = require '_helper'.abs

local function iPow(x0, n)
	local x, r, t = x0, 1, abs(n)
	while t ~= 0 do
		x, r, t = x*x, t&1==1 and r*x or r, t>>1
	end
	return n < 0 and 1 / r or r
end

local function rec(x, n, r, t)
	if t ~= 0 then
		return rec(x*x, n, t&1==1 and r*x or r, t>>1)
	end
	return n < 0 and 1 / r or r
end

local function iPowR(x, n)
	return rec(x, n, 1, abs(n))
end

local m_exp, m_log = math.exp, math.log

local function fPow(x, n)
	return x > 0 and m_exp(n * m_log(x)) or 0
end

return {
	iPow = iPow,
	iPowR = iPowR,
	fPow = fPow
}
