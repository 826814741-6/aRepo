--
--	tail-call-optimization.lua
--
--	porting from:
--	https://github.com/justinethier/cyclone/blob/master/examples/tail-call-optimization.scm
--
--	> lua[jit] tail-call-optimization.lua
--	... running forever ...
--
--	> luac -l [-o nul or -o /dev/null] -- src
--	> luajit -bl src
--	> luajit -jdump src
--

local foo
local bar

function foo()
	return bar()
end

function bar()
	return foo()
end

foo()
