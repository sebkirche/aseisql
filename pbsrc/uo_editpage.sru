HA$PBExportHeader$uo_editpage.sru
forward
global type uo_editpage from uo_tabpage
end type
type uo_edit from uo_scintilla within uo_editpage
end type
type win32_file_attribute_data from structure within uo_editpage
end type
type in_timerac from timing within uo_editpage
end type
end forward

type win32_file_attribute_data from structure
	long		dwattr
	long		timec1
	long		timec2
	long		timea1
	long		timea2
	long		timew1
	long		timew2
	long		nsize1
	long		nsize2
end type

shared variables

end variables

global type uo_editpage from uo_tabpage
integer width = 1280
integer height = 956
string text = "Query"
string picturename = "query5!"
event resize pbm_size
event scn_updateui ( )
event ue_sqlexec_end ( long al_errcount )
event scn_dwellchar ( )
uo_edit uo_edit
in_timerac in_timerac
end type
global uo_editpage uo_editpage

type prototypes
//private function long GetSysColor(long index)library "user32"
protected function boolean CopyAsRTF(long SciWnd,long _styledef[],int stylecount)library 'SciLexer.dll'

private function boolean GetFileAttributesEx(string lpFileName,long fInfoLevelId, ref  win32_file_attribute_data lpFileInformation)library 'Kernel32.dll' alias for 'GetFileAttributesExW'

end prototypes

type variables
private string is_filepath=''
private string is_extension=''

public privatewrite string is_wordchars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_@"

privatewrite long styledef[]
private win32_file_attribute_data it_fileattr

//variables to identify object
string is_obj_database
string is_obj_owner
string is_obj_name
long il_clone=0
privatewrite string is_object_footer='null'
privatewrite string is_object_header='null'

privatewrite long il_italic=33554432
privatewrite long il_bold  =16777216
public string is_fontface
public int ii_fontsize
public int ii_tabspace

privatewrite string stylename[]={&
	"Default",&
	"Comment",&
	"Line Comment",&
	"Number",&
	"Keyword",&
	"String 1",&
	"String 2",&
	"Operators",&
	"Identifiers",&
	"Brace Light",&
	"Brace Bad",&
	"Background",&
	"Select FG",&
	"Select BG"&
}
privatewrite long stylemap[]={&
	0 ,&
	1 ,&
	2 ,&
	3 ,&
	4 ,&
	5 ,&
	6 ,&
	7 ,&
	8 ,&
	34,&
	35,&
	-1,&
	-2,&
	-3 &
}

privatewrite long il_stylecount=14
protectedwrite boolean ib_enable_context_menu=true
public boolean ib_show_indent
public boolean ib_show_fold
public boolean ib_show_linenum

privatewrite long marker_mark=0
privatewrite long marker_stop=1
privatewrite long marker_where=2

//hotlink is a underlined text whel controll is pressed and mouse hover
//-1 if none underlined
long il_hotlink_start=-1  //this used as a flag for hotlink
long il_hotlink_len=-1
string is_hotlink_text=''

end variables

forward prototypes
public subroutine of_print ()
public subroutine of_setfocus ()
public function boolean of_copyrtf ()
public subroutine of_colorize ()
public function boolean of_equals (readonly string as_name)
public subroutine of_selectline (long line)
public subroutine of_updateview ()
public subroutine of_settext (readonly string as_text)
private function integer of_b2i (boolean b)
public function boolean of_save (boolean ab_prompt)
public function string of_getobjheader ()
public function boolean of_match ()
public function string of_gettext ()
public subroutine of_setbgcolor (readonly long c)
public function long of_getcolor (integer index)
public function boolean of_stylestore ()
public function boolean of_styleload (boolean ab_default)
public function long of_getselectedtext (ref string s)
public function boolean of_fileattr (boolean ab_check)
public subroutine of_dbg_updatestops ()
public function long of_getcorrectedline (long al_line)
public subroutine of_copyvarprint ()
public function boolean of_store ()
public function boolean of_changecase (readonly string as_mode)
public function boolean of_insertstub (readonly string as_word, boolean ab_exact)
public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back)
public subroutine of_setobjectfooter (readonly string s)
public function string of_getobjfooter (boolean ab_addgo)
public function boolean of_open (string fname, long encoding)
public subroutine of_replaceselected (readonly string as_text)
public subroutine of_setobjectheader (readonly string s)
end prototypes

event resize;this.uo_edit.resize(newwidth,newheight)

end event

event ue_sqlexec_end(long al_errcount);if al_errcount=0 then
	CHOOSE CASE il_pagetype
		CASE typeEditObject
			CHOOSE CASE il_objtype
				CASE gn_sqlmenu.typeProcedure,gn_sqlmenu.typeTrigger,gn_sqlmenu.typeView
					uo_edit.of_send(uo_edit.SCI_SETSAVEPOINT,0,0)
			END CHOOSE
	END CHOOSE
end if

end event

event scn_dwellchar();//

end event

public subroutine of_print ();uo_edit.of_print(w_main,true)

end subroutine

public subroutine of_setfocus ();uo_edit.setFocus()

end subroutine

public function boolean of_copyrtf ();return copyasrtf ( uo_edit.sci_hwnd, styledef, upperbound(styledef) )

end function

public subroutine of_colorize ();long i


if ii_fontsize<5 then ii_fontsize=5
if ii_fontsize>24 then ii_fontsize=24

//set the default style
uo_edit.of_send(uo_edit.SCI_STYLESETFORE  ,uo_edit.STYLE_DEFAULT, of_getcolor(1))
uo_edit.of_send(uo_edit.SCI_STYLESETBOLD  ,uo_edit.STYLE_DEFAULT, f_and(styledef[1],il_bold    ))
uo_edit.of_send(uo_edit.SCI_STYLESETITALIC,uo_edit.STYLE_DEFAULT, f_and(styledef[1],il_italic  ))
uo_edit.of_send(uo_edit.SCI_STYLESETFONT  ,uo_edit.STYLE_DEFAULT, this.is_fontface )
uo_edit.of_send(uo_edit.SCI_STYLESETSIZE  ,uo_edit.STYLE_DEFAULT, ii_fontsize)

