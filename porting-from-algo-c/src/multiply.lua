--
--	from src/multiply.c
--
--	unsigned multiply(unsigned, unsigned)	to	mulA, mulB, mulC
--

local function mulA(a, b)
	local r = 0
	while a ~= 0 do
		if a % 2 == 1 then r = r + b end
		b, a = b * 2, a // 2
	end
	return r
end

local function mulB(a, b)
	local r = 0
	while a ~= 0 do
		if a & 1 == 1 then r = r + b end
		b, a = b << 1, a >> 1
	end
	return r
end

local function mulC(a, b)
	function rec(a, b, r)
		return a ~= 0 and rec(a>>1, b<<1, a&1==1 and r+b or r) or r
	end
	return rec(a, b, 0)
end

return {
	mulA = mulA,
	mulB = mulB,
	mulC = mulC
}
