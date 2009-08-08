HA$PBExportHeader$n_file.sru
forward
global type n_file from nonvisualobject
end type
type t_openfilename from structure within n_file
end type
end forward

type t_openfilename from structure
	long		lstructsize
	long		hwndowner
	long		hinstance
	blob		lpstrfilter
	long		lpstrcustomfilter
	long		nmaxcustomfilter
	long		nfilterindex
	blob		lpstrfile
	long		nmaxfile
	long		lpstrfiletitle
	long		nmaxfiletitle
	long		lpstrinitialdir
	string		lpstrtitle
	long		flags
	integer		nfileoffset
	integer		nfileextension
	string		lpstrdefext
	long		lcustdata
	long		lpfnhook
	long		lptemplatename
end type

global type n_file from nonvisualobject autoinstantiate
end type

type prototypes
private function long GetOpenFileName(ref T_OPENFILENAME lpofn)library "comdlg32.dll" alias for "GetOpenFileNameW"
private function long GetSaveFileName(ref T_OPENFILENAME lpofn)library "comdlg32.dll" alias for "GetSaveFileNameW"
private subroutine RtlMoveMemory( ref long dest, ref blob src, long srclen ) library 'kernel32.dll'
private function long lstrlenA(ref blob b)library 'kernel32' alias for 'lstrlenA'


end prototypes

type variables
// Flags constants
privatewrite CONSTANT long OFN_READONLY			= 1
privatewrite CONSTANT long OFN_OVERWRITEPROMPT		= 2
privatewrite CONSTANT long OFN_HIDEREADONLY		= 4
privatewrite CONSTANT long OFN_NOCHANGEDIR		= 8
privatewrite CONSTANT long OFN_SHOWHELP			= 16
privatewrite CONSTANT long OFN_ENABLEHOOK			= 32
privatewrite CONSTANT long OFN_ENABLETEMPLATE		= 64
privatewrite CONSTANT long OFN_ENABLETEMPLATEHANDLE	= 128
privatewrite CONSTANT long OFN_NOVALIDATE			= 256
privatewrite CONSTANT long OFN_ALLOWMULTISELECT		= 512
privatewrite CONSTANT long OFN_EXTENSIONDIFFERENT		= 1024
privatewrite CONSTANT long OFN_PATHMUSTEXIST		= 2048
privatewrite CONSTANT long OFN_FILEMUSTEXIST		= 4096
privatewrite CONSTANT long OFN_CREATEPROMPT		= 8192
privatewrite CONSTANT long OFN_SHAREAWARE			= 16384
privatewrite CONSTANT long OFN_NOREADONLYRETURN		= 32768
privatewrite CONSTANT long OFN_NOTESTFILECREATE		= 65536
privatewrite CONSTANT long OFN_NONETWORKBUTTON		= 131072
privatewrite CONSTANT long OFN_NOLONGNAMES		= 262144
privatewrite CONSTANT long OFN_EXPLORER			= 524288
privatewrite CONSTANT long OFN_NODEREFERENCELINKS	= 1048576
privatewrite CONSTANT long OFN_LONGNAMES			= 2097152

privatewrite string is_encoding=''

end variables

forward prototypes
public function boolean of_getopenname (readonly window w, readonly string title, ref string path, ref string as_files[], readonly string ext, string filter, ref long filterindex)
public function boolean of_getopenname (readonly window w, readonly string title, ref string path, readonly string ext, string filter, ref long filterindex)
public function boolean of_readtext (readonly string filename, ref string text, integer encoding)
private function encoding of_getencoding (ref blob b, long len)
private function encoding of_cutbom (ref blob b, encoding e)
public function boolean of_getsavename (readonly window w, readonly string title, ref string path, readonly string ext, string filter, ref long filterindex)
public function boolean of_writetext (readonly string filename, readonly string text, encoding e)
public function boolean of_writetext (readonly string filename, readonly string text, string se)
end prototypes

public function boolean of_getopenname (readonly window w, readonly string title, ref string path, ref string as_files[], readonly string ext, string filter, ref long filterindex);//returns the id of the selected filter
//-1 on error

T_OPENFILENAME OpenFileName
long MAXFILENAME=10000
long ll_pos, ll_index
uint ch=0
string s
string lsa_files[]