for i=1 to il_stylecount
	if stylemap[i]>=0 then
		uo_edit.of_send(uo_edit.SCI_STYLESETFORE  ,stylemap[i], of_getcolor(i))
		uo_edit.of_send(uo_edit.SCI_STYLESETBOLD  ,stylemap[i], f_and(styledef[i],il_bold    ))
		uo_edit.of_send(uo_edit.SCI_STYLESETITALIC,stylemap[i], f_and(styledef[i],il_italic  ))
		uo_edit.of_send(uo_edit.SCI_STYLESETFONT,stylemap[i], this.is_fontface )
		uo_edit.of_send(uo_edit.SCI_STYLESETSIZE,stylemap[i], ii_fontsize)
	else
		choose case stylemap[i]
			case -1
				of_setbgcolor(of_getcolor(i))
			case -2
				uo_edit.of_send(uo_edit.SCI_SETSELFORE,1, of_getcolor(i))
			case -3
				uo_edit.of_send(uo_edit.SCI_SETSELBACK,1, of_getcolor(i))
			case else
				/*statementblock*/
		end choose

	end if
next
uo_edit.of_send( uo_edit.SCI_SETCARETFORE, of_getcolor(1), 0)

uo_edit.of_send(uo_edit.SCI_SETINDENTATIONGUIDES,of_b2i(ib_show_indent),0)
uo_edit.of_send(uo_edit.SCI_SETMARGINWIDTHN,0   ,of_b2i(ib_show_linenum)*32)
uo_edit.of_send(uo_edit.SCI_SETMARGINWIDTHN,2   ,of_b2i(ib_show_fold)*12)
uo_edit.of_send(uo_edit.SCI_SETTABWIDTH,ii_tabspace,0)

end subroutine

public function boolean of_equals (readonly string as_name);string db,u,n

gn_sqlmenu.of_parsename(as_name,db,u,n)

return is_obj_database=db and is_obj_owner=u and is_obj_name=n

end function

public subroutine of_selectline (long line);long p1,p2

if line<1 then return

if cfg.ib_debug_correctrow then line=this.of_getcorrectedline( line )

line -- //zero based line index

uo_edit.of_send(uo_edit.SCI_ENSUREVISIBLE,line,0)

p1=uo_edit.of_send(uo_edit.SCI_POSITIONFROMLINE,line,0)
p2=uo_edit.of_send(uo_edit.SCI_GETLINEENDPOSITION,line,0)
uo_edit.of_send(uo_edit.SCI_SETSEL,p2,p1)


end subroutine

public subroutine of_updateview ();of_styleload(false)

end subroutine

public subroutine of_settext (readonly string as_text);uo_edit.of_send(uo_edit.SCI_EMPTYUNDOBUFFER,0,0)
uo_edit.of_send(uo_edit.SCI_SETUNDOCOLLECTION,0,0)
uo_edit.of_send( uo_edit.SCI_SETTEXT,0, as_text)
uo_edit.of_send(uo_edit.SCI_CONVERTEOLS,uo_edit.SC_EOL_CRLF,0)
uo_edit.of_send(uo_edit.SCI_SETUNDOCOLLECTION,1,0)
uo_edit.of_send(uo_edit.SCI_SETSAVEPOINT,0,0)

end subroutine

private function integer of_b2i (boolean b);if b then return 1
return 0

end function

public function boolean of_save (boolean ab_prompt);string filename
n_file ln_file
//string ext='sql'
int f,i
long len,written,defChar
string s
long filterindex=1
string ls_encoding


filterindex=cfg.of_getlong( 'options', 'encoding.last', 1)
len=uo_edit.of_send(uo_edit.SCI_GETLENGTH,0,0)

if len=0 then return false

if is_filepath='' then
	is_extension='sql'  //default extension
	CHOOSE CASE il_pagetype
		CASE typeEditObject
			CHOOSE CASE il_objtype
				CASE gn_sqlmenu.typeProcedure
					is_extension='pro'
					if this.is_obj_owner<>'dbo' then is_filepath+=is_obj_owner+'.'
					is_filepath+=this.is_obj_name+'.'+is_extension
				CASE gn_sqlmenu.typeTrigger
					is_filepath=this.is_obj_name+'.'+is_extension
				CASE gn_sqlmenu.typeSFunction
					is_filepath=this.is_obj_name+'.'+is_extension
				CASE gn_sqlmenu.typeView
					is_filepath=this.is_obj_name+'.'+is_extension
			END CHOOSE
		CASE typeEditFile
			is_filepath=this.powertiptext
		CASE typeEdit
			is_filepath=this.text+'.'+is_extension
	END CHOOSE
end if

repeat:
if ab_prompt or il_pagetype<>typeEditFile then
	if not ln_file.of_getsavename( w_main,"Save SQL File", is_filepath, is_extension, "SQL Files (ANSI),*.sql;*.pro,SQL Files (UTF8),*.sql;*.pro,SQL Files (UTF16),*.sql;*.pro",filterindex) then return false
	
	cfg.of_setlong( 'options', 'encoding.last', filterindex)
	
	choose case filterindex
		case 1
			ls_encoding='ANSI'
		case 3
			ls_encoding='UTF16'
		case else
			ls_encoding='UTF8'
	end choose

else
	ls_encoding=this.is_encoding
	if not of_fileattr(true) then
		i=MessageBox(app().displayname, is_filepath+' was changed after open.~r~nDo you want to replace it?~r~nPress NO to open a file copy.',Exclamation!,YesNoCancel!)
		if i=2 then 
			w_main.of_openfile(is_filepath,true,0)
			return false
		end if
		if i=3 then return false
	end if
end if


s=space(len+1)
uo_edit.of_sendRef(uo_edit.SCI_GETTEXT,len+1, s)
s=f_converteol(of_getObjHeader()+s+of_getObjFooter(true))

if lower(ls_encoding)='ansi' then
	//check if no data will be lost during ansi conversation
	if not gn_unicode.of_hasonlyansi(s) then
		i=MessageBox(app().displayname, is_filepath+'~r~nThe file contains Unicode characters that could be lost if you save file as ANSI.~r~nTo keep Unicode information press Cancel, and select one of Unicode encodings.~r~nTo continue saving ANSI data, press Ok.~r~nContinue?',Exclamation!,OkCancel!)
		if i=2 then
			ab_prompt=true
			filterindex=2
			goto repeat
		end if
	end if
