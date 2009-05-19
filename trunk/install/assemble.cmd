rem @echo off

rem find nsin installer location
regedit /ea tmp.txt HKEY_LOCAL_MACHINE\SOFTWARE\NSIS
for /F "delims=" %%i in ('findstr /C:"@=" tmp.txt') do set NSIS%%i

rem replace \\ by \
set NSIS@=%NSIS@:\\=\%
rem remove last quote and append \makensis.exe"
set NSIS@=%NSIS@:~0,-1%\makensis.exe"

echo %NSIS@%

rem delete temp file
del tmp.txt >nul 2>nul

rem get version
for /F "delims=" %%i in ('findstr /C:"revisionVersion=" ..\..\exe\build.ini') do set %%i

rem replace . by _
set revisionVersion_=%revisionVersion:.=_%

echo %revisionVersion%
echo %revisionVersion_%

del /Y ..\..\*.zip >nul 2>nul

%NSIS@% AseIsqlSetup.nsi

PKZIPC -add -lev=9 -path=none ..\..\aseisql_%revisionVersion_%.zip AseIsqlSetup.exe
PKZIPC -add -lev=9 -path=none ..\..\aseisql_%revisionVersion_%.zip ..\..\exe\build.ini

del /Q AseIsqlSetup.exe >nul 2>nul

exit
