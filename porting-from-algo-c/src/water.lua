--
--	from src/water.c
--
--	a part of main		to	isMeasurable
--

local M = require 'gcd'

local gcd = M.gcdL

local function isMeasurable(a, b, v)
	return (v <= a or v <= b) and (v % gcd(a, b)) == 0
end

return {
	isMeasurable = isMeasurable
}
