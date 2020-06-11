--
--	from src/3dgraph.c
--
--	a part of main		to	tdGraph
--

local H = require '_helper'

local readOnlyTable = H.readOnlyTable

local MAX_VALUE = math.huge

local function checkParameters(parameters)
	assert(type(parameters) == "table")
	assert(type(parameters.m) == "number")
	assert(type(parameters.n) == "number")
	assert(type(parameters.t) == "number")
	assert(type(parameters.u) == "number")
	assert(type(parameters.minX) == "number")
	assert(type(parameters.minY) == "number")
	assert(type(parameters.minZ) == "number")
	assert(type(parameters.maxX) == "number")
	assert(type(parameters.maxY) == "number")
	assert(type(parameters.maxZ) == "number")
end

local function tdGraph(plotter, aFunction, parameters)
	checkParameters(parameters)
	local P = readOnlyTable(parameters)

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
