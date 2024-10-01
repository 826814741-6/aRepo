--
--	something-like-Y.lua
--
--	ported from:
--	https://hg.mozilla.org/mozilla-central/file/tip/js/src/Y.js
--	and its license is MPL-2.0:
--	https://www.mozilla.org/en-US/MPL/2.0/
--
--	> luac -l [-o nul or -o /dev/null] -- src
--	> luajit -bl src
--	> luajit -jdump src
--

function Y(f)
	return (function (x) return f(function(v) return x(x)(v) end) end)(function (x) return f(function(v) return x(x)(v) end) end)
end
--
-- Depending on the position of parentheses, an error may occur in LuaJIT. (not in Lua)
--
-- return (function (x) return f(function(v) return x(x)(v) end) end)
--        (function (x) return f(function(v) return x(x)(v) end) end)
--
-- > luajit.exe something-like-Y.lua
-- luajit.exe: ...:...: ambiguous syntax (function call x new statement) near '('
-- >
--
-- return (function (x) return f(function(v) return x(x)(v) end) end)(
--         function (x) return f(function(v) return x(x)(v) end) end)
--
-- > luajit.exe something-like-Y.lua
-- >
--

function YM(f, h)
	return function (a)
		if h[a]==nil then h[a]=f(function (n) return YM(f,h)(n) end)(a) end
		return h[a]
	end
end

--

function fac(f) return function (n) return n>0 and n*f(n-1) or 1 end end
function fib(f) return function (n) return n>1 and f(n-1)+f(n-2) or n end end

do
	assert(120 == Y(fac)(5))
	assert(55 == Y(fib)(10))
	assert(120 == YM(fac,{})(5))
	assert(55 == YM(fib,{})(10))
end
