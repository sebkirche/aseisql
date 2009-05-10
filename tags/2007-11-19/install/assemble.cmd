move /Y ..\*.pbd ..\AseIsql\ 2>nul
move /Y ..\*.exe ..\AseIsql\ 2>nul

del /Y *.zip >nul 2>nul

"c:\Program files\NSIS\makensis.exe" AseIsqlSetup.nsi

PKZIPC -add -lev=9 -path=none aseisql.zip AseIsqlSetup.exe

del /Q *.exe >nul 2>nul


