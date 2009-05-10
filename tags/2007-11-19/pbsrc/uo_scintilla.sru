HA$PBExportHeader$uo_scintilla.sru
forward
global type uo_scintilla from userobject
end type
type mle_1 from multilineedit within uo_scintilla
end type
type scnotification from structure within uo_scintilla
end type
type sct_textrange from structure within uo_scintilla
end type
end forward

type scnotification from structure
	long		hwndfrom
	long		idfrom
	long		code
	long		position
	long		ch
	long		modifiers
	long		modificationtype
	long		text
	long		length
	long		linesadded
	long		message
	long		wparam
	long		lparam
	long		line
	long		foldlevelnow
	long		foldlevelprev
	long		margin
	long		listtype
	long		x
	long		y
end type

type sct_textrange from structure
	long		cpmin
	long		cpmax
	blob		text
end type

global type uo_scintilla from userobject
integer width = 699
integer height = 548
boolean border = true
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event resize pbm_size
event setfocus pbm_setfocus
event scn_charadded ( long ch )
event contextmenu ( integer xpos,  integer ypos )
event scn_marginclick ( long position,  long modifiers )
event scn_updateui ( )
event scn_savepoint ( boolean b )
event scn_userlistselection ( long listtype,  readonly string s )
event scn_dwellmouse ( long position,  long al_x,  long al_y,  boolean ab_start )
event scn_lbuttondown ( )
event scn_ctrlhover ( long pos,  long len )
mle_1 mle_1
end type
global uo_scintilla uo_scintilla

type prototypes
private function long CreateWindowEx(long dwExStyle,	string lpClassName,	string lpWindowName, long dwStyle,	long nx, long ny, long nWidth, long nHeight, long hWndParent, long hMenu, long hInstance, long lpParam)library "user32" alias for "CreateWindowExW"
private function boolean DestroyWindow(long _hWnd)library "user32"
private function boolean MoveWindow(long _hWnd,long nX,long nY,long nWidth,long nHeight,boolean bRepaint)library "user32"

private function long LoadLibrary(string s)library 'kernel32' alias for "LoadLibraryW"
private function boolean FreeLibrary(long hLibModule)library 'kernel32'
private function boolean ShowWindow(long _hWnd,long nCmdShow)library "user32"

private function long SendMessage(long _hwnd, long msg, long wparm, ref blob lparm) library "user32" alias for "SendMessageW"
private function long SendMessage(long _hwnd, long msg, ref blob wparm, ref blob lparm) library "user32" alias for "SendMessageW"
private function long SendMessage(long _hwnd, long msg, long wparm, ref sct_TextRange lparm) library "user32" alias for "SendMessageW"

protected function boolean SciPrint(long hwndMain,long hwndSci,boolean showdlg)library 'SciPrint'

private subroutine RtlMoveMemory( ref scNotification dest, long src, long srclen ) library 'kernel32.dll' alias for "RtlMoveMemory"
public function long GetSysColor(long index)library "user32"

end prototypes
type variables
privatewrite long sci_hwnd
private long sci_lib
private long sci_prn_lib

