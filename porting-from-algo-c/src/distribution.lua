--
--	from src/chi2.c
--	from src/normal.c
--
--	double p_nor(double)		to	pNormal
--	double q_nor(double)		to	qNormal
--	double q_chi2(int, double)	to	qChiSquare
--	double p_chi2(int, double)	to	pChiSquare
--
--	from src/fdist.c
--
--	double q_f(int, int, double)	to	qF
--	double p_f(int, int, double)	to	pF
--
--	from src/tdist.c
--
--	double p_t(int, double)		to	pT
--	double q_t(int, double)		to	qT
--

local PI = math.pi

local m_atan = math.atan
local m_exp = math.exp
local m_sqrt = math.sqrt

local function pNormal(z, n)
	n = n ~= nil and n or 200

	local t = z * m_exp(-0.5 * z * z) / m_sqrt(2 * PI)
	local p = t

	for i=3,n,2 do
		t = t * ((z*z) / i)
		local prev = p
		p = p + t
		if p == prev then return 0.5 + p end
	end

	return z > 0 and 1 or 0
end

local function qNormal(z)
	return 1 - pNormal(z)
end

local function qChiSquare(df, chiSq)
	function loop(k0, t0)
		local t, u = t0, t0
		for k=k0,df-1,2 do
			t = t * (chiSq / k)
			u = u + t
		end
		return u
	end

	if df % 2 == 1 then
		if df == 1 then return 2 * qNormal(m_sqrt(chiSq)) end
		return 2 * (qNormal(m_sqrt(chiSq)) +
			loop(3, m_sqrt(chiSq) * m_exp(-0.5 * chiSq) / m_sqrt(2 * PI)))
	else
		return loop(2, m_exp(-0.5 * chiSq))
	end
end

local function pChiSquare(df, chiSq)
	return 1 - qChiSquare(df, chiSq)
end

local function qF(df1, df2, f)
	if f <= 0 then return 1 end

	if df1 % 2 ~= 0 and df2 % 2 == 0 then
		return 1 - qF(df2, df1, 1/f)
	end

	local cos2 = 1 / (1 + df1 * f / df2)
	local sin2 = 1 - cos2

	if df1 % 2 == 0 then
		local p = cos2 ^ (df2 / 2)
		local t = p
		for i=2,df1-1,2 do
			t = t * ((df2 + i - 2) * sin2 / i)
			p = p + t
		end
		return p
	else
		local p = m_atan(m_sqrt(df2 / (df1 * f)))
		local t = m_sqrt(sin2 * cos2)
		for i=3,df1,2 do
			p, t = p + t, t * ((i - 1) * sin2 / i)
		end
		t = t * df1
		for i=3,df2,2 do
			p, t = p - t, t * ((df1 + i - 2) * cos2 / i)
		end
		return p * 2 / PI
	end
end

local function pF(df1, df2, f)
	if f <= 0 then return 0 end
	return qF(df2, df1, 1/f)
end

local function pT(df, t)
	local cos2 = df / (df + t * t)

	local p = 0
	local s = t < 0 and -m_sqrt(1 - cos2) or m_sqrt(1 - cos2)

	for i=df%2+2,df,2 do
		p, s = p + s, s * ((i - 1) * cos2 / i)
	end

	if df % 2 == 1 then
		return 0.5 + (p * m_sqrt(cos2) + m_atan(t/m_sqrt(df))) / PI
	else
		return (1 + p) / 2
	end
end

local function qT(df, t)
	return 1 - pT(df, t)
end

return {
	pNormal = pNormal,
	qNormal = qNormal,
	qChiSquare = qChiSquare,
	pChiSquare = pChiSquare,
	pF = pF,
	qF = qF,
	pT = pT,
	qT = qT
}
