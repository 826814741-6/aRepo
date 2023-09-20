--
--	a-self-in.lua
--
--	> lua[jit] a-self-in.lua
--

--
-- >> The colon syntax is used to emulate methods, adding an implicit extra
-- >> parameter self to the function. Thus, the statement
-- >>
-- >>      function t.a.b.c:f (params) body end
-- >>
-- >> is syntactic sugar for
-- >>
-- >>      t.a.b.c.f = function (self, params) body end
-- >>
-- >> -- from: Lua 5.4 Reference Manual > 3.4.11
--

function f(n)
	local T = {
		r = {},
		t = {
			r = {},
			n = n
		}
	}

	function T.getA(self)
		return ("%s %s\n%s %s %s\n%s %s\n%s %s %s\n%d %d"):format(
			T, self,
			T.r, self.r, "<-",
			T.t, self.t,
			T.t.r, self.t.r, "<-",
			T.t.n, self.t.n
		)
	end

	function T:getB()
		return ("%s %s\n%s %s %s\n%s %s\n%s %s %s\n%d %d"):format(
			T, self,
			T.r, self.r, "<-",
			T.t, self.t,
			T.t.r, self.t.r, "<-",
			T.t.n, self.t.n
		)
	end

	function T.setA(self, t, n)
		T.r, self.t.r = t, t
		self.t.n = n
	end

	function T:setB(t, n)
		self.r, T.t.r = t, t
		T.t.n = n
	end

	return T
end

do
	function p(n, a)
		assert(a:getA() == a.getB(a))
		-- cf. https://stackoverflow.com/questions/27633331/can-i-check-strings-equality-in-lua

		print(("-- %d\n%s"):format(n, a:getB()))
	end

	local a = f(1)

	p(1, a)

	a:setA({}, 100)  -- a.setA(a, {}, 100)

	p(2, a)

	a.setB(a, {}, 0) -- a:setB({}, 0)

	p(3, a)
end

--
-- -- 1
-- table: 0x7f5fa2da0600 table: 0x7f5fa2da0600
-- table: 0x7f5fa2da0648 table: 0x7f5fa2da0648 <-
-- table: 0x7f5fa2da0188 table: 0x7f5fa2da0188
-- table: 0x7f5fa2da01d0 table: 0x7f5fa2da01d0 <-
-- 1 1
-- -- 2
-- table: 0x7f5fa2da0600 table: 0x7f5fa2da0600
-- table: 0x7f5fa2d98990 table: 0x7f5fa2d98990 <-
-- table: 0x7f5fa2da0188 table: 0x7f5fa2da0188
-- table: 0x7f5fa2d98990 table: 0x7f5fa2d98990 <-
-- 100 100
-- -- 3
-- table: 0x7f5fa2da0600 table: 0x7f5fa2da0600
-- table: 0x7f5fa2d989d8 table: 0x7f5fa2d989d8 <-
-- table: 0x7f5fa2da0188 table: 0x7f5fa2da0188
-- table: 0x7f5fa2d989d8 table: 0x7f5fa2d989d8 <-
-- 0 0
--