privatewrite long INVALID_POSITION=-1
privatewrite long SCI_START=2000
privatewrite long SCI_OPTIONAL_START=3000
privatewrite long SCI_LEXER_START=4000
privatewrite long SCI_ADDTEXT=2001
privatewrite long SCI_ADDSTYLEDTEXT=2002
privatewrite long SCI_INSERTTEXT=2003
privatewrite long SCI_CLEARALL=2004
privatewrite long SCI_CLEARDOCUMENTSTYLE=2005
privatewrite long SCI_GETLENGTH=2006
privatewrite long SCI_GETCHARAT=2007
privatewrite long SCI_GETCURRENTPOS=2008
privatewrite long SCI_GETANCHOR=2009
privatewrite long SCI_GETSTYLEAT=2010
privatewrite long SCI_REDO=2011
privatewrite long SCI_SETUNDOCOLLECTION=2012
privatewrite long SCI_SELECTALL=2013
privatewrite long SCI_SETSAVEPOINT=2014
privatewrite long SCI_GETSTYLEDTEXT=2015
privatewrite long SCI_CANREDO=2016
privatewrite long SCI_MARKERLINEFROMHANDLE=2017
privatewrite long SCI_MARKERDELETEHANDLE=2018
privatewrite long SCI_GETUNDOCOLLECTION=2019
privatewrite long SCWS_INVISIBLE=0
privatewrite long SCWS_VISIBLEALWAYS=1
privatewrite long SCWS_VISIBLEAFTERINDENT=2
privatewrite long SCI_GETVIEWWS=2020
privatewrite long SCI_SETVIEWWS=2021
privatewrite long SCI_POSITIONFROMPOINT=2022
privatewrite long SCI_POSITIONFROMPOINTCLOSE=2023
privatewrite long SCI_GOTOLINE=2024
privatewrite long SCI_GOTOPOS=2025
privatewrite long SCI_SETANCHOR=2026
privatewrite long SCI_GETCURLINE=2027
privatewrite long SCI_GETENDSTYLED=2028
privatewrite long SC_EOL_CRLF=0
privatewrite long SC_EOL_CR=1
privatewrite long SC_EOL_LF=2
privatewrite long SCI_CONVERTEOLS=2029
privatewrite long SCI_GETEOLMODE=2030
privatewrite long SCI_SETEOLMODE=2031
privatewrite long SCI_STARTSTYLING=2032
privatewrite long SCI_SETSTYLING=2033
privatewrite long SCI_GETBUFFEREDDRAW=2034
privatewrite long SCI_SETBUFFEREDDRAW=2035
privatewrite long SCI_SETTABWIDTH=2036
privatewrite long SCI_GETTABWIDTH=2121
privatewrite long SC_CP_UTF8=65001
privatewrite long SC_CP_DBCS=1
privatewrite long SCI_SETCODEPAGE=2037
privatewrite long SCI_SETUSEPALETTE=2039
privatewrite long MARKER_MAX=31
privatewrite long SC_MARK_CIRCLE=0
privatewrite long SC_MARK_ROUNDRECT=1
privatewrite long SC_MARK_ARROW=2
privatewrite long SC_MARK_SMALLRECT=3
privatewrite long SC_MARK_SHORTARROW=4
privatewrite long SC_MARK_EMPTY=5
privatewrite long SC_MARK_ARROWDOWN=6
privatewrite long SC_MARK_MINUS=7
privatewrite long SC_MARK_PLUS=8
privatewrite long SC_MARK_VLINE=9
privatewrite long SC_MARK_LCORNER=10
privatewrite long SC_MARK_TCORNER=11
privatewrite long SC_MARK_BOXPLUS=12
privatewrite long SC_MARK_BOXPLUSCONNECTED=13
privatewrite long SC_MARK_BOXMINUS=14
privatewrite long SC_MARK_BOXMINUSCONNECTED=15
privatewrite long SC_MARK_LCORNERCURVE=16
privatewrite long SC_MARK_TCORNERCURVE=17
privatewrite long SC_MARK_CIRCLEPLUS=18
privatewrite long SC_MARK_CIRCLEPLUSCONNECTED=19
privatewrite long SC_MARK_CIRCLEMINUS=20
privatewrite long SC_MARK_CIRCLEMINUSCONNECTED=21
privatewrite long SC_MARK_BACKGROUND=22
privatewrite long SC_MARK_DOTDOTDOT=23
privatewrite long SC_MARK_ARROWS=24
privatewrite long SC_MARK_PIXMAP=25
privatewrite long SC_MARK_CHARACTER=10000
privatewrite long SC_MARKNUM_FOLDEREND=25
privatewrite long SC_MARKNUM_FOLDEROPENMID=26
privatewrite long SC_MARKNUM_FOLDERMIDTAIL=27
privatewrite long SC_MARKNUM_FOLDERTAIL=28
privatewrite long SC_MARKNUM_FOLDERSUB=29
privatewrite long SC_MARKNUM_FOLDER=30
privatewrite long SC_MARKNUM_FOLDEROPEN=31
privatewrite long SC_MASK_FOLDERS=4261412864//f_hex2long("FE000000")
privatewrite long SCI_MARKERDEFINE=2040
privatewrite long SCI_MARKERSETFORE=2041
privatewrite long SCI_MARKERSETBACK=2042
privatewrite long SCI_MARKERADD=2043
privatewrite long SCI_MARKERDELETE=2044
privatewrite long SCI_MARKERDELETEALL=2045
privatewrite long SCI_MARKERGET=2046
privatewrite long SCI_MARKERNEXT=2047
privatewrite long SCI_MARKERPREVIOUS=2048
privatewrite long SCI_MARKERDEFINEPIXMAP=2049
privatewrite long SC_MARGIN_SYMBOL=0
privatewrite long SC_MARGIN_NUMBER=1
privatewrite long SCI_SETMARGINTYPEN=2240
privatewrite long SCI_GETMARGINTYPEN=2241
privatewrite long SCI_SETMARGINWIDTHN=2242
privatewrite long SCI_GETMARGINWIDTHN=2243
privatewrite long SCI_SETMARGINMASKN=2244
privatewrite long SCI_GETMARGINMASKN=2245
privatewrite long SCI_SETMARGINSENSITIVEN=2246
privatewrite long SCI_GETMARGINSENSITIVEN=2247
privatewrite long STYLE_DEFAULT=32
privatewrite long STYLE_LINENUMBER=33
privatewrite long STYLE_BRACELIGHT=34
privatewrite long STYLE_BRACEBAD=35
privatewrite long STYLE_CONTROLCHAR=36
privatewrite long STYLE_INDENTGUIDE=37
privatewrite long STYLE_LASTPREDEFINED=39
privatewrite long STYLE_MAX=127
privatewrite long SC_CHARSET_ANSI=0
privatewrite long SC_CHARSET_DEFAULT=1
privatewrite long SC_CHARSET_BALTIC=186
privatewrite long SC_CHARSET_CHINESEBIG5=136
privatewrite long SC_CHARSET_EASTEUROPE=238
privatewrite long SC_CHARSET_GB2312=134
privatewrite long SC_CHARSET_GREEK=161
privatewrite long SC_CHARSET_HANGUL=129
privatewrite long SC_CHARSET_MAC=77
privatewrite long SC_CHARSET_OEM=255
privatewrite long SC_CHARSET_RUSSIAN=204
privatewrite long SC_CHARSET_SHIFTJIS=128
privatewrite long SC_CHARSET_SYMBOL=2
privatewrite long SC_CHARSET_TURKISH=162
privatewrite long SC_CHARSET_JOHAB=130
privatewrite long SC_CHARSET_HEBREW=177
privatewrite long SC_CHARSET_ARABIC=178
privatewrite long SC_CHARSET_VIETNAMESE=163
privatewrite long SC_CHARSET_THAI=222
privatewrite long SCI_STYLECLEARALL=2050
privatewrite long SCI_STYLESETFORE=2051
privatewrite long SCI_STYLESETBACK=2052
privatewrite long SCI_STYLESETBOLD=2053
privatewrite long SCI_STYLESETITALIC=2054
privatewrite long SCI_STYLESETSIZE=2055
privatewrite long SCI_STYLESETFONT=2056
privatewrite long SCI_STYLESETEOLFILLED=2057
privatewrite long SCI_STYLERESETDEFAULT=2058
privatewrite long SCI_STYLESETUNDERLINE=2059
privatewrite long SC_CASE_MIXED=0
privatewrite long SC_CASE_UPPER=1
privatewrite long SC_CASE_LOWER=2
privatewrite long SCI_STYLESETCASE=2060
privatewrite long SCI_STYLESETCHARACTERSET=2066
privatewrite long SCI_SETSELFORE=2067
privatewrite long SCI_SETSELBACK=2068
privatewrite long SCI_SETCARETFORE=2069
privatewrite long SCI_ASSIGNCMDKEY=2070
privatewrite long SCI_CLEARCMDKEY=2071
privatewrite long SCI_CLEARALLCMDKEYS=2072
privatewrite long SCI_SETSTYLINGEX=2073
privatewrite long SCI_STYLESETVISIBLE=2074
privatewrite long SCI_GETCARETPERIOD=2075
privatewrite long SCI_SETCARETPERIOD=2076
privatewrite long SCI_SETWORDCHARS=2077
privatewrite long SCI_BEGINUNDOACTION=2078
privatewrite long SCI_ENDUNDOACTION=2079
privatewrite long INDIC_MAX=7
privatewrite long INDIC_PLAIN=0
privatewrite long INDIC_SQUIGGLE=1
privatewrite long INDIC_TT=2
privatewrite long INDIC_DIAGONAL=3
privatewrite long INDIC_STRIKE=4
privatewrite long INDIC0_MASK=32//f_hex2long("20")
privatewrite long INDIC1_MASK=64//f_hex2long("40")
privatewrite long INDIC2_MASK=128//f_hex2long("80")
privatewrite long INDICS_MASK=224//f_hex2long("E0")
privatewrite long SCI_INDICSETSTYLE=2080
privatewrite long SCI_INDICGETSTYLE=2081
privatewrite long SCI_INDICSETFORE=2082
privatewrite long SCI_INDICGETFORE=2083
privatewrite long SCI_SETWHITESPACEFORE=2084
privatewrite long SCI_SETWHITESPACEBACK=2085
privatewrite long SCI_SETSTYLEBITS=2090
privatewrite long SCI_GETSTYLEBITS=2091
privatewrite long SCI_SETLINESTATE=2092
privatewrite long SCI_GETLINESTATE=2093
privatewrite long SCI_GETMAXLINESTATE=2094
privatewrite long SCI_GETCARETLINEVISIBLE=2095
privatewrite long SCI_SETCARETLINEVISIBLE=2096
privatewrite long SCI_GETCARETLINEBACK=2097
privatewrite long SCI_SETCARETLINEBACK=2098
privatewrite long SCI_STYLESETCHANGEABLE=2099
privatewrite long SCI_AUTOCSHOW=2100
privatewrite long SCI_AUTOCCANCEL=2101
privatewrite long SCI_AUTOCACTIVE=2102
privatewrite long SCI_AUTOCPOSSTART=2103
privatewrite long SCI_AUTOCCOMPLETE=2104
privatewrite long SCI_AUTOCSTOPS=2105
privatewrite long SCI_AUTOCSETSEPARATOR=2106
privatewrite long SCI_AUTOCGETSEPARATOR=2107
privatewrite long SCI_AUTOCSELECT=2108
privatewrite long SCI_AUTOCSETCANCELATSTART=2110
privatewrite long SCI_AUTOCGETCANCELATSTART=2111
privatewrite long SCI_AUTOCSETFILLUPS=2112
privatewrite long SCI_AUTOCSETCHOOSESINGLE=2113
privatewrite long SCI_AUTOCGETCHOOSESINGLE=2114
privatewrite long SCI_AUTOCSETIGNORECASE=2115
privatewrite long SCI_AUTOCGETIGNORECASE=2116
privatewrite long SCI_USERLISTSHOW=2117
privatewrite long SCI_AUTOCSETAUTOHIDE=2118
privatewrite long SCI_AUTOCGETAUTOHIDE=2119
privatewrite long SCI_AUTOCSETDROPRESTOFWORD=2270
privatewrite long SCI_AUTOCGETDROPRESTOFWORD=2271
privatewrite long SCI_REGISTERIMAGE=2405
privatewrite long SCI_CLEARREGISTEREDIMAGES=2408
privatewrite long SCI_AUTOCGETTYPESEPARATOR=2285
privatewrite long SCI_AUTOCSETTYPESEPARATOR=2286
privatewrite long SCI_SETINDENT=2122
privatewrite long SCI_GETINDENT=2123
privatewrite long SCI_SETUSETABS=2124
privatewrite long SCI_GETUSETABS=2125
privatewrite long SCI_SETLINEINDENTATION=2126
privatewrite long SCI_GETLINEINDENTATION=2127
privatewrite long SCI_GETLINEINDENTPOSITION=2128
privatewrite long SCI_GETCOLUMN=2129
privatewrite long SCI_SETHSCROLLBAR=2130
privatewrite long SCI_GETHSCROLLBAR=2131
privatewrite long SCI_SETINDENTATIONGUIDES=2132
privatewrite long SCI_GETINDENTATIONGUIDES=2133
privatewrite long SCI_SETHIGHLIGHTGUIDE=2134
privatewrite long SCI_GETHIGHLIGHTGUIDE=2135
privatewrite long SCI_GETLINEENDPOSITION=2136
privatewrite long SCI_GETCODEPAGE=2137
privatewrite long SCI_GETCARETFORE=2138
privatewrite long SCI_GETUSEPALETTE=2139
privatewrite long SCI_GETREADONLY=2140
privatewrite long SCI_SETCURRENTPOS=2141
privatewrite long SCI_SETSELECTIONSTART=2142
privatewrite long SCI_GETSELECTIONSTART=2143
privatewrite long SCI_SETSELECTIONEND=2144
privatewrite long SCI_GETSELECTIONEND=2145
privatewrite long SCI_SETPRINTMAGNIFICATION=2146
privatewrite long SCI_GETPRINTMAGNIFICATION=2147
privatewrite long SC_PRINT_NORMAL=0
privatewrite long SC_PRINT_INVERTLIGHT=1
privatewrite long SC_PRINT_BLACKONWHITE=2
privatewrite long SC_PRINT_COLOURONWHITE=3
privatewrite long SC_PRINT_COLOURONWHITEDEFAULTBG=4
privatewrite long SCI_SETPRINTCOLOURMODE=2148
privatewrite long SCI_GETPRINTCOLOURMODE=2149
privatewrite long SCFIND_WHOLEWORD=2
privatewrite long SCFIND_MATCHCASE=4
privatewrite long SCFIND_WORDSTART=1048576//f_hex2long("00100000")
privatewrite long SCFIND_REGEXP=2097152//f_hex2long("00200000")
privatewrite long SCI_FINDTEXT=2150
privatewrite long SCI_FORMATRANGE=2151
privatewrite long SCI_GETFIRSTVISIBLELINE=2152
privatewrite long SCI_GETLINE=2153
privatewrite long SCI_GETLINECOUNT=2154
privatewrite long SCI_SETMARGINLEFT=2155
privatewrite long SCI_GETMARGINLEFT=2156
privatewrite long SCI_SETMARGINRIGHT=2157
privatewrite long SCI_GETMARGINRIGHT=2158
privatewrite long SCI_GETMODIFY=2159
privatewrite long SCI_SETSEL=2160
privatewrite long SCI_GETSELTEXT=2161
privatewrite long SCI_GETTEXTRANGE=2162
privatewrite long SCI_HIDESELECTION=2163
privatewrite long SCI_POINTXFROMPOSITION=2164
privatewrite long SCI_POINTYFROMPOSITION=2165
privatewrite long SCI_LINEFROMPOSITION=2166
privatewrite long SCI_POSITIONFROMLINE=2167
privatewrite long SCI_LINESCROLL=2168
privatewrite long SCI_SCROLLCARET=2169
privatewrite long SCI_REPLACESEL=2170
privatewrite long SCI_SETREADONLY=2171
privatewrite long SCI_NULL=2172
privatewrite long SCI_CANPASTE=2173
privatewrite long SCI_CANUNDO=2174
privatewrite long SCI_EMPTYUNDOBUFFER=2175
privatewrite long SCI_UNDO=2176
privatewrite long SCI_CUT=2177
privatewrite long SCI_COPY=2178
privatewrite long SCI_PASTE=2179
privatewrite long SCI_CLEAR=2180
privatewrite long SCI_SETTEXT=2181
privatewrite long SCI_GETTEXT=2182
privatewrite long SCI_GETTEXTLENGTH=2183
privatewrite long SCI_GETDIRECTFUNCTION=2184
privatewrite long SCI_GETDIRECTPOINTER=2185
privatewrite long SCI_SETOVERTYPE=2186
privatewrite long SCI_GETOVERTYPE=2187
privatewrite long SCI_SETCARETWIDTH=2188
privatewrite long SCI_GETCARETWIDTH=2189
privatewrite long SCI_SETTARGETSTART=2190
privatewrite long SCI_GETTARGETSTART=2191
privatewrite long SCI_SETTARGETEND=2192
privatewrite long SCI_GETTARGETEND=2193
privatewrite long SCI_REPLACETARGET=2194
privatewrite long SCI_REPLACETARGETRE=2195
privatewrite long SCI_SEARCHINTARGET=2197
privatewrite long SCI_SETSEARCHFLAGS=2198
privatewrite long SCI_GETSEARCHFLAGS=2199
privatewrite long SCI_CALLTIPSHOW=2200
privatewrite long SCI_CALLTIPCANCEL=2201
privatewrite long SCI_CALLTIPACTIVE=2202
privatewrite long SCI_CALLTIPPOSSTART=2203
privatewrite long SCI_CALLTIPSETHLT=2204
privatewrite long SCI_CALLTIPSETBACK=2205
privatewrite long SCI_VISIBLEFROMDOCLINE=2220
privatewrite long SCI_DOCLINEFROMVISIBLE=2221
privatewrite long SC_FOLDLEVELBASE=1024//f_hex2long("400")
privatewrite long SC_FOLDLEVELWHITEFLAG=4096//f_hex2long("1000")
privatewrite long SC_FOLDLEVELHEADERFLAG=8192//f_hex2long("2000")
privatewrite long SC_FOLDLEVELBOXHEADERFLAG=16384//f_hex2long("4000")
privatewrite long SC_FOLDLEVELBOXFOOTERFLAG=32768//f_hex2long("8000")
privatewrite long SC_FOLDLEVELCONTRACTED=65536//f_hex2long("10000")
privatewrite long SC_FOLDLEVELUNINDENT=131072//f_hex2long("20000")
privatewrite long SC_FOLDLEVELNUMBERMASK=4095//f_hex2long("0FFF")
privatewrite long SCI_SETFOLDLEVEL=2222
privatewrite long SCI_GETFOLDLEVEL=2223
privatewrite long SCI_GETLASTCHILD=2224
privatewrite long SCI_GETFOLDPARENT=2225
privatewrite long SCI_SHOWLINES=2226
privatewrite long SCI_HIDELINES=2227
privatewrite long SCI_GETLINEVISIBLE=2228
privatewrite long SCI_SETFOLDEXPANDED=2229
privatewrite long SCI_GETFOLDEXPANDED=2230
privatewrite long SCI_TOGGLEFOLD=2231
privatewrite long SCI_ENSUREVISIBLE=2232
privatewrite long SC_FOLDFLAG_LINEBEFORE_EXPANDED=2//f_hex2long("0002")
privatewrite long SC_FOLDFLAG_LINEBEFORE_CONTRACTED=4//f_hex2long("0004")
privatewrite long SC_FOLDFLAG_LINEAFTER_EXPANDED=8//f_hex2long("0008")
privatewrite long SC_FOLDFLAG_LINEAFTER_CONTRACTED=16//f_hex2long("0010")
privatewrite long SC_FOLDFLAG_LEVELNUMBERS=64//f_hex2long("0040")
privatewrite long SC_FOLDFLAG_BOX=1//f_hex2long("0001")
privatewrite long SCI_SETFOLDFLAGS=2233
privatewrite long SCI_ENSUREVISIBLEENFORCEPOLICY=2234
privatewrite long SCI_SETTABINDENTS=2260
privatewrite long SCI_GETTABINDENTS=2261
privatewrite long SCI_SETBACKSPACEUNINDENTS=2262
privatewrite long SCI_GETBACKSPACEUNINDENTS=2263
privatewrite long SC_TIME_FOREVER=10000000
privatewrite long SCI_SETMOUSEDWELLTIME=2264
privatewrite long SCI_GETMOUSEDWELLTIME=2265
privatewrite long SCI_WORDSTARTPOSITION=2266
privatewrite long SCI_WORDENDPOSITION=2267
privatewrite long SC_WRAP_NONE=0
privatewrite long SC_WRAP_WORD=1
privatewrite long SCI_SETWRAPMODE=2268
privatewrite long SCI_GETWRAPMODE=2269
privatewrite long SC_CACHE_NONE=0
privatewrite long SC_CACHE_CARET=1
privatewrite long SC_CACHE_PAGE=2
privatewrite long SC_CACHE_DOCUMENT=3
privatewrite long SCI_SETLAYOUTCACHE=2272
privatewrite long SCI_GETLAYOUTCACHE=2273
privatewrite long SCI_SETSCROLLWIDTH=2274
privatewrite long SCI_GETSCROLLWIDTH=2275
privatewrite long SCI_TEXTWIDTH=2276
privatewrite long SCI_SETENDATLASTLINE=2277
privatewrite long SCI_GETENDATLASTLINE=2278
privatewrite long SCI_TEXTHEIGHT=2279
privatewrite long SCI_SETVSCROLLBAR=2280
privatewrite long SCI_GETVSCROLLBAR=2281
privatewrite long SCI_APPENDTEXT=2282
privatewrite long SCI_GETTWOPHASEDRAW=2283
privatewrite long SCI_SETTWOPHASEDRAW=2284
privatewrite long SCI_TARGETFROMSELECTION=2287
privatewrite long SCI_LINESJOIN=2288
privatewrite long SCI_LINESSPLIT=2289
privatewrite long SCI_SETFOLDMARGINCOLOUR=2290
privatewrite long SCI_SETFOLDMARGINHICOLOUR=2291
privatewrite long SCI_LINEDOWN=2300
privatewrite long SCI_LINEDOWNEXTEND=2301
privatewrite long SCI_LINEUP=2302
privatewrite long SCI_LINEUPEXTEND=2303
privatewrite long SCI_CHARLEFT=2304
privatewrite long SCI_CHARLEFTEXTEND=2305
privatewrite long SCI_CHARRIGHT=2306
privatewrite long SCI_CHARRIGHTEXTEND=2307
privatewrite long SCI_WORDLEFT=2308
privatewrite long SCI_WORDLEFTEXTEND=2309
privatewrite long SCI_WORDRIGHT=2310
privatewrite long SCI_WORDRIGHTEXTEND=2311
privatewrite long SCI_HOME=2312
privatewrite long SCI_HOMEEXTEND=2313
privatewrite long SCI_LINEEND=2314
privatewrite long SCI_LINEENDEXTEND=2315
privatewrite long SCI_DOCUMENTSTART=2316
privatewrite long SCI_DOCUMENTSTARTEXTEND=2317
privatewrite long SCI_DOCUMENTEND=2318
privatewrite long SCI_DOCUMENTENDEXTEND=2319
privatewrite long SCI_PAGEUP=2320
privatewrite long SCI_PAGEUPEXTEND=2321
privatewrite long SCI_PAGEDOWN=2322
privatewrite long SCI_PAGEDOWNEXTEND=2323
privatewrite long SCI_EDITTOGGLEOVERTYPE=2324
privatewrite long SCI_CANCEL=2325
privatewrite long SCI_DELETEBACK=2326
privatewrite long SCI_TAB=2327
privatewrite long SCI_BACKTAB=2328
privatewrite long SCI_NEWLINE=2329
privatewrite long SCI_FORMFEED=2330
privatewrite long SCI_VCHOME=2331
privatewrite long SCI_VCHOMEEXTEND=2332
privatewrite long SCI_ZOOMIN=2333
privatewrite long SCI_ZOOMOUT=2334
privatewrite long SCI_DELWORDLEFT=2335
privatewrite long SCI_DELWORDRIGHT=2336
privatewrite long SCI_LINECUT=2337
privatewrite long SCI_LINEDELETE=2338
privatewrite long SCI_LINETRANSPOSE=2339
privatewrite long SCI_LINEDUPLICATE=2404
privatewrite long SCI_LOWERCASE=2340
privatewrite long SCI_UPPERCASE=2341
privatewrite long SCI_LINESCROLLDOWN=2342
privatewrite long SCI_LINESCROLLUP=2343
privatewrite long SCI_DELETEBACKNOTLINE=2344
privatewrite long SCI_HOMEDISPLAY=2345
privatewrite long SCI_HOMEDISPLAYEXTEND=2346
privatewrite long SCI_LINEENDDISPLAY=2347
privatewrite long SCI_LINEENDDISPLAYEXTEND=2348
privatewrite long SCI_MOVECARETINSIDEVIEW=2401
privatewrite long SCI_LINELENGTH=2350
privatewrite long SCI_BRACEHIGHLIGHT=2351
privatewrite long SCI_BRACEBADLIGHT=2352
privatewrite long SCI_BRACEMATCH=2353
privatewrite long SCI_GETVIEWEOL=2355
privatewrite long SCI_SETVIEWEOL=2356
privatewrite long SCI_GETDOCPOINTER=2357
privatewrite long SCI_SETDOCPOINTER=2358
privatewrite long SCI_SETMODEVENTMASK=2359
privatewrite long EDGE_NONE=0
privatewrite long EDGE_LINE=1
privatewrite long EDGE_BACKGROUND=2
privatewrite long SCI_GETEDGECOLUMN=2360
privatewrite long SCI_SETEDGECOLUMN=2361
privatewrite long SCI_GETEDGEMODE=2362
privatewrite long SCI_SETEDGEMODE=2363
privatewrite long SCI_GETEDGECOLOUR=2364
privatewrite long SCI_SETEDGECOLOUR=2365
privatewrite long SCI_SEARCHANCHOR=2366
privatewrite long SCI_SEARCHNEXT=2367
privatewrite long SCI_SEARCHPREV=2368
privatewrite long SCI_LINESONSCREEN=2370
privatewrite long SCI_USEPOPUP=2371
privatewrite long SCI_SELECTIONISRECTANGLE=2372
privatewrite long SCI_SETZOOM=2373
privatewrite long SCI_GETZOOM=2374
privatewrite long SCI_CREATEDOCUMENT=2375
privatewrite long SCI_ADDREFDOCUMENT=2376
privatewrite long SCI_RELEASEDOCUMENT=2377
privatewrite long SCI_GETMODEVENTMASK=2378
privatewrite long SCI_SETFOCUS=2380
privatewrite long SCI_GETFOCUS=2381
privatewrite long SCI_SETSTATUS=2382
privatewrite long SCI_GETSTATUS=2383
privatewrite long SCI_SETMOUSEDOWNCAPTURES=2384
privatewrite long SCI_GETMOUSEDOWNCAPTURES=2385
privatewrite long SC_CURSORNORMAL=-1
privatewrite long SC_CURSORWAIT=4
privatewrite long SCI_SETCURSOR=2386
privatewrite long SCI_GETCURSOR=2387
privatewrite long SCI_SETCONTROLCHARSYMBOL=2388
privatewrite long SCI_GETCONTROLCHARSYMBOL=2389
privatewrite long SCI_WORDPARTLEFT=2390
privatewrite long SCI_WORDPARTLEFTEXTEND=2391
privatewrite long SCI_WORDPARTRIGHT=2392
privatewrite long SCI_WORDPARTRIGHTEXTEND=2393
privatewrite long VISIBLE_SLOP=1//f_hex2long("01")
privatewrite long VISIBLE_STRICT=4//f_hex2long("04")
privatewrite long SCI_SETVISIBLEPOLICY=2394
privatewrite long SCI_DELLINELEFT=2395
privatewrite long SCI_DELLINERIGHT=2396
privatewrite long SCI_SETXOFFSET=2397
privatewrite long SCI_GETXOFFSET=2398
privatewrite long SCI_CHOOSECARETX=2399
privatewrite long SCI_GRABFOCUS=2400
privatewrite long CARET_SLOP=1//f_hex2long("01")
privatewrite long CARET_STRICT=4//f_hex2long("04")
privatewrite long CARET_JUMPS=16//f_hex2long("10")
privatewrite long CARET_EVEN=8//f_hex2long("08")
privatewrite long SCI_SETXCARETPOLICY=2402
privatewrite long SCI_SETYCARETPOLICY=2403
privatewrite long SCI_SETPRINTWRAPMODE=2406
privatewrite long SCI_GETPRINTWRAPMODE=2407
privatewrite long SCI_STARTRECORD=3001
privatewrite long SCI_STOPRECORD=3002
privatewrite long SCI_SETLEXER=4001
privatewrite long SCI_GETLEXER=4002
privatewrite long SCI_COLOURISE=4003
privatewrite long SCI_SETPROPERTY=4004
privatewrite long SCI_SETKEYWORDS=4005
privatewrite long SCI_SETLEXERLANGUAGE=4006
privatewrite long SC_MOD_INSERTTEXT=1//f_hex2long("1")
privatewrite long SC_MOD_DELETETEXT=2//f_hex2long("2")
privatewrite long SC_MOD_CHANGESTYLE=4//f_hex2long("4")
privatewrite long SC_MOD_CHANGEFOLD=8//f_hex2long("8")
privatewrite long SC_PERFORMED_USER=16//f_hex2long("10")
privatewrite long SC_PERFORMED_UNDO=32//f_hex2long("20")
privatewrite long SC_PERFORMED_REDO=64//f_hex2long("40")
privatewrite long SC_LASTSTEPINUNDOREDO=256//f_hex2long("100")
privatewrite long SC_MOD_CHANGEMARKER=512//f_hex2long("200")
privatewrite long SC_MOD_BEFOREINSERT=1024//f_hex2long("400")
privatewrite long SC_MOD_BEFOREDELETE=2048//f_hex2long("800")
privatewrite long SC_MODEVENTMASKALL=3959//f_hex2long("F77")
privatewrite long SCEN_CHANGE=768
privatewrite long SCEN_SETFOCUS=512
privatewrite long SCEN_KILLFOCUS=256
privatewrite long SCK_DOWN=300
privatewrite long SCK_UP=301
privatewrite long SCK_LEFT=302
privatewrite long SCK_RIGHT=303
privatewrite long SCK_HOME=304
privatewrite long SCK_END=305
privatewrite long SCK_PRIOR=306
privatewrite long SCK_NEXT=307
privatewrite long SCK_DELETE=308
privatewrite long SCK_INSERT=309
privatewrite long SCK_ESCAPE=7
privatewrite long SCK_BACK=8
privatewrite long SCK_TAB=9
privatewrite long SCK_RETURN=13
privatewrite long SCK_ADD=310
privatewrite long SCK_SUBTRACT=311
privatewrite long SCK_DIVIDE=312
privatewrite long SCMOD_SHIFT=1
privatewrite long SCMOD_CTRL=2
privatewrite long SCMOD_ALT=4
privatewrite long SCN_STYLENEEDED=2000
privatewrite long SCN_CHARADDED=2001
privatewrite long SCN_SAVEPOINTREACHED=2002
privatewrite long SCN_SAVEPOINTLEFT=2003
privatewrite long SCN_MODIFYATTEMPTRO=2004
privatewrite long SCN_KEY=2005
privatewrite long SCN_DOUBLECLICK=2006
privatewrite long SCN_UPDATEUI=2007
privatewrite long SCN_MODIFIED=2008
privatewrite long SCN_MACRORECORD=2009
privatewrite long SCN_MARGINCLICK=2010
privatewrite long SCN_NEEDSHOWN=2011
privatewrite long SCN_PAINTED=2013
privatewrite long SCN_USERLISTSELECTION=2014
privatewrite long SCN_URIDROPPED=2015
privatewrite long SCN_DWELLSTART=2016
privatewrite long SCN_DWELLEND=2017
privatewrite long SCN_ZOOM=2018

