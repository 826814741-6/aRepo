--
--	from src/gamma.c
--
--	double loggamma(double)		to	loggamma
--	double gamma(double)		to	gamma
--	double beta(double, double)	to	beta
--

--
--	local aVariable <const> = value
--
--	is one of new features in Lua 5.4.
--
--	>> ... const, which declares a constant variable, that is,
--	>> a variable that cannot be assigned to after its initialization; ...
--	>>
--	>> 3.3.7 - Local Declarations (Lua 5.4 Reference Manual)
--
-- local PI <const> = math.pi

local PI = math.pi
local LOG_2PI = 1.83787706640934548
local N = 8

-- local B0 = 1
-- local B1 = -1.0 / 2.0
local B2 = 1.0 / 6.0
local B4 = -1.0 / 30.0
local B6 = 1.0 / 42.0
local B8 = -1.0 / 30.0
local B10 = 5.0 / 66.0
local B12 = -691.0 / 2730.0
local B14 = 7.0 / 6.0
local B16 = -3617.0 / 510.0

local m_exp, m_log, m_sin = math.exp, math.log, math.sin

local function loggamma(x0)
	local v, x = 1, x0
	while x < N do v, x = v * x, x + 1 end
	local w = 1 / (x * x)
	return ((((((((B16 / (16 * 15)) * w + (B14 / (14 * 13))) * w
		+ (B12 / (12 * 11))) * w + (B10 / (10 * 9))) * w
		+ (B8 / (8 * 7))) * w + (B6 / (6 * 5))) * w
		+ (B4 / (4 * 3))) * w + (B2 / (2 * 1))) / x
		+ 0.5 * LOG_2PI - m_log(v) - x + (x - 0.5) * m_log(x)
end

local function gamma(x)
	if x < 0 then
		return PI / (m_sin(PI * x) * m_exp(loggamma(1 - x)))
	else
		return m_exp(loggamma(x))
	end
end

local function beta(x, y)
	return m_exp(loggamma(x) + loggamma(y) - loggamma(x + y))
end

return {
	loggamma = loggamma,
	gamma = gamma,
	beta = beta
}
