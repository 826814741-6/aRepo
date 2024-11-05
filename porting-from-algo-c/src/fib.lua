--
--	from src/fib.c
--
--	int fib1(int)		to	fib1
--	int fib2(int)		to	fib2
--	a part of main		to	fib3
--	fib3			to	fib4
--

local floor, sqrt = math.floor, math.sqrt

local function fib1(n)
	return floor((((1 + sqrt(5)) / 2) ^ n) / sqrt(5) + 0.5)
end

local function fib2(n)
	if n <= 0 then return 0 end
	local a, b, c, x, y = 1, 1, 0, 1, 0
	n = n - 1
	while n > 0 do
		if n & 1 ~= 0 then
			x, y = a * x + b * y, b * x + c * y
		end
		a, b, c = a * a + b * b, b * (a + c), b * b + c * c
		n = n // 2
	end
	return x
end

local function fib3(n)
	local a, b, c = 0, 1, 1
	while c <= n do
		a, b, c = b, a + b, c + 1
	end
	return a
end

local function fib4(n)
	function rec(a, b, c)
		if c <= n then
			return rec(b, a + b, c + 1)
		else
			return a
		end
	end
	return rec(0, 1, 1)
end

return {
	fib1 = fib1,
	fib2 = fib2,
	fib3 = fib3,
	fib4 = fib4
}
