--
--	from src/combinat.c
--
--	int comb(int, int)				to	combinationR
--	unsigned long combination(int, int)		to	combination
--	combination					to	combinationM (depends lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'combination'
local H = require '_helper'

local combinationR, combination, combinationM = M.combinationR, M.combination, M.combinationM
local id, tableWriter = H.id, H.tableWriter

do
	print("-------- combinationR (n:0-20, k:0-20)")
	tableWriter(
		{ 0, 20, 1, "L" },
		{ 0, 20, 1 },
		{ 2, 8 },
		{ id, id, function (k, n) return combinationR(n, k) end },
		{ "d", "d", "d" }
	)()

	print("-------- combination (n:0-20, k:0-20)")
	tableWriter(
		{ 0, 20, 1, "L" },
		{ 0, 20, 1 },
		{ 2, 8 },
		{ id, id, function (k, n) return combination(n, k) end },
		{ "d", "d", "d" }
	)()

	print("-------- combination (n:65-67, k:27-39); (see 67)")
	tableWriter(
		{ 65, 67, 1 },
		{ 27, 39, 1 },
		{ 2, 23 },
		{ id, id, function (n, k) return combination(n, k) end },
		{ "d", "d", "d" }
	)()

	if combinationM ~= nil then
		print("-------- combinationM (n:65-67, k:27-39); (see 67)")
		tableWriter(
			{ 65, 67, 1 },
			{ 27, 39, 1 },
			{ 2, 23 },
			{ id, id, function (n, k) return combinationM(n, k) end },
			{ "d", "d", "s" }
		)()

		print("-------- combinationM (n,k: 100,50 / 200,100 / 1000,500)")
		print(combinationM(100, 50)) -- cf. see https://keisan.casio.jp/exec/system/1161228812
		print(combinationM(200, 100))
		print(combinationM(1000, 500))
	end
end
