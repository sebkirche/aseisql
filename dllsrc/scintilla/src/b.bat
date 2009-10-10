@echo off
set path=d:\HOME\VC\bin;%path%
set include=d:\HOME\VC\include
set lib=d:\HOME\VC\lib
cd ..\win32

nmake -f scintilla_vc6.mak %1 %2 %3

copy /Y ..\bin\SciLexer.dll ..\..\..\dll
