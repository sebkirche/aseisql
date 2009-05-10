HA$PBExportHeader$n_procparmparser.sru
forward
global type n_procparmparser from nonvisualobject
end type
type lexema from structure within n_procparmparser
end type
type parameter from structure within n_procparmparser
end type
end forward

type lexema from structure
	string		text
	boolean		isstring
	character		delimiter
end type

type parameter from structure
	string		name
	string		datatype
	string		value
	boolean		isout
	character		quote
end type

global type n_procparmparser from nonvisualobject
end type
global n_procparmparser n_procparmparser

type variables
private string buffer
private int status=0
private string procname
private parameter parm[]
private string alphanum='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@_1234567890'
public boolean ib_showerror=true
privatewrite boolean ib_haserror=false

end variables

forward prototypes
private function boolean of_getlexema (ref string text, ref lexema lexema)
private function integer of_posany (readonly string text, readonly string chars, long start)
public function long of_getparmcount ()
public function string of_getparmtype (long i)
public function string of_getparmvalue (long i)
public function boolean of_getparmout (long i)
private function boolean of_skipspace (ref string text)
private function boolean of_isspace (character c)
private function boolean of_isalphanum (character c)
public function string of_getparmname (long index)
private function boolean of_debug (readonly string msg)
public function long of_getparmindex (readonly string name)
public function long of_getparameters (readonly string nameofproc)
public function string of_tostring ()
private function boolean of_getlexemastring (ref string text, character delimiter, ref lexema lexema)
private function boolean of_getlexema (ref string text, ref lexema lexema, readonly string validchars)
public subroutine of_clear ()
private function boolean of_parse (readonly string text)
public function character of_getparmquote (long i)
end prototypes

private function boolean of_getlexema (ref string text, ref lexema lexema);return of_getLexema(text,lexema,'')

end function

private function integer of_posany (readonly string text, readonly string chars, long start);long i,l
l=len(text)
for i=start to l
	if pos(chars,mid(text,i,1))>0 then return i
next
return 0

end function

public function long of_getparmcount ();return upperbound(parm[])

end function

public function string of_getparmtype (long i);return parm[i].datatype

end function

public function string of_getparmvalue (long i);return parm[i].value

end function

public function boolean of_getparmout (long i);return parm[i].isOut

end function

private function boolean of_skipspace (ref string text);long i,l
boolean found=true

l=len(text)

do while found
	found=false
	for i=1 to l
		if not of_isSpace(mid(text,i,1)) then
			found=true
			exit
		end if
	next
	if not found then 
		text=''
		return true //need more text
	end if
	
	if i>1 then 
		text=mid(text,i)
		l=len(text)
	end if
	
	
	//maybe we have a comment so skip it
	
	found=false
	CHOOSE CASE mid(text,1,1)
		CASE '-'
			if l<2 then return true //need more
			if mid(text,2,1)='-' then
				i=of_posAny(text,'~r~n',3)
				if i=0 then return true //need more
				found=true
				text=mid(text,i)
				l=len(text)
			end if
		CASE '/'
			if l<2 then return true //need more
			if mid(text,2,1)='*' then
				i=pos(text,'*/',3)
				if i=0 then return true //need more
				found=true
				text=mid(text,i+2)
				l=len(text)
			end if
	END CHOOSE
loop

return false

end function

private function boolean of_isspace (character c);return pos(' ~t~r~n',c)>0

end function

private function boolean of_isalphanum (character c);//return ('a'<=c and c<='z') or ('A'<=c and c<='Z') or ('0'<=c and c<='9') or c='@' or c='_'
return pos(alphanum,c)>0

end function

public function string of_getparmname (long index);return parm[index].name

end function

private function boolean of_debug (readonly string msg);ib_haserror=true
if ib_showError then f_error(msg) 
return false

end function

public function long of_getparmindex (readonly string name);long i,l
l=upperbound(parm)
for i =1 to l
	if parm[i].name=name then return i
next
of_debug('Parameter '+name+' not found in procedure syntax:~r~n'+of_tostring())
return 0

end function

public function long of_getparameters (readonly string nameofproc);string query
string database=''
long dotpos,textlen
string text

of_clear()

dotpos=pos(nameofproc,'.')
if dotPos>0 and pos(nameofproc,'.',dotPos+1)>0 then database=mid(nameofproc,1,dotPos)+'.'//including dot-dot

query='SELECT text,char_length(text) FROM '+database+'syscomments WHERE id=object_id("'+nameofproc+'") ORDER BY colid2,colid'
//
DECLARE proc_text DYNAMIC CURSOR FOR SQLSA;
PREPARE SQLSA FROM :query;
OPEN DYNAMIC proc_text;
if sqlca.of_error() then return 0

FETCH proc_text INTO :text,:textlen;
do while sqlca.sqlcode=0
	text += space(textlen - len(text))
	if not of_parse(text) then exit
	FETCH proc_text INTO :text,:textlen;
loop
sqlca.of_error()
close proc_text;

return upperbound(parm)

end function

public function string of_tostring ();long i
string s
s=string(upperbound(parm))+' param$$HEX1$$3804$$ENDHEX$$tres dans '+procname+'~r~n'
for i=1 to upperbound(parm)
	s+=parm[i].name+'~t'+parm[i].datatype
	if parm[i].value<>'' then s+='='+parm[i].value
	if parm[i].isOut then s+='~tout'
	s+='~r~n'
next
return s


end function

private function boolean of_getlexemastring (ref string text, character delimiter, ref lexema lexema);long i

i=pos(text,delimiter,2)
if i<1 then return true//need more