end if

if not ln_file.of_writetext(is_filepath,s,ls_encoding) then return false

if il_pagetype=typeEditFile then
	this.powertiptext=is_filepath
	this.text=f_getfilepart(is_filepath,6)
	this.is_encoding=ls_encoding
	uo_edit.of_send(uo_edit.SCI_SETSAVEPOINT,0,0)
	of_fileattr(false)
end if

if il_pagetype=typeEdit then
	w_main.of_openfile(is_filepath,false,0)
	this.of_settext('')
end if

return true

end function

public function string of_getobjheader ();if is_object_header='null' then
	is_object_header=gn_sqlmenu.of_getobjectheader( il_objtype, is_obj_database, is_obj_owner, is_obj_name)
end if

return is_object_header

end function

public function boolean of_match ();//returns true if contents of the page 
//is correct for this edit object type

string s
n_sqlparser p

if il_pagetype=this.typeeditobject then
	s=of_getText()
	p=create n_sqlparser
	choose case il_objtype
		case gn_sqlmenu.typeprocedure
			return p.of_match( s, "create proc") or p.of_match( s, "create procedure")
		case gn_sqlmenu.typetrigger
			return p.of_match( s, "create trigger")
		case gn_sqlmenu.typeview
			return p.of_match( s, "create view")
	end choose
	destroy p
end if

return true

end function

public function string of_gettext ();long len
string s

len=this.uo_edit.of_send(this.uo_edit.SCI_GETLENGTH,0,0)
if len=0 then return ''

s=space(len+1)
this.uo_edit.of_sendRef(this.uo_edit.SCI_GETTEXT,len+1, s)

return s

end function

public subroutine of_setbgcolor (readonly long c);int i

for i=1 to il_stylecount
	if stylemap[i]>=0 then uo_edit.of_send(uo_edit.SCI_STYLESETBACK,stylemap[i], c)
next
//uo_edit.of_send(uo_edit.SCI_SETWHITESPACEBACK,1,c)

uo_edit.of_send(uo_edit.SCI_STYLESETBACK,uo_edit.STYLE_DEFAULT, c)
end subroutine

public function long of_getcolor (integer index);if index<1 or index>il_stylecount then
	return 255
end if

choose case stylemap[index]
	case -1
		if styledef[index]=-1 then	return uo_edit.GetSysColor(5)//COLOR_WINDOW
	case -2
		if styledef[index]=-1 then	return uo_edit.GetSysColor(14)//COLOR_HIGHLIGHTTEXT
	case -3
		if styledef[index]=-1 then	return uo_edit.GetSysColor(13)//COLOR_HIGHLIGHT
end choose
return f_and(styledef[index],il_bold - 1)

end function

public function boolean of_stylestore ();long i

for i=1 to il_stylecount
	cfg.of_setstyle(i,styledef[i])
next
cfg.of_setstring( cfg.is_options, cfg.is_fontface , this.is_fontface )
cfg.of_setlong( cfg.is_options, cfg.is_fontsize , this.ii_fontsize )

cfg.of_setoption(cfg.is_showindent,ib_show_indent)
cfg.of_setoption(cfg.is_showlinenum,ib_show_linenum)
cfg.of_setoption(cfg.is_ShowFoldMargin,ib_show_fold)

cfg.of_setlong( cfg.is_options, 'tabspace' , this.ii_tabspace )

return true

end function

public function boolean of_styleload (boolean ab_default);int i
styledef[0 +1]=0						// default
styledef[1 +1]=8421504+il_italic	// Comment
styledef[2 +1]=8421504+il_italic	// Line Comment
styledef[3 +1]=rgb(0,128,128)		// Number
styledef[4 +1]=rgb(0,0,255)		// Keyword
styledef[5 +1]=rgb(0,128,128)		// Double quoted string
styledef[6 +1]=rgb(0,128,128)		// Single quoted string
styledef[7 +1]=32768					// Operators
styledef[8 +1]=rgb(90,0,90)			// Identifiers

styledef[9 +1]=rgb(128,0,128)+il_bold			// Brace Light
styledef[10+1]=rgb(220,0,0)+il_bold			   // Brace Bad
styledef[11+1]=-1					// BGColor
styledef[12+1]=-1					// Select Fore
styledef[13+1]=-1					// Select Back

ib_show_indent=false
ib_show_linenum=true
ib_show_fold=true
ii_tabspace=4

this.is_fontface="Courier New"
this.ii_fontsize=9

if not ab_default then
	for i=1 to il_stylecount
		styledef[i]=cfg.of_getstyle(i,styledef[i])
	next
	
	this.is_fontface=cfg.of_getstring( cfg.is_options, cfg.is_fontface , this.is_fontface )
	this.ii_fontsize=cfg.of_getlong( cfg.is_options, cfg.is_fontsize , this.ii_fontsize )
	
	ib_show_indent=cfg.of_getoption(cfg.is_showindent,ib_show_indent)
	ib_show_linenum=cfg.of_getoption(cfg.is_showlinenum,ib_show_linenum)
	ib_show_fold=cfg.of_getoption(cfg.is_ShowFoldMargin,ib_show_fold)
	
	this.ii_tabspace=cfg.of_getlong( cfg.is_options, 'tabspace' , this.ii_tabspace )
end if

of_colorize()
return true

end function

public function long of_getselectedtext (ref string s);long ls,le

ls=uo_edit.of_send(uo_edit.SCI_GETSELECTIONSTART,0,0)
le=uo_edit.of_send(uo_edit.SCI_GETSELECTIONEND,0,0)

if ls<>le then
	s=space(le -ls + 1)
	uo_edit.of_sendRef(uo_edit.SCI_GETSELTEXT,0, s)
	return le -ls + 1
end if

return 0

end function

public function boolean of_fileattr (boolean ab_check);win32_file_attribute_data lt_fileattr
boolean b