//++Autogenerated -- start of section automatically generated from Scintilla.iface
privatewrite long SCLEX_CONTAINER=0
privatewrite long SCLEX_NULL=1
privatewrite long SCLEX_PYTHON=2
privatewrite long SCLEX_CPP=3
privatewrite long SCLEX_HTML=4
privatewrite long SCLEX_XML=5
privatewrite long SCLEX_PERL=6
privatewrite long SCLEX_SQL=7
privatewrite long SCLEX_VB=8
privatewrite long SCLEX_PROPERTIES=9
privatewrite long SCLEX_ERRORLIST=10
privatewrite long SCLEX_MAKEFILE=11
privatewrite long SCLEX_BATCH=12
privatewrite long SCLEX_XCODE=13
privatewrite long SCLEX_LATEX=14
privatewrite long SCLEX_LUA=15
privatewrite long SCLEX_DIFF=16
privatewrite long SCLEX_CONF=17
privatewrite long SCLEX_PASCAL=18
privatewrite long SCLEX_AVE=19
privatewrite long SCLEX_ADA=20
privatewrite long SCLEX_LISP=21
privatewrite long SCLEX_RUBY=22
privatewrite long SCLEX_EIFFEL=23
privatewrite long SCLEX_EIFFELKW=24
privatewrite long SCLEX_TCL=25
privatewrite long SCLEX_NNCRONTAB=26
privatewrite long SCLEX_BULLANT=27
privatewrite long SCLEX_VBSCRIPT=28
privatewrite long SCLEX_ASP=29
privatewrite long SCLEX_PHP=30
privatewrite long SCLEX_BAAN=31
privatewrite long SCLEX_MATLAB=32
privatewrite long SCLEX_SCRIPTOL=33
privatewrite long SCLEX_ASM=34
privatewrite long SCLEX_CPPNOCASE=35
privatewrite long SCLEX_FORTRAN=36
privatewrite long SCLEX_F77=37
privatewrite long SCLEX_CSS=38
privatewrite long SCLEX_AUTOMATIC=1000
privatewrite long SCE_P_DEFAULT=0
privatewrite long SCE_P_COMMENTLINE=1
privatewrite long SCE_P_NUMBER=2
privatewrite long SCE_P_STRING=3
privatewrite long SCE_P_CHARACTER=4
privatewrite long SCE_P_WORD=5
privatewrite long SCE_P_TRIPLE=6
privatewrite long SCE_P_TRIPLEDOUBLE=7
privatewrite long SCE_P_CLASSNAME=8
privatewrite long SCE_P_DEFNAME=9
privatewrite long SCE_P_OPERATOR=10
privatewrite long SCE_P_IDENTIFIER=11
privatewrite long SCE_P_COMMENTBLOCK=12
privatewrite long SCE_P_STRINGEOL=13
privatewrite long SCE_C_DEFAULT=0
privatewrite long SCE_C_COMMENT=1
privatewrite long SCE_C_COMMENTLINE=2
privatewrite long SCE_C_COMMENTDOC=3
privatewrite long SCE_C_NUMBER=4
privatewrite long SCE_C_WORD=5
privatewrite long SCE_C_STRING=6
privatewrite long SCE_C_CHARACTER=7
privatewrite long SCE_C_UUID=8
privatewrite long SCE_C_PREPROCESSOR=9
privatewrite long SCE_C_OPERATOR=10
privatewrite long SCE_C_IDENTIFIER=11
privatewrite long SCE_C_STRINGEOL=12
privatewrite long SCE_C_VERBATIM=13
privatewrite long SCE_C_REGEX=14
privatewrite long SCE_C_COMMENTLINEDOC=15
privatewrite long SCE_C_WORD2=16
privatewrite long SCE_C_COMMENTDOCKEYWORD=17
privatewrite long SCE_C_COMMENTDOCKEYWORDERROR=18
privatewrite long SCE_H_DEFAULT=0
privatewrite long SCE_H_TAG=1
privatewrite long SCE_H_TAGUNKNOWN=2
privatewrite long SCE_H_ATTRIBUTE=3
privatewrite long SCE_H_ATTRIBUTEUNKNOWN=4
privatewrite long SCE_H_NUMBER=5
privatewrite long SCE_H_DOUBLESTRING=6
privatewrite long SCE_H_SINGLESTRING=7
privatewrite long SCE_H_OTHER=8
privatewrite long SCE_H_COMMENT=9
privatewrite long SCE_H_ENTITY=10
privatewrite long SCE_H_TAGEND=11
privatewrite long SCE_H_XMLSTART=12
privatewrite long SCE_H_XMLEND=13
privatewrite long SCE_H_SCRIPT=14
privatewrite long SCE_H_ASP=15
privatewrite long SCE_H_ASPAT=16
privatewrite long SCE_H_CDATA=17
privatewrite long SCE_H_QUESTION=18
privatewrite long SCE_H_VALUE=19
privatewrite long SCE_H_XCCOMMENT=20
privatewrite long SCE_H_SGML_DEFAULT=21
privatewrite long SCE_H_SGML_COMMAND=22
privatewrite long SCE_H_SGML_1ST_PARAM=23
privatewrite long SCE_H_SGML_DOUBLESTRING=24
privatewrite long SCE_H_SGML_SIMPLESTRING=25
privatewrite long SCE_H_SGML_ERROR=26
privatewrite long SCE_H_SGML_SPECIAL=27
privatewrite long SCE_H_SGML_ENTITY=28
privatewrite long SCE_H_SGML_COMMENT=29
privatewrite long SCE_H_SGML_1ST_PARAM_COMMENT=30
privatewrite long SCE_H_SGML_BLOCK_DEFAULT=31
privatewrite long SCE_HJ_START=40
privatewrite long SCE_HJ_DEFAULT=41
privatewrite long SCE_HJ_COMMENT=42
privatewrite long SCE_HJ_COMMENTLINE=43
privatewrite long SCE_HJ_COMMENTDOC=44
privatewrite long SCE_HJ_NUMBER=45
privatewrite long SCE_HJ_WORD=46
privatewrite long SCE_HJ_KEYWORD=47
privatewrite long SCE_HJ_DOUBLESTRING=48
privatewrite long SCE_HJ_SINGLESTRING=49
privatewrite long SCE_HJ_SYMBOLS=50
privatewrite long SCE_HJ_STRINGEOL=51
privatewrite long SCE_HJ_REGEX=52
privatewrite long SCE_HJA_START=55
privatewrite long SCE_HJA_DEFAULT=56
privatewrite long SCE_HJA_COMMENT=57
privatewrite long SCE_HJA_COMMENTLINE=58
privatewrite long SCE_HJA_COMMENTDOC=59
privatewrite long SCE_HJA_NUMBER=60
privatewrite long SCE_HJA_WORD=61
privatewrite long SCE_HJA_KEYWORD=62
privatewrite long SCE_HJA_DOUBLESTRING=63
privatewrite long SCE_HJA_SINGLESTRING=64
privatewrite long SCE_HJA_SYMBOLS=65
privatewrite long SCE_HJA_STRINGEOL=66
privatewrite long SCE_HJA_REGEX=67
privatewrite long SCE_HB_START=70
privatewrite long SCE_HB_DEFAULT=71
privatewrite long SCE_HB_COMMENTLINE=72
privatewrite long SCE_HB_NUMBER=73
privatewrite long SCE_HB_WORD=74
privatewrite long SCE_HB_STRING=75
privatewrite long SCE_HB_IDENTIFIER=76
privatewrite long SCE_HB_STRINGEOL=77
privatewrite long SCE_HBA_START=80
privatewrite long SCE_HBA_DEFAULT=81
privatewrite long SCE_HBA_COMMENTLINE=82
privatewrite long SCE_HBA_NUMBER=83
privatewrite long SCE_HBA_WORD=84
privatewrite long SCE_HBA_STRING=85
privatewrite long SCE_HBA_IDENTIFIER=86
privatewrite long SCE_HBA_STRINGEOL=87
privatewrite long SCE_HP_START=90
privatewrite long SCE_HP_DEFAULT=91
privatewrite long SCE_HP_COMMENTLINE=92
privatewrite long SCE_HP_NUMBER=93
privatewrite long SCE_HP_STRING=94
privatewrite long SCE_HP_CHARACTER=95
privatewrite long SCE_HP_WORD=96
privatewrite long SCE_HP_TRIPLE=97
privatewrite long SCE_HP_TRIPLEDOUBLE=98
privatewrite long SCE_HP_CLASSNAME=99
privatewrite long SCE_HP_DEFNAME=100
privatewrite long SCE_HP_OPERATOR=101
privatewrite long SCE_HP_IDENTIFIER=102
privatewrite long SCE_HPA_START=105
privatewrite long SCE_HPA_DEFAULT=106
privatewrite long SCE_HPA_COMMENTLINE=107
privatewrite long SCE_HPA_NUMBER=108
privatewrite long SCE_HPA_STRING=109
privatewrite long SCE_HPA_CHARACTER=110
privatewrite long SCE_HPA_WORD=111
privatewrite long SCE_HPA_TRIPLE=112
privatewrite long SCE_HPA_TRIPLEDOUBLE=113
privatewrite long SCE_HPA_CLASSNAME=114
privatewrite long SCE_HPA_DEFNAME=115
privatewrite long SCE_HPA_OPERATOR=116
privatewrite long SCE_HPA_IDENTIFIER=117
privatewrite long SCE_HPHP_DEFAULT=118
privatewrite long SCE_HPHP_HSTRING=119
privatewrite long SCE_HPHP_SIMPLESTRING=120
privatewrite long SCE_HPHP_WORD=121
privatewrite long SCE_HPHP_NUMBER=122
privatewrite long SCE_HPHP_VARIABLE=123
privatewrite long SCE_HPHP_COMMENT=124
privatewrite long SCE_HPHP_COMMENTLINE=125
privatewrite long SCE_HPHP_HSTRING_VARIABLE=126
privatewrite long SCE_HPHP_OPERATOR=127
privatewrite long SCE_PL_DEFAULT=0
privatewrite long SCE_PL_ERROR=1
privatewrite long SCE_PL_COMMENTLINE=2
privatewrite long SCE_PL_POD=3
privatewrite long SCE_PL_NUMBER=4
privatewrite long SCE_PL_WORD=5
privatewrite long SCE_PL_STRING=6
privatewrite long SCE_PL_CHARACTER=7
privatewrite long SCE_PL_PUNCTUATION=8
privatewrite long SCE_PL_PREPROCESSOR=9
privatewrite long SCE_PL_OPERATOR=10
privatewrite long SCE_PL_IDENTIFIER=11
privatewrite long SCE_PL_SCALAR=12
privatewrite long SCE_PL_ARRAY=13
privatewrite long SCE_PL_HASH=14
privatewrite long SCE_PL_SYMBOLTABLE=15
privatewrite long SCE_PL_REGEX=17
privatewrite long SCE_PL_REGSUBST=18
privatewrite long SCE_PL_LONGQUOTE=19
privatewrite long SCE_PL_BACKTICKS=20
privatewrite long SCE_PL_DATASECTION=21
privatewrite long SCE_PL_HERE_DELIM=22
privatewrite long SCE_PL_HERE_Q=23
privatewrite long SCE_PL_HERE_QQ=24
privatewrite long SCE_PL_HERE_QX=25
privatewrite long SCE_PL_STRING_Q=26
privatewrite long SCE_PL_STRING_QQ=27
privatewrite long SCE_PL_STRING_QX=28
privatewrite long SCE_PL_STRING_QR=29
privatewrite long SCE_PL_STRING_QW=30
privatewrite long SCE_B_DEFAULT=0
privatewrite long SCE_B_COMMENT=1
privatewrite long SCE_B_NUMBER=2
privatewrite long SCE_B_KEYWORD=3
privatewrite long SCE_B_STRING=4
privatewrite long SCE_B_PREPROCESSOR=5
privatewrite long SCE_B_OPERATOR=6
privatewrite long SCE_B_IDENTIFIER=7
privatewrite long SCE_B_DATE=8
privatewrite long SCE_PROPS_DEFAULT=0
privatewrite long SCE_PROPS_COMMENT=1
privatewrite long SCE_PROPS_SECTION=2
privatewrite long SCE_PROPS_ASSIGNMENT=3
privatewrite long SCE_PROPS_DEFVAL=4
privatewrite long SCE_L_DEFAULT=0
privatewrite long SCE_L_COMMAND=1
privatewrite long SCE_L_TAG=2
privatewrite long SCE_L_MATH=3
privatewrite long SCE_L_COMMENT=4
privatewrite long SCE_LUA_DEFAULT=0
privatewrite long SCE_LUA_COMMENT=1
privatewrite long SCE_LUA_COMMENTLINE=2
privatewrite long SCE_LUA_COMMENTDOC=3
privatewrite long SCE_LUA_NUMBER=4
privatewrite long SCE_LUA_WORD=5
privatewrite long SCE_LUA_STRING=6
privatewrite long SCE_LUA_CHARACTER=7
privatewrite long SCE_LUA_LITERALSTRING=8
privatewrite long SCE_LUA_PREPROCESSOR=9
privatewrite long SCE_LUA_OPERATOR=10
privatewrite long SCE_LUA_IDENTIFIER=11
privatewrite long SCE_LUA_STRINGEOL=12
privatewrite long SCE_LUA_WORD2=13
privatewrite long SCE_LUA_WORD3=14
privatewrite long SCE_LUA_WORD4=15
privatewrite long SCE_LUA_WORD5=16
privatewrite long SCE_LUA_WORD6=17
privatewrite long SCE_ERR_DEFAULT=0
privatewrite long SCE_ERR_PYTHON=1
privatewrite long SCE_ERR_GCC=2
privatewrite long SCE_ERR_MS=3
privatewrite long SCE_ERR_CMD=4
privatewrite long SCE_ERR_BORLAND=5
privatewrite long SCE_ERR_PERL=6
privatewrite long SCE_ERR_NET=7
privatewrite long SCE_ERR_LUA=8
privatewrite long SCE_ERR_CTAG=9
privatewrite long SCE_ERR_DIFF_CHANGED=10
privatewrite long SCE_ERR_DIFF_ADDITION=11
privatewrite long SCE_ERR_DIFF_DELETION=12
privatewrite long SCE_ERR_DIFF_MESSAGE=13
privatewrite long SCE_ERR_PHP=14
privatewrite long SCE_BAT_DEFAULT=0
privatewrite long SCE_BAT_COMMENT=1
privatewrite long SCE_BAT_WORD=2
privatewrite long SCE_BAT_LABEL=3
privatewrite long SCE_BAT_HIDE=4
privatewrite long SCE_BAT_COMMAND=5
privatewrite long SCE_BAT_IDENTIFIER=6
privatewrite long SCE_BAT_OPERATOR=7
privatewrite long SCE_MAKE_DEFAULT=0
privatewrite long SCE_MAKE_COMMENT=1
privatewrite long SCE_MAKE_PREPROCESSOR=2
privatewrite long SCE_MAKE_IDENTIFIER=3
privatewrite long SCE_MAKE_OPERATOR=4
privatewrite long SCE_MAKE_TARGET=5
privatewrite long SCE_MAKE_IDEOL=9
privatewrite long SCE_DIFF_DEFAULT=0
privatewrite long SCE_DIFF_COMMENT=1
privatewrite long SCE_DIFF_COMMAND=2
privatewrite long SCE_DIFF_HEADER=3
privatewrite long SCE_DIFF_POSITION=4
privatewrite long SCE_DIFF_DELETED=5
privatewrite long SCE_DIFF_ADDED=6
privatewrite long SCE_CONF_DEFAULT=0
privatewrite long SCE_CONF_COMMENT=1
privatewrite long SCE_CONF_NUMBER=2
privatewrite long SCE_CONF_IDENTIFIER=3
privatewrite long SCE_CONF_EXTENSION=4
privatewrite long SCE_CONF_PARAMETER=5
privatewrite long SCE_CONF_STRING=6
privatewrite long SCE_CONF_OPERATOR=7
privatewrite long SCE_CONF_IP=8
privatewrite long SCE_CONF_DIRECTIVE=9
privatewrite long SCE_AVE_DEFAULT=0
privatewrite long SCE_AVE_COMMENT=1
privatewrite long SCE_AVE_NUMBER=2
privatewrite long SCE_AVE_WORD=3
privatewrite long SCE_AVE_STRING=6
privatewrite long SCE_AVE_ENUM=7
privatewrite long SCE_AVE_STRINGEOL=8
privatewrite long SCE_AVE_IDENTIFIER=9
privatewrite long SCE_AVE_OPERATOR=10
privatewrite long SCE_AVE_WORD1=11
privatewrite long SCE_AVE_WORD2=12
privatewrite long SCE_AVE_WORD3=13
privatewrite long SCE_AVE_WORD4=14
privatewrite long SCE_AVE_WORD5=15
privatewrite long SCE_AVE_WORD6=16
privatewrite long SCE_ADA_DEFAULT=0
privatewrite long SCE_ADA_WORD=1
privatewrite long SCE_ADA_IDENTIFIER=2
privatewrite long SCE_ADA_NUMBER=3
privatewrite long SCE_ADA_DELIMITER=4
privatewrite long SCE_ADA_CHARACTER=5
privatewrite long SCE_ADA_CHARACTEREOL=6
privatewrite long SCE_ADA_STRING=7
privatewrite long SCE_ADA_STRINGEOL=8
privatewrite long SCE_ADA_LABEL=9
privatewrite long SCE_ADA_COMMENTLINE=10
privatewrite long SCE_ADA_ILLEGAL=11
privatewrite long SCE_BAAN_DEFAULT=0
privatewrite long SCE_BAAN_COMMENT=1
privatewrite long SCE_BAAN_COMMENTDOC=2
privatewrite long SCE_BAAN_NUMBER=3
privatewrite long SCE_BAAN_WORD=4
privatewrite long SCE_BAAN_STRING=5
privatewrite long SCE_BAAN_PREPROCESSOR=6
privatewrite long SCE_BAAN_OPERATOR=7
privatewrite long SCE_BAAN_IDENTIFIER=8
privatewrite long SCE_BAAN_STRINGEOL=9
privatewrite long SCE_BAAN_WORD2=10
privatewrite long SCE_LISP_DEFAULT=0
privatewrite long SCE_LISP_COMMENT=1
privatewrite long SCE_LISP_NUMBER=2
privatewrite long SCE_LISP_KEYWORD=3
privatewrite long SCE_LISP_STRING=6
privatewrite long SCE_LISP_STRINGEOL=8
privatewrite long SCE_LISP_IDENTIFIER=9
privatewrite long SCE_LISP_OPERATOR=10
privatewrite long SCE_EIFFEL_DEFAULT=0
privatewrite long SCE_EIFFEL_COMMENTLINE=1
privatewrite long SCE_EIFFEL_NUMBER=2
privatewrite long SCE_EIFFEL_WORD=3
privatewrite long SCE_EIFFEL_STRING=4
privatewrite long SCE_EIFFEL_CHARACTER=5
privatewrite long SCE_EIFFEL_OPERATOR=6
privatewrite long SCE_EIFFEL_IDENTIFIER=7
privatewrite long SCE_EIFFEL_STRINGEOL=8
privatewrite long SCE_NNCRONTAB_DEFAULT=0
privatewrite long SCE_NNCRONTAB_COMMENT=1
privatewrite long SCE_NNCRONTAB_TASK=2
privatewrite long SCE_NNCRONTAB_SECTION=3
privatewrite long SCE_NNCRONTAB_KEYWORD=4
privatewrite long SCE_NNCRONTAB_MODIFIER=5
privatewrite long SCE_NNCRONTAB_ASTERISK=6
privatewrite long SCE_NNCRONTAB_NUMBER=7
privatewrite long SCE_NNCRONTAB_STRING=8
privatewrite long SCE_NNCRONTAB_ENVIRONMENT=9
privatewrite long SCE_NNCRONTAB_IDENTIFIER=10
privatewrite long SCE_MATLAB_DEFAULT=0
privatewrite long SCE_MATLAB_COMMENT=1
privatewrite long SCE_MATLAB_COMMAND=2
privatewrite long SCE_MATLAB_NUMBER=3
privatewrite long SCE_MATLAB_KEYWORD=4
privatewrite long SCE_MATLAB_STRING=5
privatewrite long SCE_MATLAB_OPERATOR=6
privatewrite long SCE_MATLAB_IDENTIFIER=7
privatewrite long SCE_SCRIPTOL_DEFAULT=0
privatewrite long SCE_SCRIPTOL_COMMENT=1
privatewrite long SCE_SCRIPTOL_COMMENTLINE=2
privatewrite long SCE_SCRIPTOL_COMMENTDOC=3
privatewrite long SCE_SCRIPTOL_NUMBER=4
privatewrite long SCE_SCRIPTOL_WORD=5
privatewrite long SCE_SCRIPTOL_STRING=6
privatewrite long SCE_SCRIPTOL_CHARACTER=7
privatewrite long SCE_SCRIPTOL_UUID=8
privatewrite long SCE_SCRIPTOL_PREPROCESSOR=9
privatewrite long SCE_SCRIPTOL_OPERATOR=10
privatewrite long SCE_SCRIPTOL_IDENTIFIER=11
privatewrite long SCE_SCRIPTOL_STRINGEOL=12
privatewrite long SCE_SCRIPTOL_VERBATIM=13
privatewrite long SCE_SCRIPTOL_REGEX=14
privatewrite long SCE_SCRIPTOL_COMMENTLINEDOC=15
privatewrite long SCE_SCRIPTOL_WORD2=16
privatewrite long SCE_SCRIPTOL_COMMENTDOCKEYWORD=17
privatewrite long SCE_SCRIPTOL_COMMENTDOCKEYWORDERROR=18
privatewrite long SCE_SCRIPTOL_COMMENTBASIC=19
privatewrite long SCE_ASM_DEFAULT=0
privatewrite long SCE_ASM_COMMENT=1
privatewrite long SCE_ASM_NUMBER=2
privatewrite long SCE_ASM_STRING=3
privatewrite long SCE_ASM_OPERATOR=4
privatewrite long SCE_ASM_IDENTIFIER=5
privatewrite long SCE_ASM_CPUINSTRUCTION=6
privatewrite long SCE_ASM_MATHINSTRUCTION=7
privatewrite long SCE_ASM_REGISTER=8
privatewrite long SCE_ASM_DIRECTIVE=9
privatewrite long SCE_ASM_DIRECTIVEOPERAND=10
privatewrite long SCE_F_DEFAULT=0
privatewrite long SCE_F_COMMENT=1
privatewrite long SCE_F_NUMBER=2
privatewrite long SCE_F_STRING1=3
privatewrite long SCE_F_STRING2=4
privatewrite long SCE_F_STRINGEOL=5
privatewrite long SCE_F_OPERATOR=6
privatewrite long SCE_F_IDENTIFIER=7
privatewrite long SCE_F_WORD=8
privatewrite long SCE_F_WORD2=9
privatewrite long SCE_F_WORD3=10
privatewrite long SCE_F_PREPROCESSOR=11
privatewrite long SCE_F_OPERATOR2=12
privatewrite long SCE_F_LABEL=13
privatewrite long SCE_F_CONTINUATION=14
privatewrite long SCE_CSS_DEFAULT=0
privatewrite long SCE_CSS_TAG=1
privatewrite long SCE_CSS_CLASS=2
privatewrite long SCE_CSS_PSEUDOCLASS=3
privatewrite long SCE_CSS_UNKNOWN_PSEUDOCLASS=4
privatewrite long SCE_CSS_OPERATOR=5
privatewrite long SCE_CSS_IDENTIFIER=6
privatewrite long SCE_CSS_UNKNOWN_IDENTIFIER=7
privatewrite long SCE_CSS_VALUE=8
privatewrite long SCE_CSS_COMMENT=9
privatewrite long SCE_CSS_ID=10
privatewrite long SCE_CSS_IMPORTANT=11
privatewrite long SCE_CSS_DIRECTIVE=12

