--
--	fun-with-wrapping-assertion.lua
--
--	> lua[jit] fun-with-wrapping-assertion.lua
--

function isNum(self)
	assert(type(self.v) == "number")
	return self
end

function isStr(self)
	assert(type(self.v) == "string")
	return self
end

function filter(self, f)
	assert(f(self.v) == true)
	return self
end

function unwrap(self)
	return self.v
end

function val(v)
	local T = { v = v }

	T.isNum, T.isStr, T.filter, T.unwrap = isNum, isStr, filter, unwrap

	return T
end

--

function getLimiter(l, r)
	val(l):isNum()
	val(r):isNum()
	return function (v)
		val(v):isNum()
		return l <= v and v < r
	end
end

function getMatcher(...)
	local marker = string.char(31)
	function fmt(s)
		val(s):isStr()
		return s:gsub("^%s+",""):gsub("%s+$",""):gsub("%s",marker)
	end

	local t = {}
	for _,k in ipairs({...}) do
		t[fmt(k)] = true
	end

	return function (v) return t[fmt(v)] == true end
end

--

function getMaker()
	local isAge = getLimiter(0, 200)
	local isSex = getMatcher("female", "male", "unspecified")
	local isMoney = getLimiter(0, math.huge)

	return function (name, age, sex, money, hometown)
		return {
			name = val(name):isStr():unwrap(),
			age = val(age):isNum():filter(isAge):unwrap(),
			sex = val(sex):isStr():filter(isSex):unwrap(),
			money = val(money):isNum():filter(isMoney):unwrap(),
			hometown = val(hometown):isStr():unwrap()
		}
	end
end

function getBouncer()
	local isName = getMatcher("Paul Bunyan")
	local isAge = getLimiter(20, 2123-1996)
	local isMoney = getLimiter(80000, math.huge)
	local isHometown = getMatcher("Brainerd")

	return function (id)
		return isName(id.name) or
			isAge(id.age) or
			isMoney(id.money) or
			isHometown(id.hometown)
	end
end

function saySomething(id, bouncer)
	print(("%s? ... %s"):format(
		id.name,
		bouncer(id) and "Come in, please." or "Get out of here."
	))
end

--

do
	local make = getMaker()
	local bouncer = getBouncer()

	local samples = {
		make("Jean", 17, "female", 1000000, "Minneapolis"),
		make("Jerry", 17, "male", 2000, "Minneapolis"),
		make("Marge", 19, "female", 1000, "Brainerd"),
		make("Norm", 21, "male", 800, "Moose Lake"),
		make("Paul Bunyan", 10, "unspecified", 0, "unknown")
	}

	for _,v in ipairs(samples) do
		saySomething(v, bouncer)
	end
end