if ab_check then
	if is_filepath='' then return false
	if not GetFileAttributesEx(is_filepath,0, lt_fileattr) then return false
	if lt_fileattr.timeC1<>it_fileattr.timeC1 then return false
	if lt_fileattr.timeC2<>it_fileattr.timeC2 then return false
	if lt_fileattr.timeW1<>it_fileattr.timeW1 then return false
	if lt_fileattr.timeW2<>it_fileattr.timeW2 then return false
	if lt_fileattr.nsize1<>it_fileattr.nsize1 then return false
	if lt_fileattr.nsize2<>it_fileattr.nsize2 then return false
	
	return true
end if
b=GetFileAttributesEx(is_filepath,0, it_fileattr)
return b

end function

public subroutine of_dbg_updatestops ();long i,count,ll_line
string s

if this.il_objtype=gn_sqlmenu.typeprocedure or this.il_objtype=gn_sqlmenu.typetrigger then
	//delete all breakpoints
	uo_edit.of_send( uo_edit.SCI_MARKERDELETEALL,marker_stop,0)
	uo_edit.of_send( uo_edit.SCI_MARKERDELETEALL,marker_where,0)
	//
	if sqlca.of_isconnected( ) and sqlca.il_dbg_spid>0 then
		//breakpoints
		count=w_browser.tab_1.page_dbg.lv_stop.totalitems()
		for i=1 to count
			w_browser.tab_1.page_dbg.lv_stop.GetItem ( i, 1, s )
			if of_equals(s) then
				w_browser.tab_1.page_dbg.lv_stop.GetItem ( i, 2, s )
				uo_edit.of_send( uo_edit.SCI_MARKERADD,long(s)-1 /*start from 0*/, marker_stop)
			end if
		next
		//where
		if of_equals(w_browser.tab_1.page_dbg.is_where_obj) then
			ll_line=w_browser.tab_1.page_dbg.il_where_line
			if cfg.ib_debug_correctrow then ll_line=this.of_getcorrectedline( ll_line )
			uo_edit.of_send( uo_edit.SCI_MARKERADD,ll_line -1, marker_where)
		end if
	end if
end if

end subroutine

public function long of_getcorrectedline (long al_line);long ll_line=1 //line how sybase count them 1-based
long ll_rline=0 //real line, 0-based for scintilla, on return must be +1
long ll_style
long pos,pos0
char c
int status // 0=def, 1=l, 2=l, 3=u, 4=n, 5=not a keywordchar

do while ll_line<al_line
	ll_line++ //increase line num, but if null found it will be decreased
	pos0=uo_edit.of_send(uo_edit.SCI_POSITIONFROMLINE,ll_rline,0)
	pos=uo_edit.of_send(uo_edit.SCI_GETLINEENDPOSITION,ll_rline,0)
	if pos - pos0>=4 then
		//skip spaces
		do
			pos --
			c=char(uo_edit.of_send(uo_edit.SCI_GETCHARAT,pos,0))
		loop while pos>=pos0 and (c=' ' or c='~t')
		status=0
		do while pos>pos0
			c=char(uo_edit.of_send(uo_edit.SCI_GETCHARAT,pos,0))
			ll_style=uo_edit.of_send(uo_edit.SCI_GETSTYLEAT,pos,0)
			choose case true
				case status=0 and (c='l' or c='L') and ll_style=4
					status=1
				case status=1 and (c='l' or c='L') and ll_style=4
					status=2
				case status=2 and (c='u' or c='U') and ll_style=4
					status=3
				case status=3 and (c='n' or c='N') and ll_style=4
					status=4
				case status=4 and ll_style<>4
					//null keyword. decrease number of lines
					ll_line --
					exit
				case else
					//not a null keyword
					exit
			end choose
			pos --
		loop
	end if
	ll_rline ++
loop

return ll_rline+1


//SCI_GETSTYLEAT(int pos)
//SCI_LINEFROMPOSITION(int position)
//SCI_GETLINEENDPOSITION(int line)

//SCI_WORDENDPOSITION(int position, bool onlyWordCharacters)
//SCI_WORDSTARTPOSITION(int position, bool onlyWordCharacters)

//SCI_GETLINECOUNT


//SCI_GETTEXTRANGE(<unused>, TextRange *tr)
//struct CharacterRange {
//    long cpMin;
//    long cpMax;
//};
//
//struct TextRange {
//    struct CharacterRange chrg;
//    char *lpstrText;
//};




return 0

end function

public subroutine of_copyvarprint ();long ll_style
int status //0 def, 1 variable, 2 - variable end
long pos,pose
char c
string var,s1,s2
int count

pos=uo_edit.of_send(uo_edit.SCI_GETSELECTIONSTART,0,0)
pose=uo_edit.of_send(uo_edit.SCI_GETSELECTIONEND,0,0)

uo_edit.of_send(uo_edit.SCI_COLOURISE,0,pose) //colorize all

if pos<pose then
	s1="print '>>>> "
	
	do while pos<=pose
		c=char(uo_edit.of_send(uo_edit.SCI_GETCHARAT,pos,0))
		ll_style=uo_edit.of_send(uo_edit.SCI_GETSTYLEAT,pos,0)
		choose case status
			case 0
				if ll_style=8 then //variable
					var=''+c
					status=1
				end if
			case 1
				if ll_style<>8 then
					status=2
				else
					var+=''+c
					if pos=pose then status=2
				end if
		end choose
		if status=2 then
			status=0
			if pos(s1,var+'=')<1 then
				count++
				if count>1 then s1+=','
				s1+=' '+var+'=%'+string(count)+'!'
				s2+=', '+var
			end if
		end if
		
		pos ++
	loop
	if count>0 then
		clipboard(s1+"'"+s2+'~r~n')
	end if
	
end if

end subroutine

public function boolean of_store ();//this stores the file/object to the file/database
//all other cases returns false

choose case this.il_pagetype
	case this.typeEditFile
		if not of_save(false) then return false
	case this.typeEditObject
		choose case this.il_objtype
			case gn_sqlmenu.typeProcedure,gn_sqlmenu.typeTrigger,gn_sqlmenu.typeView
				if not w_main.of_execute(this,'',false) then return false
				
				if w_main.il_execerror>0 then return false
			case else
				return false
		end choose
	case else
		return false
