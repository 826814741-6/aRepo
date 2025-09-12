--
--  from src/hypot.c
--
--    double hypot0(double, double)  to  hypot0
--    double hypot1(double, double)  to  hypot1
--    double hypot2(double, double)  to  hypot2 (Moler-Morrison)
--

local m_abs, m_sqrt = math.abs, math.sqrt

local function hypot0(x, y)
	return m_sqrt(x * x + y * y)
end

local function hypot1(x, y)
	if x == 0 then return m_abs(y) end
	if y == 0 then return m_abs(x) end
	return m_abs(x) < m_abs(y) and
		m_abs(y) * m_sqrt(1 + (x/y) * (x/y)) or
		m_abs(x) * m_sqrt(1 + (y/x) * (y/x))
end

local function gHypot(abs)
	return function (x, y)
		local a, b = abs(x), abs(y)
		if a < b then a, b = b, a end
		if b == 0 then return a end
		for _=1,3 do
			local t = (b/a)*(b/a) / (4 + (b/a)*(b/a))
			a, b = a + 2 * a * t, b * t
		end
		return a
	end
end

local hypot2 = gHypot(m_abs)

return {
	hypot0 = hypot0,
	hypot1 = hypot1,
	hypot2 = hypot2,
	--
	gHypot = gHypot
}
