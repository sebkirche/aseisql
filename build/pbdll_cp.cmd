@echo off

rem this batch copies powerbuilder dlls from PATH to deploy directory


if "%1"=="" goto error
rem %1 = where to copy dlls

rem get pb common dlls path
for /f %%i in ("pbvm100.dll") do set PBDLLPATH=%%~dps$PATH:i

echo copy PB DLLs from %PBDLLPATH%

for /f %%i in (pbdll.txt) do copy /Y %PBDLLPATH%\%%i %1 >nul


exit 0


:error
echo this batch should not be used directly
exit 1
