--
--  svgplot_helper.lua: some helper functions for svgplot.lua
--

local t_concat, t_insert = table.concat, table.insert

local function B_startStep(self, fh, limit)
	self.v, self.n, self.fh, self.limit = {}, 0, fh, limit
	return self
end

local function B_write(self, s)
	t_insert(self.v, s)
	self.n = self.n + 1
	if self.n >= self.limit then
		self.fh:write(t_concat(self.v))
		self.v, self.n = {}, 0
	end
	return self
end

local function B_endStep(self)
	if self.n > 0 then
		self.fh:write(t_concat(self.v))
	end
	self.v, self.n, self.fh, self.limit = {}, 0, nil, self.DEFAULT_LIMIT
	return self
end

local function gMakeBuffer(defaultLimit)
	return function ()
		local T = {
			v = {},
			n = 0,
			fh = nil,
			limit = defaultLimit,
			DEFAULT_LIMIT = defaultLimit
		}

		T.startStep, T.write, T.endStep = B_startStep, B_write, B_endStep

		return T
	end
end

local function toRGB(n)
	return n >> 16, (n >> 8) & 0xff, n & 0xff
end

return {
	gMakeBuffer = gMakeBuffer,
	toRGB = toRGB
}