privatewrite long SCN_DMLUCTRLHOVER=2333
end variables

forward prototypes
public function long of_send (long msg, long wparm, readonly string lparm)
public function long of_sendref (long msg, long wparm, ref string lparm)
public function long of_send (long msg, long wparm, long lparm)
public function boolean of_print (readonly window mainwindow, boolean showdlg)
public subroutine of_definemarker (long marker, long markertype, long fore, long back)
public function string of_gettextrange (long al_start, long al_end)
private function blob of_s2b (readonly string s)
private function string of_b2s (readonly blob b)
public function long of_send (long msg, readonly string wparm, readonly string lparm)
private function long of_l2s (long address, ref string as_out)
public function boolean of_appendtext (readonly string s)
end prototypes

event resize;mle_1.resize(newwidth,newheight)
MoveWindow(sci_hwnd,0,0,&
	UnitsToPixels(newwidth,XUnitsToPixels!),UnitsToPixels(newheight,YUnitsToPixels!),&
	true)

end event

event setfocus;post(sci_hwnd,SCI_GRABFOCUS,0,0)

end event

event scn_charadded(long ch);//
end event

event scn_marginclick(long position, long modifiers);long lineClick
long levelClick
long i
lineClick = of_send(SCI_LINEFROMPOSITION, position,0)
levelClick = of_send(SCI_GETFOLDLEVEL, lineClick,0)

