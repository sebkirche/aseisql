HA$PBExportHeader$n_unicode.sru
forward
global type n_unicode from nonvisualobject
end type
end forward

global type n_unicode from nonvisualobject
end type
global n_unicode n_unicode

type prototypes
private function long GetACP() library 'kernel32'

//length of the ansi string
private function long lstrlenA(long lpString1)library "kernel32.dll" alias for "lstrlenA"

//convert multibyte to wide char
private function long MultiByteToWideChar(ulong CodePage, long dwFlags, long lpMBStr, long cchMB, ref string lpWStr, long cchWStr)library 'kernel32.dll' alias for 'MultiByteToWideChar'
private function long MultiByteToWideChar(ulong CodePage, long dwFlags, readonly blob lpMBStr, long cchMB, ref string lpWStr, long cchWStr)library 'kernel32.dll' alias for 'MultiByteToWideChar'

private function long WideCharToMultiByte(ulong CodePage,long dwFlags,readonly string lpWideCharStr,long cchWideChar,long mbstr,long cchMultiByte,long lpDefaultChar, ref long lpUsedDefaultChar)library 'kernel32.dll' alias for 'WideCharToMultiByte'

private function long WideCharToMultiByte(ulong CodePage,long dwFlags,readonly string lpWideCharStr,long cchWideChar,ref blob mbstr,long cchMultiByte,long lpDefaultChar, long lpUsedDefaultChar)library 'kernel32.dll' alias for 'WideCharToMultiByte'

private function long isLegalUTF8(ref blob lpMBStr, long cchMB,boolean defaultUTF8)library 'syb_exec.dll' alias for 'isLegalUTF8'

end prototypes

type variables
private long il_ansi_cp

end variables

forward prototypes
public function long of_mblong2string (boolean ab_utf8, readonly long al_address, ref string as_out)
public function boolean of_hasonlyansi (readonly string as)
public function long of_string2mb (boolean ab_utf8, readonly string src, ref blob dst)
private function long of_getmbcp (boolean ab_utf8)
public function boolean of_islegalutf8 (ref blob mb, readonly long mblen, readonly boolean default_utf8)
public function string of_blob2string (readonly blob b, encoding e)
public function long of_getuft8len (readonly string s)
public function long of_writestream (integer handle, encoding ae_encoding, readonly string src)
end prototypes

public function long of_mblong2string (boolean ab_utf8, readonly long al_address, ref string as_out);//converts multibyte address to string

long strlen


if al_address<>0 then 

	strlen=lstrlenA(al_address)
	if strlen>0 then
		//init buffer
		as_out=space(strlen)
		strlen=MultiByteToWideChar(this.of_getMbCp(ab_utf8), 0, al_address, strlen, as_out, strlen)
		return strlen
	end if
end if

//default behavior
as_out=""
return 0

end function

public function boolean of_hasonlyansi (readonly string as);//returns true if specified string has only ansi chars
long defChar=0

WideCharToMultiByte(of_getMbCP(false),1024 /*WC_NO_BEST_FIT_CHARS*/,as,-1, 0,0,0, defChar)

return defChar=0

end function

public function long of_string2mb (boolean ab_utf8, readonly string src, ref blob dst);//returns the length of the blob in bytes
long len
long cp

cp=of_getMbCP(ab_utf8)

len=WideCharToMultiByte( cp,0,src,-1, dst,0,0,0)
dst=blob(space(len+1),EncodingANSI!) //+1 because PB removes zerochar at the end of string :(
WideCharToMultiByte( cp,0,src,-1, dst,len+1,0,0)

return len

end function

private function long of_getmbcp (boolean ab_utf8);//returns multibyte charset for internal use for WidechartoMultibyte and vice-versa
long CP_ACP=0  //
long CP_UTF8=65001
long CP_THREAD_ACP=3


if ab_utf8 then return CP_UTF8
return il_ansi_cp
//return CP_THREAD_ACP

end function

public function boolean of_islegalutf8 (ref blob mb, readonly long mblen, readonly boolean default_utf8);long i
i=isLegalUTF8(mb,mblen,default_utf8)
return i<>0

end function

public function string of_blob2string (readonly blob b, encoding e);string s
long len

choose case e
	case encodingansi! 
		//because PB use system ansi codepage instead of user
		len=len(b)
		s=space(len)
		len=MultiByteToWideChar(of_getMbCP(false), 0, b, len, s, len)
	case encodingutf16be!,encodingutf16le!,encodingutf8! 
		s=string(b,e)
	case else
		f_error('encoding not supported')
end choose
return s

end function

public function long of_getuft8len (readonly string s);blob dst

return WideCharToMultiByte( of_getMbCP(true) , 0,s, -1, dst,0,0,0)-1

end function

public function long of_writestream (integer handle, encoding ae_encoding, readonly string src);//returns the number of bytes written into the file
//blob will not include the zero character
long len,slen
blob dst
long cp

choose case ae_encoding
	case encodingansi!
		cp=of_getMbCP(false)
		slen=len(src)
		len=WideCharToMultiByte( cp,0,src,slen, dst,0,0,0)
		dst=blob(space(len),EncodingANSI!)
		len=WideCharToMultiByte( cp,0,src,slen, dst,len,0,0)
		len=len(dst)
	case encodingutf8!
		cp=of_getMbCP(true)
		slen=len(src)
		len=WideCharToMultiByte( cp,0,src,slen, dst,0,0,0)
		dst=blob(space(len),EncodingANSI!)
		len=WideCharToMultiByte( cp,0,src,slen, dst,len,0,0)
		len=len(dst)
	case else
		dst=blob(src)
		len=len(dst)
end choose
return FileWrite(handle,dst)


end function

on n_unicode.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_unicode.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//messageBox(this.classname(),'constructor')
il_ansi_cp=getAcp()

end event