OpenFileName.lStructSize	= 76
OpenFileName.hWndOwner		= Handle(w)
OpenFileName.hInstance		= 0
filter+=',,'
OpenFileName.lpstrFilter	= blob(filter)
//replace coma by zero-char
ll_pos=0
do while true
	ll_pos = pos(Filter,',',ll_pos+1)
	if ll_pos<1 then exit
	blobedit(OpenFileName.lpstrFilter,1+(ll_pos - 1)*2,ch)
loop

OpenFileName.lpstrCustomFilter	= 0
OpenFileName.nMaxCustomFilter		= 0
OpenFileName.nFilterIndex 			= FilterIndex
OpenFileName.lpstrFile           = blob(space(MAXFILENAME+2))//+2 for zero-chars
blobedit(OpenFileName.lpstrFile,1,path)
//add two zero-chars (unicode); one long it's two zero chars
blobedit(OpenFileName.lpstrFile,1+len(path)*2,long(0))

OpenFileName.nMaxFile				= MAXFILENAME
OpenFileName.lpstrFileTitle		= 0
OpenFileName.nMaxFileTitle			= 0
OpenFileName.lpstrInitialDir		= 0
OpenFileName.lpstrTitle				= title

OpenFileName.Flags					= OFN_EXPLORER+OFN_FILEMUSTEXIST+OFN_HIDEREADONLY

if upperbound(as_files)=0 then
	OpenFileName.Flags+=OFN_ALLOWMULTISELECT
elseif as_files[1]<>'SINGLE' then
	OpenFileName.Flags+=OFN_ALLOWMULTISELECT
end if

OpenFileName.nFileOffSet			= 0
OpenFileName.nFileExtension		= 0
OpenFileName.lpstrDefExt			= ext
OpenFileName.lCustData				= 0
OpenFileName.lpfnHook				= 0
OpenFileName.lpTemplateName		= 0


If GetOpenFileName(OpenFileName)<>0 Then // Pressed OK button
	path=string(OpenFileName.lpstrFile)
	FilterIndex=OpenFileName.nFilterIndex
	ll_index=0
	
	OpenFileName.lpstrFile=blobmid(OpenFileName.lpstrFile,(len(path)+1)*2+1)
	do
		s=string(OpenFileName.lpstrFile)
		if s='' then exit
		ll_index++
		lsa_files[ll_index]=s
		OpenFileName.lpstrFile=blobmid(OpenFileName.lpstrFile,(len(s)+1)*2+1)
	loop while true
	
	as_files=lsa_files
	return true
end if

return false

end function

public function boolean of_getopenname (readonly window w, readonly string title, ref string path, readonly string ext, string filter, ref long filterindex);string lsa_files[]
lsa_files={'SINGLE'}
return of_getopenname(w,title,path,lsa_files,ext,filter,filterindex)

end function

public function boolean of_readtext (readonly string filename, ref string text, integer encoding);//encoding:
//2: ansi
//3: utf8
//4: utf16
//else: autodetect
int f
blob b
long byteLen
encoding e

text=''

f=FileOpen( filename, StreamMode!, Read!, Shared!)
if f<>-1 then
	byteLen=FileReadEx(f,b)
	FileClose(f)