i=levelClick - mod(levelClick,SC_FOLDLEVELHEADERFLAG)
i=mod(i,SC_FOLDLEVELHEADERFLAG*2)
if i=SC_FOLDLEVELHEADERFLAG then
	of_send(SCI_TOGGLEFOLD, lineClick,0)
end if


end event

event scn_savepoint(boolean b);//
end event

event scn_userlistselection(long listtype, readonly string s);//

end event

event scn_ctrlhover(long pos, long len);//
end event

public function long of_send (long msg, long wparm, readonly string lparm);blob b
b=of_s2b(lparm)
return sendmessage(sci_hwnd,msg,wparm,b)

end function

public function long of_sendref (long msg, long wparm, ref string lparm);long ret
blob b
b=of_s2b(lparm)
ret=sendmessage(sci_hwnd,msg,wparm,b)
lparm=of_b2s(b)
return ret

end function

public function long of_send (long msg, long wparm, long lparm);return send(sci_hwnd,msg,wparm,lparm)

end function

public function boolean of_print (readonly window mainwindow, boolean showdlg);//mainwindow
return SciPrint(handle(mainwindow),sci_hwnd,showdlg)

end function

public subroutine of_definemarker (long marker, long markertype, long fore, long back);of_send(SCI_MARKERDEFINE, marker, markerType)
of_send(SCI_MARKERSETFORE, marker, fore)
of_send(SCI_MARKERSETBACK, marker, back)

