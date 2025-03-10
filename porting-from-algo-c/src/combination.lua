--
--	from src/combinat.c
--
--	int comb(int, int)				to	combinationR
--	unsigned long combination(int, int)		to	combination
--	combination					to	combinationM (depends on lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local function combinationR(n, k)
	if k == 0 or k == n then return 1 end
	if k == 1 then return n end
	return combinationR(n - 1, k - 1) + combinationR(n - 1, k)
end

local function _combination(f)
	return function (n, k)
		if n - k < k then k = n - k end

		if k == 0 then return 1 end
		if k == 1 then return n end

		local a = {}

		for i=1,k-1 do
			a[i] = f(i) + 2
		end

		for i=3,n-k+1 do
			a[0] = f(i)
			for j=1,k-1 do
				a[j] = a[j] + a[j - 1]
			end
		end

		return a[k - 1]
	end
end

local id = require '_helper'.id

local hasBC, bc = pcall(require, "bc")
local bc_new = hasBC and bc.new or nil

return {
	combinationR = combinationR,
	combination = _combination(id),
	combinationM = hasBC and _combination(function (n)
		return bc_new(n)
	end) or nil
}
