@echo off
setlocal

rem
rem	run-examples.cmd
rem
rem	Please set the path of excutable, before you run this script.
rem
rem	e.g.
rem	set LUA=C:\path\to\lua.exe
rem	set AWK=%USERPROFILE%\git\mingw64\bin\busybox.exe awk
rem	set CHEZ="%PROGRAMFILES%\Chez Scheme 9.5.8\bin\ta6nt\scheme.exe"
rem

set AWK=
set BASH=
set CHEZ=
set FTH=
set LUA=
set LUAJIT=

rem

if "%AWK%"=="" (echo Please set %%AWK%% in this script. & exit /b 1)
if "%BASH%"=="" (echo Please set %%BASH%% in this script. & exit /b 1)
if "%CHEZ%"=="" (echo Please set %%CHEZ%% in this script. & exit /b 1)
if "%FTH%"=="" (echo Please set %%FTH%% in this script. & exit /b 1)
if "%LUA%"=="" (echo Please set %%LUA%% in this script. & exit /b 1)
if "%LUAJIT%"=="" (echo Please set %%LUAJIT%% in this script. & exit /b 1)

rem

set AWK=%AWK% -f src\_helper.awk
set CHEZ=%CHEZ% --libdirs src --script
set FTH=%FTH% -q
set LUA_PATH=src\?.lua

echo ======== acker (awk)
%AWK% -f src\acker.awk -f examples\acker.awk
echo ======== acker (bash)
%BASH% examples\acker.bash
echo ======== acker (chez)
%CHEZ% examples\acker.ss
echo ======== acker (pforth)
%FTH% examples\acker.fth
echo ======== acker (lua)
%LUA% examples\acker.lua
echo.

echo ======== atan (lua)
%LUA% examples\atan.lua
echo.

echo ======== binormal (lua)
%LUA% examples\binormal.lua
echo.

echo ======== change (awk)
%AWK% -f src\change.awk -f examples\change.awk
echo ======== change (lua)
%LUA% examples\change.lua
echo.

echo ======== chisqdist (awk)
%AWK% -f src\chisqdist.awk -f examples\chisqdist.awk
echo ======== chisqdist (lua)
%LUA% examples\chisqdist.lua
echo.

echo ======== ci (lua)
%LUA% examples\ci.lua
echo.

echo ======== combination (awk)
%AWK% -f src\combination.awk -f examples\combination.awk
echo ======== combination (lua)
%LUA% examples\combination.lua
echo.

echo ======== crnd (lua)
%LUA% examples\crnd.lua
echo ======== crnd (luajit)
set LUA_PATH=src\?.luajit
%LUAJIT% examples\crnd.luajit
set LUA_PATH=src\?.lua
echo.

echo ======== cuberoot (awk)
%AWK% -f src\cuberoot.awk -f examples\cuberoot.awk
echo ======== cuberoot (chez)
%CHEZ% examples\cuberoot.ss
echo ======== cuberoot (pforth)
%FTH% examples\cuberoot.fth
echo ======== cuberoot (lua)
%LUA% examples\cuberoot.lua
echo ======== cuberoot (luajit)
set LUA_PATH=src\?.luajit
%LUAJIT% examples\cuberoot.luajit
set LUA_PATH=src\?.lua
echo.

echo ======== dayweek (awk)
%AWK% -f src\dayweek.awk -f examples\dayweek.awk
echo ======== dayweek (lua)
%LUA% examples\dayweek.lua
echo.

echo ======== e (awk)
%AWK% -f src\e.awk -f examples\e.awk
echo ======== e (bash)
%BASH% examples\e.bash
echo ======== e (chez)
%CHEZ% examples\e.ss
echo ======== e (pforth)
%FTH% examples\e.fth
echo ======== e (lua)
%LUA% examples\e.lua
echo.

echo ======== eulerian (awk)
%AWK% -f src\eulerian.awk -f examples\eulerian.awk
echo ======== eulerian (bash)
%BASH% examples\eulerian.bash
echo ======== eulerian (pforth)
%FTH% examples\eulerian.fth
echo ======== eulerian (lua)
%LUA% examples\eulerian.lua
echo.

echo ======== fdist (lua)
%LUA% examples\fdist.lua
echo.

echo ======== fft (lua)
%LUA% examples\fft.lua
echo.

echo ======== fib (awk)
%AWK% -f src\fib.awk -f examples\fib.awk
echo ======== fib (chez)
%CHEZ% examples\fib.ss
echo ======== fib (pforth)
%FTH% examples\fib.fth
echo ======== fib (lua)
%LUA% examples\fib.lua
echo.

echo ======== gamma (awk)
%AWK% -f src\gamma.awk -f examples\gamma.awk
echo ======== gamma (lua)
%LUA% examples\gamma.lua
echo.

echo ======== gcd (awk)
%AWK% -f src\gcd.awk -f examples\gcd.awk
echo ======== gcd (bash)
%BASH% examples\gcd.bash
echo ======== gcd (lua)
%LUA% examples\gcd.lua
echo.

echo ======== horner (awk)
%AWK% -f src\horner.awk -f examples\horner.awk
echo ======== horner (lua)
%LUA% examples\horner.lua
echo.