end subroutine

public function string of_gettextrange (long al_start, long al_end);sct_TextRange tr
tr.cpmin=al_start
tr.cpmax=al_end
tr.text=of_s2b(space(al_end - al_start+5))
if SendMessage(sci_hwnd, SCI_GETTEXTRANGE, 0, tr) >=0 then 
	return of_b2s(tr.text)
end if
return ''

end function

private function blob of_s2b (readonly string s);//converts string to multibyte according to the current charset of editor (ansi or utf8)
long len
blob b

len=gn_unicode.of_string2mb(of_send(SCI_GETCODEPAGE,0,0)=SC_CP_UTF8, s, b)

return b

end function

private function string of_b2s (readonly blob b);//converts multibyte to string according to the current charset of editor (ansi or utf8)
encoding e
if of_send(SCI_GETCODEPAGE,0,0)=SC_CP_UTF8 then
	e=EncodingUTF8!
else
	e=EncodingANSI!
end if
return string(b,e)

end function

public function long of_send (long msg, readonly string wparm, readonly string lparm);blob bw,bl

bw=of_s2b(wparm)
bl=of_s2b(lparm)

return SendMessage(sci_hwnd,msg,bw,bl)

end function

private function long of_l2s (long address, ref string as_out);return gn_unicode.of_mblong2string(of_send(SCI_GETCODEPAGE,0,0)=SC_CP_UTF8,address,as_out)

