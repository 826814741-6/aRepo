--
--	from src/pi1.c
--
--	long double pi(void)	to	machinLike
--	machinLike		to	machinLikeM (depends on lbc(*))
--
--	from src/pi2.c
--
--	a part of main		to	gaussLegendre
--	gaussLegendre		to	gaussLegendreM (depends on lbc(*))
--
--	from https://en.wikipedia.org/wiki/Leibniz_formula_for_%CF%80
--
--	a part of article	to	leibniz
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'pi'

local machinLike = M.machinLike
local machinLikeM = M.machinLikeM
local gaussLegendre = M.gaussLegendre
local gaussLegendreM = M.gaussLegendreM
local leibniz = M.leibniz

local function p1(n) print(("%.14f %.20f %q"):format(n, n, n)) end
local function p2(m, n) print(("%.14f %.20f %q (%d)"):format(n, n, n, m)) end

do
	print("-------- machinLike:")
	p1(machinLike())

	print("-------- gaussLegendre n:")
	for i=1,3 do p2(i, gaussLegendre(i)) end

	print("-------- math.pi:")
	p1(math.pi)

	print("-------- math.atan(1) * 4:")
	p1(math.atan(1) * 4)

	print("-------- math.atan(0.0, -0.0):") --
	p1(math.atan(0.0, -0.0))                -- in -5.2, math.atan2

	print("-------- leibniz n:")
	for _,v in ipairs({10000, 100000, 1000000}) do p2(v, leibniz(v)) end

	print("-------- machinLikeM (depends on lbc):")
	if machinLikeM ~= nil then
		print(machinLikeM(52))
	end

	print("-------- gaussLegendreM n (depends on lbc):")
	if gaussLegendreM ~= nil then
		for i=1,6 do print(gaussLegendreM(i, 52), i) end
	end
end
