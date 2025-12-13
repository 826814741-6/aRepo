--
--  from src/maceps.c
--
--    a part of main  to  machineEpsilon
--

local machineEpsilon = require 'machineepsilon'.machineEpsilon

local FLT_EPSILON = 1.19209290e-07          -- from src/float.ie3
local DBL_EPSILON = 2.2204460492503131e-16  -- from src/float.ie3

do
	local iterator = machineEpsilon()
	local it = (function ()
		local e = 2
		return function ()
			e = e / 2
			return e
		end
	end)()

	print(" e              1 + e          (1 + e) - 1    e (%a)")
	print("-------------- -------------- -------------- ---------")

	function pfmt(e)
		assert(e == it())
		print(
			("% -14g % -14g % -14g  %a")
				:format(
					e,
					1 + e,
					(1 + e) - 1,
					e
				)
		)
	end

	for e in iterator do
		pfmt(e)
		if e - FLT_EPSILON <= DBL_EPSILON then
			break
		end
	end

	print("^------- FLT_EPSILON")

	for e in iterator do
		pfmt(e)
	end
end

print("-- cf.")

do
	local it = machineEpsilon()

	it() it()

	for n=1,7 do
		local fmt, e = ("%%-9.%df %%a %%q"):format(n), it()
		print(fmt:format(e, e, e))
	end

--
-- >> Enforce round-to-even semantics. #1363
-- >> -- https://github.com/LuaJIT/LuaJIT/commit/7152e15489d2077cd299ee23e3d51a4c599ab14f
--
-- > LUA_PATH='src/?.lua' luajit-2.1.1765228720 examples/machineepsilon.lua
-- ...
-- > LUA_PATH='src/?.lua' luajit-previous-one examples/machineepsilon.lua
-- ...
--
end