end function

public function boolean of_appendtext (readonly string s);
this.of_send( this.SCI_APPENDTEXT, gn_unicode.of_getuft8len( s ), s )

return true

end function

on uo_scintilla.create
this.mle_1=create mle_1
this.Control[]={this.mle_1}
end on

on uo_scintilla.destroy
destroy(this.mle_1)
end on

event constructor;ulong WS_CHILD,WS_VISIBLE,WS_TABSTOP,WS_VSCROLL,WS_HSCROLL,ES_AUTOVSCROLL,ES_AUTOHSCROLL
WS_CHILD  =f_hex2long('0x40000000')
WS_TABSTOP=f_hex2long('0x00010000')
WS_VISIBLE=f_hex2long('0x10000000')
WS_VSCROLL=f_hex2long('0x00200000')
WS_HSCROLL=f_hex2long('0x00100000')
ES_AUTOVSCROLL=f_hex2long('0x0040L')
ES_AUTOHSCROLL=f_hex2long('0x0080L')


sci_lib=LoadLibrary('SciLexer.dll')
sci_prn_lib=LoadLibrary('sciprint.dll')

sci_hwnd=CreateWindowEx(0,	"Scintilla","sql", &
	WS_CHILD+WS_VISIBLE+WS_TABSTOP+WS_VSCROLL+WS_HSCROLL+ES_AUTOVSCROLL+ES_AUTOHSCROLL, &
	0, 0, 80, 80, handle(mle_1), &
	0,/*menu*/ &
	0, 0)

