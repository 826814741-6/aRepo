--
--	from src/maceps.c
--
--	a part of main		to	machineEpsilon
--

function machineEpsilon()
	local co = coroutine.create(function ()
		local e = 1
		while 1 + e > 1 do
			coroutine.yield(e)
			e = e / 2
		end
	end)
	return function ()
		local _, res = coroutine.resume(co)
		return res
	end
end

return {
	machineEpsilon = machineEpsilon
}
