@echo off
set path=c:\HOME\VC\bin;%path%
set include=c:\HOME\VC\include
set lib=c:\HOME\VC\lib
cd ..\win32

nmake -f scintilla_vc6.mak %1 %2 %3

copy ..\bin\SciLexer.dll ..\..\