of_send(SCI_SETCODEPAGE,SC_CP_UTF8,0)
of_send(SCI_SETVSCROLLBAR,1,0)

end event

event destructor;DestroyWindow(sci_hwnd)
FreeLibrary(sci_lib)
FreeLibrary(sci_prn_lib)

end event

event getfocus;post(sci_hwnd,SCI_GETFOCUS,0,0)

end event

type mle_1 from multilineedit within uo_scintilla
event contextmenu pbm_contextmenu
event parentnotify pbm_parentnotify
integer width = 480
integer height = 400
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 76585128
boolean border = false
boolean displayonly = true
end type

event contextmenu;parent.event contextmenu(xpos,ypos)
message.Processed=true

end event

event parentnotify;if intlow(wparam)=513 /*WM_LBUTTONDOWN*/ then
	parent.event scn_lbuttondown()
end if

end event

event getfocus;post(sci_hwnd,SCI_GRABFOCUS,0,0)

end event

event other;scNotification scn
string s
if message.number=78 then
	RtlMoveMemory(scn,lparam,80)
	CHOOSE CASE scn.code
		CASE SCN_CHARADDED
			parent.event scn_charadded(scn.ch)
		CASE SCN_MARGINCLICK
			parent.event scn_marginclick(scn.position,scn.modifiers)
		CASE SCN_UPDATEUI
			parent.event scn_updateui()
		CASE SCN_SAVEPOINTREACHED
			parent.event scn_savepoint(true)
		CASE SCN_SAVEPOINTLEFT
			parent.event scn_savepoint(false)
		CASE SCN_USERLISTSELECTION
			of_l2s(scn.text,s)
			parent.event scn_userlistselection(scn.listtype,s)
		CASE SCN_DWELLSTART
			parent.event scn_dwellmouse(scn.position,scn.x,scn.y,true)
		CASE SCN_DWELLEND
			parent.event scn_dwellmouse(scn.position,scn.x,scn.y,false)
		CASE SCN_DMLUCTRLHOVER
			parent.event scn_ctrlhover(scn.position,scn.length)
	END CHOOSE
end if

end event

