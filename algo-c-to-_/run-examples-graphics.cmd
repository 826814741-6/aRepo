@echo off
setlocal

rem
rem	run-examples-graphics.cmd
rem
rem	Please set the path of excutables, before you run this script.
rem
rem	e.g.
rem	set LUA=C:\path\to\lua.exe
rem	set AWK=%USERPROFILE%\git\mingw64\bin\busybox.exe awk
rem	set CHEZ="%PROGRAMFILES%\Chez Scheme 9.5.8\bin\ta6nt\scheme.exe"
rem

set LUA=

rem

if "%LUA%"=="" (echo Please set %%LUA%% in this script. & exit /b 1)

rem

set LUA_PATH=src\?.lua

%LUA% examples\3dgraph.lua
%LUA% examples\bifur.lua
%LUA% examples\binormalG.lua
%LUA% examples\ccurve.lua
%LUA% examples\circle.lua
%LUA% examples\dragoncurve.lua
%LUA% examples\dragoncurveR.lua
%LUA% examples\ellipse.lua
%LUA% examples\epsplot.lua
%LUA% examples\gasket.lua
%LUA% examples\grBMP.lua
%LUA% examples\hilbert.lua
%LUA% examples\julia.lua
%LUA% examples\koch.lua
%LUA% examples\line.lua
%LUA% examples\lissajouscurve.lua
%LUA% examples\lorenz.lua
%LUA% examples\sierpinski.lua
%LUA% examples\svgplot.lua
%LUA% examples\treecurve.lua

endlocal
