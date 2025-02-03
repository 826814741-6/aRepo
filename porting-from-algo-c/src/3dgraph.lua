--
--	from src/3dgraph.c
--
--	a part of main		to	tdGraph
--

local isNum = require '_helper'.isNum
local isTbl = require '_helper'.isTbl

local MAX_VALUE = math.huge

local function checkParameters(parameters)
	assert(isTbl(parameters))
	assert(isNum(parameters.m))
	assert(isNum(parameters.n))
	assert(isNum(parameters.t))
	assert(isNum(parameters.u))
	assert(isNum(parameters.minX))
	assert(isNum(parameters.minY))
	assert(isNum(parameters.minZ))
	assert(isNum(parameters.maxX))
	assert(isNum(parameters.maxY))
	assert(isNum(parameters.maxZ))
	return parameters
end

local function tdGraph(plotter, aFunction, parameters)
	local P = checkParameters(parameters)

	local lowerHorizon, upperHorizon = {}, {}

	for i=0,P.m+4*P.n do
		lowerHorizon[i], upperHorizon[i] = MAX_VALUE, -MAX_VALUE
	end

	for i=0,P.n do
		local flagA = false
		local z = P.minZ + (P.maxZ - P.minZ) / P.n * i
		for j=0,P.m do
			local flagB = false
			local idx = j + 2 * (P.n - i)

			local x = P.minX + (P.maxX - P.minX) / P.m * j
			local y = P.t * (aFunction(x, z) - P.minY) / (P.maxY - P.minY) + P.u * i

			if y < lowerHorizon[idx] then
				lowerHorizon[idx], flagB = y, true
			end

			if y > upperHorizon[idx] then
				upperHorizon[idx], flagB = y, true
			end

			if flagB and flagA then
				plotter:draw(2 * idx, 2 * y)
			else
				plotter:move(2 * idx, 2 * y)
			end

			flagA = flagB
		end
	end
end

return {
	tdGraph = tdGraph
}