end choose
uo_edit.of_send(uo_edit.SCI_SETSAVEPOINT,0,0)
return true

end function

public function boolean of_changecase (readonly string as_mode);long pos, pose 
long i,posi
long ll_style,len
char c
string ls_old,ls_new,s
//
//mode: up,lo,ti,ku,kl
choose case as_mode
	case 'up','lo','ku','kl'//,'ti'
	case else
		return false
end choose

pos=uo_edit.of_send(uo_edit.SCI_GETSELECTIONSTART,0,0)
pose=uo_edit.of_send(uo_edit.SCI_GETSELECTIONEND,0,0)

//move position start and positionend to the word
if as_mode='ku' or as_mode='kl' or pos=pose then
	c=char(uo_edit.of_send(uo_edit.SCI_GETCHARAT,pos,0))
	if pos(is_wordchars,c)>0 then pos=uo_edit.of_send(uo_edit.SCI_WORDSTARTPOSITION,pos,1)
	c=char(uo_edit.of_send(uo_edit.SCI_GETCHARAT,pose,0))
	if pos(is_wordchars,c)>0 then pose=uo_edit.of_send(uo_edit.SCI_WORDENDPOSITION,pose,1)
end if

uo_edit.of_send(uo_edit.SCI_COLOURISE,0,-1) //colorize all

uo_edit.of_send(uo_edit.SCI_SETSEL,pos,pose)

if this.of_getselectedtext(ls_old)>0 then
	if as_mode='up' then 
		ls_new=upper(ls_old)
	elseif as_mode='lo' then
		ls_new=lower(ls_old)
	else
		//we will go through all the chars and check the style of each one
		//the style located not by chars but by UTF8 bytes :(
		//so let's do some tricks
		len=len(ls_old)
		posi=pos
		for i=1 to len
			s=mid(ls_old,i,1)
			ll_style=uo_edit.of_send(uo_edit.SCI_GETSTYLEAT,posi,0)
			if ll_style=4 then 
				if as_mode='ku' then
					ls_new+=upper(s)
				else
					ls_new+=lower(s)
				end if
			else
				ls_new+=s
			end if
			//position in utf8 bytes to retrieve style
			posi+=gn_unicode.of_getuft8len(s)
		next
	end if
	uo_edit.of_send(uo_edit.SCI_BEGINUNDOACTION,0,0)
	of_replaceselected(ls_new)
	uo_edit.of_send(uo_edit.SCI_ENDUNDOACTION,0,0)
	uo_edit.of_send(uo_edit.SCI_SETSEL,pos,pose)
end if


return true

end function

public function boolean of_insertstub (readonly string as_word, boolean ab_exact);string s,indent,tip
int i
long ls,le,pos

i=w_browser.tab_1.page_st.of_getlist(as_word,s,ab_exact)
if i=0 then
	w_main.setmicrohelp('No stub found for "'+as_word+'"')
	return false
end if
if i=1 then
	le=uo_edit.of_send(uo_edit.SCI_GETSELECTIONSTART,0,0)
	ls=uo_edit.of_send(uo_edit.SCI_LINEFROMPOSITION,le,0)
	ls=uo_edit.of_send(uo_edit.SCI_POSITIONFROMLINE,ls,0)
	pos=ls
	do while pos<=le
		choose case uo_edit.of_send(uo_edit.SCI_GETCHARAT,pos,0)
			case 32
				indent+=' '
			case 9
				indent+='~t'
			case else
				exit
		end choose
		pos++
	loop
	s=gn_sqlmenu.of_macro( s, true ,indent)
	
	//try to cut off the lastcomment /**/
	pos=pos(s,'*/')
	if trim(mid(s,pos+2))='' then
		pos=pos(s,'/*')
		if pos>0 then
			i=pos
			do while i>0 
				pos=i
				i=pos(s,'/*',pos+1)
			loop
			tip=trim(mid(s,pos+2))
			tip=left(tip,len(tip)-2)
			s=left(s,pos -1)
		end if
	end if
	
	uo_edit.of_send( uo_edit.SCI_REPLACESEL,0, s)
	uo_edit.of_send( uo_edit.SCI_SETSEL,le+gn_sqlmenu.il_macro_selb, le+gn_sqlmenu.il_macro_sele)
	if tip>'' then uo_edit.of_send( uo_edit.SCI_CALLTIPSHOW, le , tip)
else
	//expecting i=2
	if s>'' then uo_edit.of_send( uo_edit.SCI_USERLISTSHOW,1, s)
end if
return true

end function

public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back);long pos1,pos2,line
boolean ret

long SCFIND_WHOLEWORD,SCFIND_MATCHCASE,SCFIND_WORDSTART
long ll_parm

SCFIND_WHOLEWORD=2
SCFIND_MATCHCASE=4
SCFIND_WORDSTART=f_hex2long('0x00100000')

if find_case   then ll_parm+=SCFIND_MATCHCASE
if find_wword  then ll_parm+=SCFIND_WHOLEWORD
if find_wstart then ll_parm+=SCFIND_WORDSTART


if len(find_text)>0 then
	if find_back then
		pos1=uo_edit.of_send(uo_edit.SCI_GETSELECTIONSTART,0,0)-1
		pos2=0   //uo_edit.of_send(uo_edit.SCI_GETLENGTH,0,0)
	else
		pos1=uo_edit.of_send(uo_edit.SCI_GETCURRENTPOS,0,0)
		pos2=uo_edit.of_send(uo_edit.SCI_GETLENGTH,0,0)
	end if
	uo_edit.of_send(uo_edit.SCI_SETTARGETSTART,pos1,0)
	uo_edit.of_send(uo_edit.SCI_SETTARGETEND,pos2,0)
	uo_edit.of_send(uo_edit.SCI_SETSEARCHFLAGS,ll_parm,0)
	pos1=uo_edit.of_send(uo_edit.SCI_SEARCHINTARGET,len(find_text), find_text)
	if pos1=-1 then
		ret=false
	else
		line=uo_edit.of_send(uo_edit.SCI_LINEFROMPOSITION,pos1,0)
		uo_edit.of_send(uo_edit.SCI_ENSUREVISIBLE,line,0)
		uo_edit.of_send(uo_edit.SCI_SETSEL,pos1,pos1+len(find_text))
		ret=true
	end if
