--
--  from src/komachi.c
--
--    a part of main  to  komachi
--

--
--  _ 1 _ 2 _ 3 _ 4 _ 5 _ 6 _ 7 _ 8 _ 9 = 100
--

local function init()
	local r = {}
	for i=1,9 do r[i] = -1 end
	return r
end

local function is100(a)
	local x, sign, n = 0, 1, 0
	for i=1,9 do
		if a[i] == 0 then
			n = 10 * n + i
		else
			x, sign, n = x + sign * n, a[i], i
		end
	end
	x = x + sign * n
	return x == 100
end

local function step(a)
	local i = 9
	local sign = a[i] + 1
	while sign > 1 do
		a[i], i = -1, i - 1
		sign = a[i] + 1
	end
	a[i] = sign
end

local function komachi(f)
	local a = init()
	repeat
		if is100(a) then f(a) end
		step(a)
	until a[1] >= 1
end

return {
	komachi = komachi
}
