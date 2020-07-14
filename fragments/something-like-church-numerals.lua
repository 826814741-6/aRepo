--
--	something-like-church-numerals.lua
--
--	porting from:
--	https://gist.github.com/vivekhaldar/2438498
--
--	in other langs:
--	https://www.rosettacode.org/wiki/Church_Numerals
--

function Zero(f)
	return function (x) return x end
end

function Succ(n)
	return function (f)
		return function(x)
			return f(n(f)(x))
		end
	end
end

function Add(m)
	return function (n)
		return function (f)
			return function (x)
				return n(f)(m(f)(x))
			end
		end
	end
end

function Mul(m)
	return function (n)
		return function (f)
			return function (x)
				return n(m(f))(x)
			end
		end
	end
end

function Exp(m)
	return function (n)
		return n(m)
	end
end

--

function Pred(n)
	return function (f)
		return function (x)
			return n(function (g) return function (h) return h(g(f)) end end)(function (y) return x end)(function (x) return x end)

			-- following code (above + newline) raise error in LuaJIT-2.0.5 (not raise in Lua-5.4.0)
			-- return n(function (g) return function (h) return h(g(f)) end end)
			--         (function (y) return x end)
			--         (function (x) return x end)
			-- > luajit.exe: ...:...: ambiguous syntax (function call x new statement) near '('
		end
	end
end

function Sub(n)
	return function (m)
		return m(Pred)(n)
	end
end

--

function toChurch(n)
	if n ~= 0 then
		return Succ(toChurch(n-1))
	end
	return Zero

	-- or (not proper tail call version)
	-- return n~=0 and Succ(toChurch(n-1)) or Zero
end

function toNumber(c)
	return c(function (x) return x+1 end)(0)
end

--------------------------------------------------------------------------------

do
	local four, three = toChurch(4), toChurch(3)

	assert(7 == toNumber(Add(four)(three)))
	assert(12 == toNumber(Mul(four)(three)))
	assert(64 == toNumber(Exp(four)(three)))
	assert(1 == toNumber(Sub(four)(three)))
end
