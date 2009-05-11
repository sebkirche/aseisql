@echo off

rem this batch takes the build.ini prepared by subwcrev.exe tool
rem and appends the string "revisionVersion=XXX.yyy"
rem where yyy it's a revision number 
rem and XXX :
rem   trunk, if current repository root is trunk
rem   XXX, (the name of the tag) release
rem   XXXb, (the name of the brunch) like beta version

if "%1"=="" goto error
rem %1 = path to prepared build.ini

set buildIniPath=%1

rem by default version is trunk
echo set revisionVersion=trunk>tmp.cmd

rem if current repository root is branches/XXX then version=XXXb else version=XXX
for /F "delims=" %%i in ('findstr /R "revisionURL=.*/svn/branches/.*" %buildIniPath%') do call :getversion "%%ib"
for /F "delims=" %%i in ('findstr /R "revisionURL=.*/svn/tags/.*" %buildIniPath%') do call :getversion "%%i"

for /F "delims=" %%i in ('findstr /L "revisionNumber=" %buildIniPath%') do echo set %%i>> tmp.cmd

call tmp.cmd

echo revisionVersion=%revisionVersion%.%revisionNumber%
echo revisionVersion=%revisionVersion%.%revisionNumber%>> %buildIniPath%


del /Q tmp.cmd >nul 2>nul
exit /B 0


:getversion
rem get the fifth token in
rem https://aseisql.googlecode.com/svn/branches/XXX
for /F "delims=/ tokens=5" %%j in ("%~1") do echo set revisionVersion=%%j>>tmp.cmd
exit /B


:error
echo Error: this batch should not be used directly
exit 1