echo ======== hypot (awk)
%AWK% -f src\hypot.awk -f examples\hypot.awk
echo ======== hypot (chez)
%CHEZ% examples\hypot.ss
echo ======== hypot (pforth)
%FTH% examples\hypot.fth
echo ======== hypot (lua)
%LUA% examples\hypot.lua
echo.

echo ======== isbn (lua)
%LUA% examples\isbn.lua
echo.

echo ======== isbn13 (lua)
%LUA% examples\isbn13.lua
echo.

echo ======== komachi (lua)
%LUA% examples\komachi.lua
echo.

echo ======== luhn (lua)
%LUA% examples\luhn.lua
echo.

echo ======== machineepsilon (lua)
%LUA% examples\machineepsilon.lua
echo.

echo ======== mccarthy (awk)
%AWK% -f src\mccarthy.awk -f examples\mccarthy.awk
echo ======== mccarthy (bash)
%BASH% examples\mccarthy.bash
echo ======== mccarthy (chez)
%CHEZ% examples\mccarthy.ss
echo ======== mccarthy (pforth)
%FTH% examples\mccarthy.fth
echo ======== mccarthy (lua)
%LUA% examples\mccarthy.lua
echo.

echo ======== montecarlo (lua)
%LUA% examples\montecarlo.lua
echo.

echo ======== moveblock (awk)
%AWK% -f src\moveblock.awk -f examples\moveblock.awk
echo ======== moveblock (lua)
%LUA% examples\moveblock.lua
echo.

echo ======== multiply (awk)
%AWK% -f src\multiply.awk -f examples\multiply.awk
echo ======== multiply (bash)
%BASH% examples\multiply.bash
echo ======== multiply (pforth)
%FTH% examples\multiply.fth
echo ======== multiply (lua)
%LUA% examples\multiply.lua
echo ======== multiply (luajit)
set LUA_PATH=src\?.luajit
%LUAJIT% examples\multiply.luajit
set LUA_PATH=src\?.lua
echo.

echo ======== normal (awk)
%AWK% -f src\normal.awk -f examples\normal.awk
echo ======== normal (lua)
%LUA% examples\normal.lua
echo.

echo ======== pi (awk)
%AWK% -f src\pi.awk -f examples\pi.awk
echo ======== pi (chez)
%CHEZ% examples\pi.ss
echo ======== pi (pforth)
%FTH% examples\pi.fth
echo ======== pi (lua)
%LUA% examples\pi.lua
echo.

echo ======== power (awk)
%AWK% -f src\power.awk -f examples\power.awk
echo ======== power (bash)
%BASH% examples\power.bash
echo ======== power (lua)
%LUA% examples\power.lua
echo ======== power (luajit)
set LUA_PATH=src\?.luajit
%LUAJIT% examples\power.luajit
set LUA_PATH=src\?.lua
echo.

echo ======== rand (pforth)
%FTH% examples\rand.fth
echo ======== rand (lua)
%LUA% examples\rand.lua
echo ======== rand (luajit)
set LUA_PATH=src\?.luajit
%LUAJIT% examples\rand.luajit
set LUA_PATH=src\?.lua
echo.

echo ======== randperm (lua)
%LUA% examples\randperm.lua
echo.

echo ======== si (lua)
%LUA% examples\si.lua
echo.

echo ======== sqrt (awk)
%AWK% -f src\sqrt.awk -f examples\sqrt.awk
echo ======== sqrt (chez)
%CHEZ% examples\sqrt.ss
echo ======== sqrt (pforth)
%FTH% examples\sqrt.fth
echo ======== sqrt (lua)
%LUA% examples\sqrt.lua
echo ======== sqrt (luajit)
set LUA_PATH=src\?.luajit
%LUAJIT% examples\sqrt.luajit
set LUA_PATH=src\?.lua
echo.

echo ======== stirling (awk)
%AWK% -f src\stirling.awk -f examples\stirling.awk
echo ======== stirling (bash)
%BASH% examples\stirling.bash
echo ======== stirling (pforth)
%FTH% examples\stirling.fth
echo ======== stirling (lua)
%LUA% examples\stirling.lua
echo.

echo ======== sum (awk)
%AWK% -f src\sum.awk -f examples\sum.awk
echo ======== sum (lua)
%LUA% examples\sum.lua
echo.

echo ======== swap (awk)
%AWK% -f src\swap.awk -f examples\swap.awk
echo ======== swap (lua)
%LUA% examples\swap.lua
echo.

echo ======== tarai (awk)
%AWK% -f src\tarai.awk -f examples\tarai.awk
echo ======== tarai (chez)
%CHEZ% examples\tarai.ss
echo ======== tarai (pforth)
%FTH% examples\tarai.fth
echo ======== tarai (lua)
%LUA% examples\tarai.lua
echo.

echo ======== tdist (lua)
%LUA% examples\tdist.lua
echo.

echo ======== totient (awk)
%AWK% -f src\totient.awk -f examples\totient.awk
echo ======== totient (bash)
%BASH% examples\totient.bash
echo ======== totient (pforth)
%FTH% examples\totient.fth
echo ======== totient (lua)
%LUA% examples\totient.lua
echo.

echo ======== whrnd (lua)
%LUA% examples\whrnd.lua
echo.

echo ======== zeta (lua)
%LUA% examples\zeta.lua
echo.

endlocal
