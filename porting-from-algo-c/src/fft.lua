--
--	from src/fft.c
--
--	void make_sintbl(int, double [])	to	makeSinTable
--	void make_bitrev(int, int [])		to	makeBitReverseTable
--	int fft(int, double [], double [])	to	cooleyTukey
--

local getValueOrInit = require '_helper'.getValueOrInit
local isBool = require '_helper'.isBool

local PI = math.pi
local m_sin, m_sqrt = math.sin, math.sqrt

local function makeSinTable(n)
	local tbl = {}

	local dc = 2 * m_sin(PI / n) * m_sin(PI / n)
	local ds = m_sqrt(dc * (2 - dc))
	local t = 2 * dc

	local c, s = 1, 0
	tbl[n//4], tbl[0] = c, s

	for i=1,(n//8)-1 do
		c, s = c - dc, s + ds
		tbl[(n//4) - i], tbl[i] = c, s
		dc, ds = dc + (t * c), ds - (t * s)
	end

	if n//8 ~= 0 then tbl[n//8] = m_sqrt(0.5) end

	for i=0,n//4-1 do
		tbl[(n//2) - i], tbl[(n//2) + i] = tbl[i], -tbl[i]
	end

	return tbl
end

local function makeBitReverseTable(n)
	local tbl = {}

	local i, j = 0, 0

	while true do
		tbl[i], i = j, i + 1
		if i >= n then break end

		local k = n // 2
		while k <= j do
			j, k = j - k, k // 2
		end
		j = j + k
	end

	return tbl
end

local function cooleyTukey(n)
	local sT, bT = makeSinTable(n), makeBitReverseTable(n)

	return function (x, y, isInverse)
		isInverse = getValueOrInit(isBool, isInverse, false)

		for i=0,n-1 do
			local j = bT[i]
			if i < j then
				x[i], x[j] = x[j], x[i]
				y[i], y[j] = y[j], y[i]
			end
		end

		local k = 1
		while k < n do
			local h, d = 0, n // (k + k)
			for j=0,k-1 do
				local c, s = sT[h + n//4], isInverse and -sT[h] or sT[h]
				for i=j,n-1,k+k do
					local ik = i + k
					local dx = s * y[ik] + c * x[ik]
					local dy = c * y[ik] - s * x[ik]
					x[ik], x[i] = x[i] - dx, x[i] + dx
					y[ik], y[i] = y[i] - dy, y[i] + dy
				end
				h = h + d
			end
			k = k + k
		end

		if not isInverse then
			for i=0,n-1 do
				x[i], y[i] = x[i] / n, y[i] / n
			end
		end
	end
end

return {
	cooleyTukey = cooleyTukey
}
