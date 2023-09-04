--
--	from src/factoriz.c
--
--	void factorize(int)	to	factorize
--	factorize		to	factorizeM (depends on lbc(*))
--	factorize		to	factorizeT (depends on lbc(*))
--
--	*) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--	(lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'factorize'
local hasBC, bc = pcall(require, 'bc')

local factorize = M.factorize
local factorizeM = hasBC and M.factorizeM or nil
local factorizeT = hasBC and M.factorizeT or nil
local demo = hasBC and M.demo or nil

do
	for i=1,100 do
		io.write(("%5d = "):format(i))
		factorize(i)

		if hasBC then
			io.write(("%5d = "):format(i))
			factorizeM(i)

			io.write(("%5d = "):format(i))
			factorizeT(i)
		end
	end

	demo(10000)
end
