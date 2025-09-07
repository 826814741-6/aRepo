--
--  aRepo-56c1b49.lua
--
--  > lua[jit] aRepo-56c1b49.lua
--
--  (> git show 56c1b49)
--

function f()
	local T = {
		buffer = {},
		counter = 0
	}

	setmetatable(T, {
		__tostring = function (t)
			--v cf. By the way, T is t? / t is T?
			local tmp = {}
			assert({} ~= {} and tmp == tmp)
			assert(T == t and T.buffer == t.buffer)
			--^

			return ("(%d, %d)"):format(#t.buffer, t.counter)
		end
	})

	function T:inc()
		T.counter = T.counter + 1
		table.insert(T.buffer, true)
	end

	function inc()
		T.counter = T.counter + 1
		table.insert(T.buffer, true)
	end

	function T:doSomething()
		T:inc()
	end

	function T:doSomethingWrong()
		inc()
	end

	function T:reset()
		T.buffer, T.counter = {}, 0
	end

	return T
end

do
	function p(n, a, b)
		print(("%d)  A:%s   B:%s"):format(n, a, b))
	end

	local a, b = f(), f()

	p(1, a, b)
	a:doSomething()
	p(2, a, b)
	b:doSomething()
	p(3, a, b)

	print("^-- doSomething / doSomethingWrong --v")

	a:reset()
	b:reset()

	p(1, a, b)
	a:doSomethingWrong()
	p(2, a, b)
	b:doSomethingWrong()
	p(3, a, b)

	print("^-- doSomethingWrong / doSomething --v")

	a:reset()
	b:reset()

	p(1, a, b)
	a:doSomething()
	p(2, a, b)
	b:doSomething()
	p(3, a, b)
end

--
-- 1)  A:(0, 0)   B:(0, 0)
-- 2)  A:(1, 1)   B:(0, 0)
-- 3)  A:(1, 1)   B:(1, 1)
-- ^-- doSomething / doSomethingWrong --v
-- 1)  A:(0, 0)   B:(0, 0)
-- 2)  A:(0, 0)   B:(1, 1)
-- 3)  A:(0, 0)   B:(2, 2)
-- ^-- doSomethingWrong / doSomething --v
-- 1)  A:(0, 0)   B:(0, 0)
-- 2)  A:(1, 1)   B:(0, 0)
-- 3)  A:(1, 1)   B:(1, 1)
--
