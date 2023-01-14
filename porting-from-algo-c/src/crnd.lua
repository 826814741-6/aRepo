--
--	from src/crnd.c
--
--	void init_rnd(unsigned long)		to	crnd; :init
--	unsigned long irnd(void)		to	crnd; :irnd
--	double rnd(void)			to	crnd; :rnd
--

local N = 18446744073709551616 -- ULONG_MAX of C (limits.h) + 1; see below

--
-- >> The type number represents both integer numbers and real (floating-point)
-- >>  numbers, using two subtypes: integer and float.
-- >>
-- >> Standard Lua uses 64-bit integers and double-precision (64-bit) floats,
-- >> but you can also compile Lua so that it uses 32-bit integers and/or
-- >> single-precision (32-bit) floats.
-- >>
-- >> 2.1 - Values and Types (Lua 5.4 Reference Manual)
--
--   ...(float)... [math.mininteger ...(integer/float)... math.maxinteger] ...(float)...
--
-- ..., and the 'integer' type of Lua seems to be signed by default.
--
-- assert(math.maxinteger == 9223372036854775807)
-- assert(math.mininteger == -9223372036854775808)
--
-- assert(math.type(N) == 'float')
-- assert(N == 18446744073709551615.0)
--

local function crnd(x)
	local T = { seed = x ~= nil and x or 1 }

	function T:init(x)
		T.seed = x
	end

	function T:irnd() -- see below
		T.seed = T.seed * 1566083941 + 1
		return T.seed
	end

	function T:rnd() -- see below
		local r = (1 / N) * T:irnd()
		return r < 0 and 1 + r or r
	end

	return T
end

--
-- Wrapping around in case of overflows in 'interger' arithmetic; in 5.4(5.3-)
--
-- assert(math.mininteger == (math.maxinteger+1))
-- assert(math.maxinteger > (math.maxinteger+1))
-- cf. assert(math.ult(math.maxinteger, math.maxinteger+1) == true)
--
-- >> In case of overflows in integer arithmetic, all operations wrap around,
-- >> according to the usual rules of two-complement arithmetic.
-- >>
-- >> (In other words, they return the unique representable integer that is
-- >> equal modulo 2^n to the mathematical result, where n is the number of bits
-- >> of the integer type.)
-- >>
-- >> 3.4.1 - Arithmetic Operators (Lua 5.4 Reference Manual)
--

return {
	crnd = crnd
}
