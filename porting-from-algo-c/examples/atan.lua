--
--	from src/atan.c
--
--	long double latan(long double)		to	atan
--	atan					to	atanR
--	atan					to	atanM (depends on lbc(*))
--	atanR					to	atanMR (depends on lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'atan'

local guessProperLoopCount = M.guessProperLoopCount
local guessProperLoopCountM = M.guessProperLoopCountM

--
--	local aVariable <const> = value
--
--	is one of new features in Lua 5.4.
--
--	>> ... const, which declares a constant variable, that is,
--	>> a variable that cannot be assigned to after its initialization; ...
--	>>
--	>> 3.3.7 - Local Declarations (Lua 5.4 Reference Manual)
--
-- local DBL_EPSILON <const> = 2.2204460492503131E-16
local DBL_EPSILON = 2.2204460492503131E-16

do
	print("-------- atan")
	guessProperLoopCount(-10, 10, 4, DBL_EPSILON, true)

	print("-------- atanM (51-digit)")
	if guessProperLoopCountM ~= nil then
		guessProperLoopCountM(-10, 10, 4, 70, 51, true)
	end
end
