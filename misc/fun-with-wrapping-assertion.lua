--
--  fun-with-wrapping-assertion.lua
--
--  > lua[jit] fun-with-wrapping-assertion.lua
--

function mustBeNum(v)
	assert(type(v) == "number")
	return v
end

function mustBeStr(v)
	assert(type(v) == "string")
	return v
end

function val(v, predicate)
	assert(predicate(v) == true)
	return v
end

function isNum(v) return type(v) == "number" end
function isStr(v) return type(v) == "string" end

--

function getLimiter(l, r)
	mustBeNum(l)
	mustBeNum(r)
	return function (v)
		mustBeNum(v)
		return l <= v and v < r
	end
end

function getMatcher(...)
	local marker = string.char(31)
	function fmt(s)
		mustBeStr(s)
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
			name = val(name, isStr),
			age = val(age, isAge),
			sex = val(sex, isSex),
			money = val(money, isMoney),
			hometown = val(hometown, isStr)
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