end if

return ret

end function

public subroutine of_setobjectfooter (readonly string s);is_object_footer=s

end subroutine

public function string of_getobjfooter (boolean ab_addgo);string s

if is_object_footer='null' then 
	is_object_footer=gn_sqlmenu.of_getobjectfooter( this.is_obj_owner+'.'+this.is_obj_name )
end if

if ab_addgo and is_object_footer<>'' then return '~r~ngo~r~n'+is_object_footer+'~r~ngo~r~n'
return is_object_footer

end function

public function boolean of_open (string fname, long encoding);n_file f
//int f
string s

if left(fname,1)='"' and right(fname,1)='"' then fname=mid(fname,2,len(fname) -2)

if not f.of_readtext(fname,s,encoding) then return false
this.is_encoding=f.is_encoding
this.is_filepath=fname
this.of_fileattr(false)
this.of_settext(s)

return true

end function

public subroutine of_replaceselected (readonly string as_text);uo_edit.of_send(uo_edit.SCI_REPLACESEL,0,as_text)
uo_edit.of_send(uo_edit.SCI_SETUNDOCOLLECTION,0,0)
uo_edit.of_send(uo_edit.SCI_CONVERTEOLS,uo_edit.SC_EOL_CRLF,0)
uo_edit.of_send(uo_edit.SCI_SETUNDOCOLLECTION,1,0)

end subroutine

public subroutine of_setobjectheader (readonly string s);is_object_header=s

end subroutine

on uo_editpage.create
int iCurrent
call super::create
this.uo_edit=create uo_edit
this.in_timerac=create in_timerac
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_edit
end on

on uo_editpage.destroy
call super::destroy
destroy(this.uo_edit)
destroy(this.in_timerac)
end on

event ue_selected;call super::ue_selected;
if uo_edit.of_send( uo_edit.SCI_GETMODIFY , 0, 0)<>0 then
	w_statusbar.f_settext('change','*')
else
end if
of_dbg_updatestops()


end event

event ue_closeprompt;call super::ue_closeprompt;string s
int i

if uo_edit.of_send( uo_edit.SCI_GETMODIFY , 0, 0)<>0 then
	choose case this.il_pagetype
		case this.typeEditFile
			s='Do you want to save the changes you made to file~r~n'+this.powertiptext
		case this.typeEditObject
			choose case this.il_objtype
				case gn_sqlmenu.typeProcedure,gn_sqlmenu.typeTrigger,gn_sqlmenu.typeView
					s='Do you want to save the changes you made to database~r~n'+this.is_obj_name
			end choose
		case else
	end choose
end if

if len(s)>0 then
	s+=' ?'
	i=MessageBox(app().displayname, s, Exclamation!, YesNoCancel!)
	if i=3 then return false
	if i=2 then return true
	if not of_store() then return false
end if

return true

end event

event ue_init;call super::ue_init;if this.il_pagetype=this.typeeditobject then
	//force retrieving object header and footer on object init
	of_getobjfooter(false)
	of_getobjheader()
else
	//initialize header and footer with
	is_object_footer=''
	is_object_header=''
end if

end event

type uo_edit from uo_scintilla within uo_editpage
integer taborder = 10
end type

on uo_edit.destroy
call uo_scintilla::destroy
end on

event constructor;call super::constructor;string bad_ctrlchars="QWERTIPDFGHJKLBNMU"
//long bgcolor=16777215
//long selectback=0
//long selectfore=0
string xpm

of_send(SCI_SETLEXER,7,0)
of_send(SCI_SETSCROLLWIDTH,-1,0)
of_send(SCI_SETPRINTCOLOURMODE,3,0)
of_send(SCI_USEPOPUP,0,0)
//of_send(SCI_SETHSCROLLBAR,1,0)

of_send(SCI_SETKEYWORDS,0, gn_sqlmenu.is_keywords)

//remove ctrl+char keys
do while len(bad_ctrlchars)>0
	of_send(SCI_CLEARCMDKEY,ASC(bad_ctrlchars)+SCMOD_CTRL*65536,0)
	bad_ctrlchars=mid(bad_ctrlchars,2)
loop
//of_send(SCI_ASSIGNCMDKEY,ASC('Y')+SCMOD_CTRL*65536,SCI_REDO)

of_styleload(false)

//of_send(SCI_SETTABWIDTH,4,0)
of_send(SCI_SETTABINDENTS,1,0)
//of_send(SCI_SETUSETABS,0,0)

of_send(SCI_SETMARGINWIDTHN,1, 0)
of_send(SCI_SETMARGINWIDTHN,2, 0)

of_send(SCI_SETWORDCHARS,0,is_wordchars)

//-----------------OPTIONS---------------------
//marker markers
of_send(SCI_MARKERDEFINE,marker_mark, SC_MARK_BACKGROUND)//SC_MARK_CIRCLE)
of_send(SCI_MARKERSETBACK,marker_mark,rgb(240,166,166))
//debugger markers
of_send(SCI_MARKERDEFINE,marker_stop, SC_MARK_CIRCLE)
of_send(SCI_MARKERSETBACK,marker_stop,rgb(255,0,0))

of_send(SCI_MARKERDEFINE,marker_where, SC_MARK_SHORTARROW)
of_send(SCI_MARKERSETBACK,marker_where,rgb(255,255,0))
//set space for debugger markers //maybe we should not display it all the time?
uo_edit.of_send(uo_edit.SCI_SETMARGINWIDTHN,1   ,11)

of_updateView()

of_send(SCI_SETMARGINLEFT, 0,0)
//of_send(SCI_SETPROPERTY,'fold', '1')
of_send(SCI_SETFOLDFLAGS,16,0)
//for debug folding
//of_send(SCI_SETFOLDFLAGS,16+64,0)

of_send(SCI_SETFOLDMARGINCOLOUR,1, GetSysColor(15) /*COLOR_BTNFACE*/)
of_send(SCI_SETFOLDMARGINHICOLOUR,1, GetSysColor(15) /*COLOR_BTNFACE*/)