lexema.text=mid(text,2,i -2)
lexema.delimiter=delimiter
lexema.isString=true

text=mid(text,i+1)
return false

end function

private function boolean of_getlexema (ref string text, ref lexema lexema, readonly string validchars);//returns true if we need next portion of the text
char c
long i,l

if of_skipspace(text) then return true
c=char(text)
if c='"' or c="'" then return of_getLexemaString(text,c,lexema)
l=len(text)
if not of_isAlphanum(char(text)) and pos(validchars,c)<1 then
	lexema.isString=false
	lexema.text=''
	lexema.delimiter=char(text)
	return false
else
	for i=1 to l
		c=mid(text,i,1)
		if not of_isAlphanum(c) and pos(validchars,c)<1 then goto found
	next
	return true
	found:
end if

lexema.isString=false
lexema.text=mid(text,1,i -1)
text=mid(text,i)
lexema.delimiter=char(text)
return false

end function

public subroutine of_clear ();parameter p[]

status=0
parm=p
buffer=''
procname=''

end subroutine

private function boolean of_parse (readonly string text);//returns true if need more text
lexema lex
buffer+=text

ib_haserror=false
do while true
	CHOOSE CASE status
		CASE 0
			if of_getLexema(buffer,lex) then return true
			if lower(lex.text)<>'create' then return of_debug("Syntax error: waiting for the keyword CREATE, received: "+upper(lex.text))
		CASE 1
			if of_getLexema(buffer,lex) then return true
			if lower(lex.text)<>'proc' and lower(lex.text)<>'procedure' then return of_debug("Syntax error: waiting for the keyword PROC[EDURE], received: "+upper(lex.text))
		CASE 2
			if of_getLexema(buffer,lex) then return true
			procname=lex.text
		CASE 3
			if of_skipSpace(buffer) then return true
			if char(buffer)='.' then
				buffer=mid(buffer,2)
				procname+='.'
			else
				status=4//next cycle +1
			end if
		CASE 4
			if of_getLexema(buffer,lex) then return true
			procname+=lex.text
		CASE 5 //waiting for ;
			if of_skipSpace(buffer) then return true
			if char(buffer)=';' then
				buffer=mid(buffer,2)
				procname+=';'
			else
				status=6
			end if
		CASE 6 //waiting for group number
			if of_getLexema(buffer,lex) then return true
			procname+=lex.text
		CASE 7 //parameters start (
			if of_skipSpace(buffer) then return true
			if char(buffer)='(' then
				buffer=mid(buffer,2)
			end if
		CASE 8 //parameter name
			if of_getLexema(buffer,lex) then return true
			if lower(lex.text)='as' then	return false //THE HAPPY END
			//add new parameter
			parm[UpperBound(parm)+1].name=lex.text
		CASE 9 //parameter type
			if of_getLexema(buffer,lex) then return true
			parm[UpperBound(parm)].datatype=lex.text
		CASE 10 //parameter type (
			if of_skipSpace(buffer) then return true
			if char(buffer)='(' then
				buffer=mid(buffer,2)
				parm[UpperBound(parm)].datatype+='('
			else
				status=14
			end if
		CASE 11 //parameter type (length
			if of_getLexema(buffer,lex) then return true
			parm[UpperBound(parm)].datatype+=lex.text
		CASE 12 //parameter type (_,
			if of_skipSpace(buffer) then return true
			if char(buffer)=',' then
				buffer=mid(buffer,2)
				parm[UpperBound(parm)].datatype+=','
			else
				status=13
			end if
		CASE 13 //parameter type (_,scale
			if of_getLexema(buffer,lex) then return true
			parm[UpperBound(parm)].datatype+=lex.text
		CASE 14 //parameter type (_,_)
			if of_skipSpace(buffer) then return true
			if char(buffer)=')' then
				buffer=mid(buffer,2)
				parm[UpperBound(parm)].datatype+=')'
			else
				return of_debug("Syntax error. Can't find closing bracket in:~r~n"+parm[UpperBound(parm)].name+' '+parm[UpperBound(parm)].datatype+' '+buffer)
			end if
		CASE 15 //parameter =
			if of_skipSpace(buffer) then return true
			if char(buffer)='=' then
				buffer=mid(buffer,2)
			else
				status=16 //no default value
			end if
		CASE 16 //parameter default value
			if of_getLexema(buffer,lex,'+-.') then return true //+-. for numbers
			parm[UpperBound(parm)].value=lex.text
//			if lex.isString then parm[UpperBound(parm)].value="'"+lex.text+"'"
			if lex.isString then 
				parm[UpperBound(parm)].quote=lex.delimiter
				parm[UpperBound(parm)].value=lex.delimiter+lex.text+lex.delimiter
			end if
		CASE 17 //output
			if of_getLexema(buffer,lex) then return true
			CHOOSE CASE lower(lex.text)
				CASE 'out','output'
					parm[UpperBound(parm)].isOut=true
				CASE ''
					parm[UpperBound(parm)].isOut=false
				CASE 'as'
					return false //THE HAPPY END
				CASE ELSE
					return of_debug('Syntax error: waiting for keyword OUT[PUT], received: '+lex.text)
			END CHOOSE
		CASE 18 //if , then next parameter - otherwise end
			if of_skipSpace(buffer) then return true
			if char(buffer)=',' then
				buffer=mid(buffer,2)
				status=7
			else
				return false //THE HAPPY END!!!
			end if
		CASE ELSE
			return of_debug("Unknown parser status: "+string(status))
	END CHOOSE
	status++
loop

end function

public function character of_getparmquote (long i);return parm[i].quote

end function

on n_procparmparser.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_procparmparser.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

