--
--	from src/fib.c
--
--	int fib1(int)		to	fib1
--	int fib2(int)		to	fib2
--	a part of main		to	fib3
--	fib3			to	fib4
--

local floor, pow, sqrt = math.floor, math.pow, math.sqrt

local function fib1(n)
	return floor(pow((1 + sqrt(5)) / 2, n) / sqrt(5) + 0.5)
end

local function fib2(n)
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
	a, b, c = 1, 0, 1
	while c < n do
		a, b, c = a + b, a, c + 1
	end
	return a
end

local function fib4(n)
	function iter(a, b, c)
		if c < n then
			return iter(a + b, a, c + 1)
		else
			return a
		end
	end
	return iter(1, 0, 1)
end

return {
	fib1 = fib1,
	fib2 = fib2,
	fib3 = fib3,
	fib4 = fib4
}
