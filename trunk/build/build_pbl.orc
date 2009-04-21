#
# created by Dmitry Lukyanov

session begin pborc100.dll

#show time
timestamp

# export sources from svn repository to future libraries directory
sys svn export ..\pbsrc  ..\..\pb
cd ..\..\pb

echo create PBLs
# create libraries from target file expected PRJNAME variable to be defined.
target create lib .\%%PRJNAME%%.pbt

# set library list from target file
target set liblist .\%%PRJNAME%%.pbt
# set default pb application (we don't have yet any other in empty libs)
set application  ,

echo import objects
target import .\%%PRJNAME%%.pbt, .\

#delete source files from directory with pb libraries
sys del /S /Q .\*.sr?
sys del /S /Q .\*.pbg


#show time                                                           
timestamp                                                            
                                                                     
#end orca session
session end 

