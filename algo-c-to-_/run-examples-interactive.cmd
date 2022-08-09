@echo off
setlocal

rem
rem	run-examples-interactive.cmd
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
set LUA=

rem

if "%AWK%"=="" (echo Please set %%AWK%% in this script. & exit /b 1)
if "%BASH%"=="" (echo Please set %%BASH%% in this script. & exit /b 1)
if "%LUA%"=="" (echo Please set %%LUA%% in this script. & exit /b 1)

rem

set AWK=%AWK% -f src\_helper.awk
set LUA_PATH=src\?.lua

echo ======== 105 (awk)
%AWK% -f src\105.awk -f examples\105.awk
echo ======== 105 (bash)
%BASH% examples\105.bash
echo ======== 105 (lua)
%LUA% examples\105.lua
echo.

echo ======== josephus (lua)
%LUA% examples\josephus.lua
echo.

echo ======== water (awk)
%AWK% -f src\water.awk -f examples\water.awk
echo ======== water (bash)
%BASH% examples\water.bash
echo ======== water (lua)
%LUA% examples\water.lua
echo.

endlocal
