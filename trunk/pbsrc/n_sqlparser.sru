HA$PBExportHeader$n_sqlparser.sru
forward
global type n_sqlparser from nonvisualobject
end type
type lexema from structure within n_sqlparser
end type
end forward

type lexema from structure
	string		text
	boolean		isstring
	character		delimiter
end type

global type n_sqlparser from nonvisualobject
end type
global n_sqlparser n_sqlparser

type variables
private string alphanum='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@_1234567890'

end variables

forward prototypes
private function boolean of_isspace (character c)
private function boolean of_isalphanum (character c)
private function boolean of_debug (readonly string msg)
public function boolean of_match (readonly string s, readonly string pattern)
private function long of_skipspace (readonly string text, long pos)
private function long of_posany (readonly string text, readonly string chars, long start)
private function long of_getlexema (readonly string text, long pos, ref lexema lexema, readonly string validchars)
private function long of_getlexemastring (readonly string text, long pos, character delimiter, ref lexema lexema)
public function long of_skipcommblock (readonly string text, long pos)
public function long of_findkeyword (readonly string text, string keyword, long pos)
public function long of_eol (readonly string text, long pos)
end prototypes

private function boolean of_isspace (character c);return pos(' ~t~r~n',c)>0

end function

private function boolean of_isalphanum (character c);//return ('a'<=c and c<='z') or ('A'<=c and c<='Z') or ('0'<=c and c<='9') or c='@' or c='_'
return pos(alphanum,c)>0

end function

private function boolean of_debug (readonly string msg);f_error(msg) 
return false

end function

public function boolean of_match (readonly string s, readonly string pattern);long i1=1,i2=1
lexema lex1,lex2

do 
	if lower(lex1.text)<>lower(lex2.text) then return false
	i1=of_getLexema(pattern,i1,lex1,'')
	i2=of_getLexema(s,i2,lex2,'')
loop while i1>0

return true

end function

private function long of_skipspace (readonly string text, long pos);//returns 0 if end of text found
long i
boolean found=true
char c

i=pos
do while found
	found=false
	c=mid(text,i,1)
	if of_isSpace(c) then
		found=true
		i++
	else
		//maybe we have a comment so skip it
		CHOOSE CASE c
			CASE '-'
				if mid(text,i+1,1)='-' then
					i=of_posAny(text,'~r~n',i)
					if i=0 then return 0 //end of text
					found=true
					i++
				end if
			CASE '/'
				if mid(text,i+1,1)='*' then
					i=of_skipcommblock(text,i)
					if i=0 then return 0 //end of text
					found=true
				end if
		END CHOOSE
	end if
loop
if i>len(text) then return 0
return i

end function

private function long of_posany (readonly string text, readonly string chars, long start);long i,l
l=len(text)
for i=start to l
	if pos(chars,mid(text,i,1))>0 then return i
next
return 0

end function

private function long of_getlexema (readonly string text, long pos, ref lexema lexema, readonly string validchars);//returns the length of lexema
char c
long i,len

len=len(text)
if pos>len then return 0

pos=of_skipspace(text,pos)
i=pos
if i<1 then return 0

c=mid(text,i,1)
if c='"' or c="'" then return of_getLexemaString(text,i,c,lexema)

if not of_isAlphanum(c) and pos(validchars,c)<1 then
	lexema.isString=false
	lexema.text=''
	lexema.delimiter=char(text)
	i++
else
	do while i<=len
		c=mid(text,i,1)
		if not of_isAlphanum(c) and pos(validchars,c)<1 then exit
		i++
	loop
	lexema.isString=false
	lexema.text=mid(text,pos,i -pos)
	lexema.delimiter=mid(text,i,1)
end if

return i

end function

private function long of_getlexemastring (readonly string text, long pos, character delimiter, ref lexema lexema);long i

i=pos(text,delimiter,pos+1)
if i<1 then 
	lexema.text=mid(text,pos+1)
	lexema.delimiter=delimiter
	lexema.isString=true
	return 0
end if

lexema.text=mid(text,pos+1,i - pos - 1)
lexema.delimiter=delimiter
lexema.isString=true

return i+1

end function

public function long of_skipcommblock (readonly string text, long pos);long pos1, pos2
//check if it's not a comment block
if mid(text,pos,2)<>'/*' then return pos

label:

pos1=pos(text,'*/',pos+2) //find close comment
pos2=pos(text,'/*',pos+2) //find open comment (could be nested)

choose case true
	case pos1<1
		//not found close comment
		return 0
	case pos1>0 and pos2<1 
		//found close comment
		return pos1+2
	case pos1>0 and pos2>0 and pos1<pos2 
		//found close comment
		return pos1+2
	case pos1>0 and pos2>0 and pos1>pos2 
		pos=of_skipcommblock(text,pos2)
		if pos=0 then return 0
		goto label
	case else
		signalerror(0,'wrong case for '+this.classname())
end choose
return 0

end function

public function long of_findkeyword (readonly string text, string keyword, long pos);string word
string ch
long len,i
long status=0 //0:def (space), 1:word
long lenkw
string lowertext

long posS1,posS2,posCL,posCB,posKW

len=len(text)
lenkw=len(keyword)
keyword=lower(keyword)
lowertext=lower(text)

i=pos

do while i<=len and i>0
	posS1=pos(text,'~'',i)
	posS2=pos(text,'"',i)
	posCL=pos(text,'--',i)
	posCB=pos(text,'/*',i)
	posKW=pos(lowertext,keyword,i)
	
	if posS1<1 then posS1=len+1
	if posS2<1 then posS2=len+1
	if posCL<1 then posCL=len+1
	if posCB<1 then posCB=len+1
	if posKW<1 then posKW=len+1
	
	i=min(min(min(min(posS1,posS2),posCL),posCB),posKW)
	
	choose case i
		case posS1
			i=pos(text,'~'',i+1) //find endstr
			if i>0 then i++
		case posS2
			i=pos(text,'"',i+1) //find endstr
			if i>0 then i++
		case posCL
			i=of_eol(text,i+1)
			if i>0 then i++
		case posCB
			i=of_skipcommblock(text,i)
		case posKW
			if i=1 or pos(' ~r~n~t()~'";',mid(text,i -1,1))>0 then
				if i+lenkw>len or pos(' ~r~n~t()~'";',mid(text,i+lenkw,1))>0 then
					return i
				end if
			end if
			i+=len(keyword)
	end choose
loop

return 0

end function

public function long of_eol (readonly string text, long pos);long pos1,pos2
pos1=pos(text,'~r',pos)
pos2=pos(text,'~n',pos)

if pos1<1 then pos1=pos2
if pos1<1 then return 0
return min(pos1,pos2)

end function

on n_sqlparser.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sqlparser.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