of_DefineMarker(SC_MARKNUM_FOLDEROPEN, SC_MARK_BOXMINUS, rgb(255, 255, 255), rgb(128, 128, 128));
of_DefineMarker(SC_MARKNUM_FOLDER, SC_MARK_BOXPLUS, rgb(255, 255, 255), rgb(128, 128, 128));
of_DefineMarker(SC_MARKNUM_FOLDERSUB, SC_MARK_VLINE, rgb(255, 255, 255), rgb(128, 128, 128));
of_DefineMarker(SC_MARKNUM_FOLDERTAIL, SC_MARK_LCORNER, rgb(255, 255, 255), rgb(128, 128, 128));
of_DefineMarker(SC_MARKNUM_FOLDEREND, SC_MARK_BOXPLUSCONNECTED, rgb(255, 255, 255), rgb(128, 128, 128));
of_DefineMarker(SC_MARKNUM_FOLDEROPENMID, SC_MARK_BOXMINUSCONNECTED, rgb(255, 255, 255), rgb(128, 128, 128));
of_DefineMarker(SC_MARKNUM_FOLDERMIDTAIL, SC_MARK_TCORNER, rgb(255, 255, 255), rgb(128, 128, 128));


//activate FOLDERS
of_send(SCI_SETMARGINMASKN, 2, SC_MASK_FOLDERS);
of_send(SCI_SETMARGINSENSITIVEN, 2, 1);

//activate mouse dwell
of_send(SCI_SETMOUSEDWELLTIME,300,0)
of_send(SCI_INDICSETFORE,0, 16711680)
of_send(SCI_INDICSETSTYLE,0, INDIC_PLAIN)

//autocomplete
of_send(SCI_AUTOCSETIGNORECASE,1/*ignoreCase*/,0)
//of_sendref(SCI_AUTOCSETFILLUPS,0 /*<unused>*/,' .[]{}()*~t!@#$%^&')
of_send(SCI_AUTOCSETSEPARATOR,asc('~t'),0)
xpm='/* XPM */&
static char *fold[] = {&
/* width height num_colors chars_per_pixel */&
"    16    16       16            1",&
/* colors */&
"` c #000000",&
". c #800000",&
"# c #008000",&
"a c #808000",&
"b c #000080",&
"c c #800080",&
"d c #008080",&
"e c #808080",&
"f c None",&
"g c #ff0000",&
"h c #00ff00",&
"i c #ffff00",&
"j c #0000ff",&
"k c #ff00ff",&
"l c #00ffff",&
"m c #ffffff",&
/* pixels */&
"ffffffffffffffff",&
"ffffffffffffffff",&
"fff`````ffffffff",&
"ff`mmmmm`fffffff",&
"ff````````````ff",&
"ff`mimimimimi`ff",&
"ff`imimimimim`ff",&
"ff`mimimimimi`ff",&
"ff`imimimimim`ff",&
"ff`mimimimimi`ff",&
"ff`imimimimim`ff",&
"ff`mimimimimi`ff",&
"ff`imimimimim`ff",&
"ff````````````ff",&
"ffffffffffffffff",&
"ffffffffffffffff"&
};&
'
of_send(SCI_REGISTERIMAGE,0, xpm)
xpm='/* XPM */&
static char *stub[] = {&
/* width height num_colors chars_per_pixel */&
"    16    16       16            1",&
/* colors */&
"` c #000000",&
". c #800000",&
"# c #008000",&
"a c #808000",&
"b c #000080",&
"c c #800080",&
"d c #008080",&
"e c #808080",&
"f c None",&
"g c #ff0000",&
"h c #00ff00",&
"i c #ffff00",&
"j c #0000ff",&
"k c #ff00ff",&
"l c #00ffff",&
"m c #ffffff",&
/* pixels */&
"ffffffffffffffff",&
"f`````````ffffff",&
"f`mmmmmmm`ffffff",&
"f`mgggggm``````f",&
"f`mmmmmmm`mmmm`f",&
"f`meemeem`gggm`f",&
"f`mmmmmmm`mmmm`f",&
"f`meeeeem`meem`f",&
"f`mmmmmmm`mmmm`f",&
"f`meemeem`eeem`f",&
"f`mmmmmmm`mmmm`f",&
"f`````````meem`f",&
"ffffff`mmmmmmm`f",&
"ffffff`````````f",&
"ffffffffffffffff",&
"ffffffffffffffff"&
};&
'
of_send(SCI_REGISTERIMAGE,1, xpm)

end event

event contextmenu;call super::contextmenu;long ll_selstart, ll_selend
string ls_text
m_pop_edit lm_edit
menu lm_sql

if not ib_enable_context_menu then return

lm_edit=create m_pop_edit
lm_sql=create menu

lm_edit.uo_edit=this
//disable edit menu
lm_edit.m_undo.enabled=( this.of_send(this.SCI_CANUNDO,0,0) <>0 )
lm_edit.m_redo.enabled=( this.of_send(this.SCI_CANREDO,0,0) <>0 )
lm_edit.m_paste.enabled=( this.of_send(this.SCI_CANPASTE,0,0) <>0 )

ll_selstart=this.of_send(this.SCI_GETSELECTIONSTART,0,0)
ll_selend=this.of_send(this.SCI_GETSELECTIONEND,0,0)

lm_edit.m_cut.enabled=( ll_selstart <> ll_selend )
lm_edit.m_copy.enabled=lm_edit.m_cut.enabled
lm_edit.m_copyspecial.m_copyrtf.enabled=lm_edit.m_cut.enabled
lm_edit.m_copyspecial.m_copyvarprint.enabled=lm_edit.m_cut.enabled
lm_edit.m_copyspecial.enabled=lm_edit.m_cut.enabled
lm_edit.m_delete.enabled=lm_edit.m_cut.enabled
lm_edit.m_findselected.enabled=( ll_selend - ll_selstart > 0 and ll_selend - ll_selstart <251 )

//append browser menu
lm_sql.text='SQL'
lm_edit.item[upperbound(lm_edit.item)+1]=lm_sql
lm_sql.enabled=false
if sqlca.dbHandle()<>0 and not sqlca.ib_executing then
	if ll_selstart <> ll_selend  then
		
		ls_text=space(ll_selend - ll_selstart + 1)
		uo_edit.of_sendRef(uo_edit.SCI_GETSELTEXT,0, ls_text)
		
		if gn_sqlmenu.of_generatemenu(lm_sql,ls_text) then
			lm_sql.enabled=true
		end if
	end if
