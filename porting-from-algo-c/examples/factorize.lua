--
--  from src/factoriz.c
--
--    void factorize(int)  to  factorize
--    factorize            to  factorizeM (depends on lbc(*))
--    factorize            to  factorizeT (depends on lbc(*))
--
--  *) bc library for Lua 5.4 / Jul 2018 / based on GNU bc-1.07
--  (lbc-101; see https://web.tecgraf.puc-rio.br/~lhf/ftp/lua/#lbc)
--

local M = require 'factorize'

local factorize = M.factorize
local factorizeM = M.factorizeM
local factorizeT = M.factorizeT
local demo = M.demo

do
	for i=1,100 do
		io.write(("%5d = "):format(i))
		factorize(i)

		if factorizeM ~= nil then
			io.write(("%5d = "):format(i))
			factorizeM(i)
		end

		if factorizeT ~= nil then
			io.write(("%5d = "):format(i))
			io.write(table.concat(factorizeT(i), " * "), "\n")
		end
	end

	if demo ~= nil then
		demo(10000)
	end
end
