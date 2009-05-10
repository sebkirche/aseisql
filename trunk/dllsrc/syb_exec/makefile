MAKEFILE=MAKEFILE


INCLUDE=$(INCLUDE);$(SYBASE)\$(SYBASE_OCS)\include;C:\Program Files\Sybase\PowerBuilder 10.0\SDK\PBNI\include
LIB=$(LIB);$(SYBASE)\$(SYBASE_OCS)\lib


# Compiler AND linker flags 
CFLAGS = /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL"
LFLAGS= /nologo /dll /incremental:no /MAP /NODEFAULTLIB:LIBCMT /NODEFAULTLIB:LIBC

ASYNCDEFS = -DUSE_SIG_HANDLER=0

HDRS = syb_exec.h
MTHDRS = syb_exec.h

#
# Where to get includes and libraries
#
# SYBASE is the environment variable for sybase home directory
#
SYBLIBS =	libcs.lib libct.lib
SYSLIBS =	kernel32.lib msvcrt.lib user32.lib

# The generalized how to make an .obj rule
.c.obj:
    cl /I. /I$(SYBINCPATH) $(ASYNCDEFS) $(CFLAGS) -c $<

all: syb_exec.dll

syb_exec.dll: *.obj $(MAKEFILE)
    link $(LFLAGS) -out:$*.dll *.obj $(SYSLIBS) $(SYBLIBS) /DEF:syb_exec.def

clean:
	-del *.obj 
	-del *.map 
	-del *.exe 
	-del *.dll
	-del *.err
	-del *.pdb
	-del *.ilk
	-del *.exp
	-del *.lib