end if

if xpos<0 and ypos<0 then
	xpos=this.of_send(this.SCI_POINTXFROMPOSITION,0, ll_selstart)
	
	ypos=this.of_send(this.SCI_POINTYFROMPOSITION,0, ll_selend)
	ypos+=this.of_send(this.SCI_TEXTHEIGHT,0,0)
	
	xpos=pixelstounits(xpos,xpixelstounits!)+w_main.pointerx() - this.pointerx()
	ypos=pixelstounits(ypos,ypixelstounits!)+w_main.pointery() - this.pointery()
	
	
else
	xpos=w_main.PointerX()
	ypos=w_main.PointerY()
end if

//show menu
lm_edit.PopMenu(xpos,ypos)


gn_sqlmenu.of_freemenu(lm_sql)

destroy lm_edit
destroy lm_sql

end event

event scn_charadded;call super::scn_charadded;long pos
long line
long len
long i
string s
string c
boolean begin=false

if ch=13 then
	pos=this.of_send( this.SCI_GETCURRENTPOS, 0, 0)
	line=this.of_send( this.SCI_LINEFROMPOSITION,pos,0)
	line --
	len=this.of_send( this.SCI_LINELENGTH, line, 0)
	s=space(len)
	if this.of_sendref( this.SCI_GETLINE, line, s)>0 then
		for i=len to 1 step -1
			c=mid(s,i,1)
			if pos(' ~t~r~n',c)<1 then
				if match( lower( mid(s,i - 5, 6) ), '^[^0-9a-z_]begin$') then begin=true
				exit
			end if
		next
		
		for i=1 to len
			c=mid(s,i,1)
			if c<>' ' and c<>'~t' then
				s=left(s,i - 1)
				exit
			end if
		next
		if begin then s+='~t'
		if len(s)>0 then this.of_send( SCI_REPLACESEL, 0, s)
	end if
end if

in_timerac.stop()
if pos( parent.is_wordchars , char(ch) )>0 then
	pos=this.of_send( this.SCI_GETCURRENTPOS, 0, 0)
	i=this.of_send( this.SCI_WORDSTARTPOSITION,pos, 1 /*true*/)
	if pos - i > 1 then
		in_timerac.start(1) //1 sec delay
	end if
end if

end event

event scn_updateui;call super::scn_updateui;long pos1,pos2

w_main.of_showpos(parent)
//brace highlight
pos1=this.of_send(SCI_GETCURRENTPOS,0,0)
if pos('()', Char(this.of_send(SCI_GETCHARAT,pos1,0)))>0 then
	pos2=this.of_send(SCI_BRACEMATCH,pos1, 0)
	if pos2>=0 then 
		this.of_send(SCI_BRACEHIGHLIGHT,pos1,pos2)
	else
		this.of_send(SCI_BRACEBADLIGHT,pos1,0)
	end if
else
	this.of_send(SCI_BRACEHIGHLIGHT,-1,-1)
end if
parent.triggerevent('scn_updateui')
//this.of_send(SCI_CALLTIPCANCEL,0,0)

end event

event scn_savepoint;call super::scn_savepoint;//parent.event scn_savepoint(b)
m_main m
m=w_main.menuid

if b then
	w_statusbar.f_settext('change','')
	m.m_file.m_save.enabled=false
else
	w_statusbar.f_settext('change','*')
	m.m_file.m_save.enabled=true
end if

end event

event scn_userlistselection;call super::scn_userlistselection;of_insertstub(s,true)

//messageBox(s,listtype)

end event

event scn_lbuttondown;call super::scn_lbuttondown;long pos
int li_type
if parent.il_hotlink_start<>-1 then
	if sqlca.of_isconnected( ) and not sqlca.ib_executing  then
		li_type=gn_sqlmenu.of_getobjtypei(is_hotlink_text)
		if w_main.of_canopenobject(li_type) then
			w_main.post of_openobject(is_hotlink_text,0,false)
		else
			w_main.setMicrohelp('Not supported. Only stored procedures, functions, views, and triggers are supported for now.')
		end if
	end if
	//MessageBox('',is_hotlink_text)
end if

end event

event scn_ctrlhover;call super::scn_ctrlhover;long poss=-1, pose,count,ll_styleend
//string ls_type
int li_type
int li_style


//remove old highlight
if il_hotlink_start<>-1 then
	of_send(SCI_STARTSTYLING, il_hotlink_start, INDICS_MASK)
	of_send(SCI_SETSTYLING, il_hotlink_len, 0)
	
	il_hotlink_start=-1
	il_hotlink_len=0
end if

if pos<>-1 and sqlca.of_isconnected( ) and not sqlca.ib_executing then
	poss=pos
	pose=pos+len
	ll_styleend=of_send(SCI_GETENDSTYLED,0,0)
	if ll_styleend<pose then return 
	
	li_style=of_send(SCI_GETSTYLEAT,poss,0)
	if li_style <> 0 then return
	do while poss>0 and of_send(SCI_GETCHARAT,poss - 1,0)=asc('.')
		count++
		if count>2 then exit
		poss=of_send(SCI_WORDSTARTPOSITION,poss -1,1)
		li_style=of_send(SCI_GETSTYLEAT,poss,0)
		if li_style <> 0 then return
	loop
	is_hotlink_text=of_gettextrange(poss,pose)
	
	il_hotlink_start=poss
	il_hotlink_len=pose - poss
	if pose=of_send(SCI_GETLENGTH,0,0) then il_hotlink_len --
	of_send(SCI_STARTSTYLING, il_hotlink_start, INDICS_MASK)
	of_send(SCI_SETSTYLING, il_hotlink_len, INDIC0_MASK)
end if

end event

type in_timerac from timing within uo_editpage descriptor "pb_nvo" = "true" 
end type

on in_timerac.create
call super::create
TriggerEvent( this, "constructor" )
end on

on in_timerac.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event timer;this.stop()
parent.triggerevent('scn_dwellchar')
end event

