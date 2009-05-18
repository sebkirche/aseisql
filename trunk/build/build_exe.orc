#
# created by Dmitry Lukyanov

session begin pborc100.dll

timestamp


# export sources from svn repository to future exe
sys   svn export ..\pbsrc            ..\..\exe
sys   copy /Y    ..\dll\*.dll        ..\..\exe
sys   copy /Y    ..\sql\*.sql        ..\..\exe
sys   copy /Y    ..\help\hlp\*.hlp   ..\..\exe
sys   rename     ..\..\exe\xxsyc.dll pbsyc100.dll

sys pbdll_cp.cmd ..\..\exe

# replace $WCREV$ in build.ini and put result in the future exe directory
sys subwcrev ..\ build.ini ..\..\exe\build.ini
sys version.cmd ..\..\exe\build.ini

cd ..\..\exe

echo build pbr file
sys for %%i in (img\*.*) do @echo %%i>> %%PRJNAME%%.pbr


echo create PBLs
# create libraries from target file expected PRJNAME variavle to be defined.
target create lib .\%%PRJNAME%%.pbt

# set library list from target file
target set liblist .\%%PRJNAME%%.pbt

# set default pb application (we don't have other in empty libs)
set application  ,


echo import objects
#import all objects according pbg files defined in target file
target import .\%%PRJNAME%%.pbt, .\

# delete imported objects
sys del /S /Q .\*.sr?
sys del /S /Q .\*.pbg


# PBNI: build PBD from syb_exec.dll
sys pbx2pbd100.exe syb_exec.pbd syb_exec.dll

#end orca session. because we have to switch application
session end 

#in sybase pborcXX.dll there are could be memory leak
#so, to do pure memory cleanup, split this file 


session begin pborc100.dll
# set liblist and application from target
target set liblist .\%%PRJNAME%%.pbt
target set app .\%%PRJNAME%%.pbt

# do migration of the application (like full rebuild)
build app migrate

#get revisionVersion from version.ini
profile string .\build.ini, version, revisionVersion

set exeinfo property companyname, Char Labs
set exeinfo property productname, AseIsql
set exeinfo property description, The SQLAdvantage replacement
set exeinfo property copyright,   Char Labs
set exeinfo property fileversion, %%revisionVersion%%
set exeinfo property fileversionnum, %%revisionVersion%%
set exeinfo property productversion, %%revisionVersion%%

# build executable
build exe %%PRJNAME%%.exe, img\%%PRJNAME%%.ico, %%PRJNAME%%.pbr, pcode

# delete other source files
sys del /Q *.pbr
sys del /Q *.pbl
sys del /Q *.pbw
sys del /Q *.pbt
sys rmdir /Q /S img

session end 

#done