else
	f_error("Can't open file ~r~n~""+filename+'"')
	return false
end if

choose case encoding
	case 2
		e=EncodingANSI!
	case 3
		e=EncodingUTF8!
	case 4
		e=EncodingUTF16LE!
	case else
		e=of_getencoding(b,bytelen)
end choose

choose case e
	case EncodingANSI!
		is_encoding='ANSI'
	case EncodingUTF8!
		is_encoding='UTF8'
	case EncodingUTF16LE!
		is_encoding='UTF16'
	case Encodingutf16BE!
		is_encoding='UTF16be'
	case else
		is_encoding='?'
end choose

text=gn_unicode.of_blob2string(b,e)

return true

end function

private function encoding of_getencoding (ref blob b, long len);long i,count,byte


//zero length/ whatever
if len=0 then
	if cfg.ib_encoding_default_uft8 then return EncodingUTF8!
	return EncodingANSI!
end if

//if any zero byte met before the end of the byte stream then consider it utf16
if lstrlenA(b)<len then 
	byte=0
	RtlMoveMemory( byte, b, 2)
	if byte=65279 then return of_cutbom(b,EncodingUTF16LE!) //a bom for unicode file
	if byte=65534 then return of_cutbom(b,EncodingUTF16BE!) //a bom for unicode file
	return EncodingUTF16LE!
end if

if len=2 then
	byte=0
	RtlMoveMemory( byte, b, 2)
	if byte=65279 then return of_cutbom(b,EncodingUTF16LE!) //a bom for unicode file
	if byte=65534 then return of_cutbom(b,EncodingUTF16BE!) //a bom for unicode file
end if

//check if it's real utf8
if gn_unicode.of_isLegalUTF8(b, len, cfg.ib_encoding_default_uft8) then return EncodingUTF8!

//i=MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, b, len, 0/*lpWStr*/, 0/*cchWStr*/)
//if i>0 then return EncodingUTF8!

return EncodingANSI!

end function

private function encoding of_cutbom (ref blob b, encoding e);choose case e
	case EncodingUTF16LE!,EncodingUTF16BE!
		b=BlobMid(b,3)
	case EncodingUTF8!,EncodingUTF8!
		b=BlobMid(b,4)
end choose
return e

end function

public function boolean of_getsavename (readonly window w, readonly string title, ref string path, readonly string ext, string filter, ref long filterindex);//returns the id of the selected filter
//-1 on error

T_OPENFILENAME OpenFileName
long MAXFILENAME=10000
long i,count
uint ch=0
string s


OpenFileName.lStructSize	= 76
OpenFileName.hWndOwner		= Handle(w)
OpenFileName.hInstance		= 0
filter+=',,'
OpenFileName.lpstrFilter	= blob(filter)
//replace coma by zero-char
count=len(Filter)
for i=1 to count
	//unicode!!!
	if mid(Filter,i,1)=',' then blobedit(OpenFileName.lpstrFilter,1+(i - 1)*2,ch)
next

OpenFileName.lpstrCustomFilter	= 0
OpenFileName.nMaxCustomFilter		= 0
OpenFileName.nFilterIndex 			= FilterIndex
OpenFileName.lpstrFile           = blob(space(MAXFILENAME+2))//+2 for zero-chars
blobedit(OpenFileName.lpstrFile,1,path)
//add two zero-chars (unicode); one long it's two zero chars
blobedit(OpenFileName.lpstrFile,1+len(path)*2,long(0))

OpenFileName.nMaxFile				= MAXFILENAME
OpenFileName.lpstrFileTitle		= 0
OpenFileName.nMaxFileTitle			= 0
OpenFileName.lpstrInitialDir		= 0
OpenFileName.lpstrTitle				= title

OpenFileName.Flags					= OFN_EXPLORER+OFN_FILEMUSTEXIST+OFN_HIDEREADONLY+OFN_OVERWRITEPROMPT
OpenFileName.nFileOffSet			= 0
OpenFileName.nFileExtension		= 0
OpenFileName.lpstrDefExt			= ext
OpenFileName.lCustData				= 0
OpenFileName.lpfnHook				= 0
OpenFileName.lpTemplateName		= 0


If GetSaveFileName(OpenFileName)<>0 Then // Pressed OK button
	path=string(OpenFileName.lpstrFile)
	FilterIndex=OpenFileName.nFilterIndex
	return true
end if

return false

end function

public function boolean of_writetext (readonly string filename, readonly string text, encoding e);int f
long i
blob b

if e=EncodingANSI! then
	//for ansi use winapi convert, because PB uses system instead of user conversation
	f=FileOpen(filename, StreamMode!, Write!, LockWrite!, Replace!)
elseif e=EncodingUTF8! then
	//for utf8 avoid adding BOM!
	//required by isql???
	f=FileOpen(filename, StreamMode!, Write!, LockWrite!, Replace!)
else
	f=FileOpen(filename, TextMode!, Write!, LockWrite!, Replace!,e)
end if

if f=-1 then 
	f_error("Can't create the file~r~n~""+filename+'"')
	return false
end if


if e=EncodingANSI! then
	i=gn_unicode.of_string2mb( /*boolean ab_utf8*/ false, text, b)
	i=len(text)
	
	i=FileWriteEx(f, b ,i)
elseif e=EncodingUTF8! then
	//for utf8 avoid adding BOM!
	//required by isql???
	i=FileWriteEx(f, blob(text,EncodingUTF8!) )
else
	i=FileWriteEx(f, text)
end if


FileClose(f)

return true

end function

public function boolean of_writetext (readonly string filename, readonly string text, string se);encoding e
choose case lower(se)
	case 'ansi'
		e=EncodingANSI!
	case 'utf16'
		e=EncodingUTF16LE!
	case 'utf16be'
		e=EncodingUTF16BE!
	case else
		e=EncodingUTF8!
end choose

return this.of_writetext( filename, text, e)

end function

on n_file.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_file.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on


