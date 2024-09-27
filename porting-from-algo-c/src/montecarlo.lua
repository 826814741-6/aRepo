--
--	from src/monte.c
--
--	void monte1(int)	to	piA
--	void monte2(int)	to	piB
--	void monte3(int)	to	piC
--

local m_sqrt = math.sqrt

local function piA(n, rand)
	local hit = 0

	for _=1,n do
		local x, y = rand:rnd(), rand:rnd()
		if x*x + y*y < 1 then hit = hit + 1 end
	end

	local p = hit / n

	return 4 * p, 4 * m_sqrt(p * (1 - p) / (n - 1))
end

local function piB(n, rand)
	local sum, sumSq = 0, 0

	for _=1,n do
		local x = rand:rnd()
		local y = m_sqrt(1 - x * x)
		sum, sumSq = sum + y, sumSq + y * y
	end

	local mean = sum / n
	local sd = m_sqrt((sumSq / n - mean * mean) / (n - 1))

	return 4 * mean, 4 * sd
end

local function piC(n)
	local a = (m_sqrt(5) - 1) / 2

	local x, sum = 0, 0
	for _=1,n do
		x = x + a
		if x >= 1 then x = x - 1 end
		sum = sum + m_sqrt(1 - x * x)
	end

	return 4 * sum / n
end

return {
	piA = piA,
	piB = piB,
	piC = piC
}
