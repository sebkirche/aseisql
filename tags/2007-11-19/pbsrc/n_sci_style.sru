HA$PBExportHeader$n_sci_style.sru
forward
global type n_sci_style from nonvisualobject
end type
end forward

global type n_sci_style from nonvisualobject autoinstantiate
event ue_init ( )
event ue_colorize ( )
end type

type prototypes
private function long GetSysColor(long index)library "user32"
protected function boolean CopyAsRTF(long SciWnd,long _styledef[],int stylecount)library 'SciLexer.dll'

end prototypes

type variables
privatewrite long il_italic=33554432
privatewrite long il_bold  =16777216

privatewrite long styledef[]

protectedwrite string is_cfg_section //must be set on init
protectedwrite string is_fontface='Courier New' //must be set on init
protectedwrite int    ii_fontsize=9 //must be set on init
protectedwrite int    ii_tabspace

//use of_define
privatewrite string stylename[] 
privatewrite long stylemap[]
privatewrite long il_stylecount=0

end variables

forward prototypes
protected subroutine of_define (readonly long map, readonly string name, readonly long color, readonly boolean bold, readonly boolean italic)
public subroutine of_colorize (readonly uo_scintilla uo_edit)
private subroutine of_setbgcolor (readonly uo_scintilla uo_edit, long c)
protected function long of_getcolor (integer index)
end prototypes

event ue_init();//
this.is_cfg_section='options'

end event

event ue_colorize();//add your specific coloring here

end event

protected subroutine of_define (readonly long map, readonly string name, readonly long color, readonly boolean bold, readonly boolean italic);il_stylecount++

stylename[il_stylecount]=name
stylemap[il_stylecount]=map
styledef[il_stylecount]=color
if bold then styledef[il_stylecount]+=il_bold
if italic then styledef[il_stylecount]+=il_italic

return

end subroutine

public subroutine of_colorize (readonly uo_scintilla uo_edit);long i

if il_stylecount=0 then this.event ue_init()

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
				of_setbgcolor(uo_edit,of_getcolor(i))
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

uo_edit.of_send(uo_edit.SCI_SETTABWIDTH,ii_tabspace,0)

this.event ue_colorize( )

end subroutine

private subroutine of_setbgcolor (readonly uo_scintilla uo_edit, long c);int i

for i=1 to il_stylecount
	if stylemap[i]>=0 then uo_edit.of_send(uo_edit.SCI_STYLESETBACK,stylemap[i], c)
next
//uo_edit.of_send(uo_edit.SCI_SETWHITESPACEBACK,1,c)

uo_edit.of_send(uo_edit.SCI_STYLESETBACK,uo_edit.STYLE_DEFAULT, c)
end subroutine

protected function long of_getcolor (integer index);if index<1 or index>il_stylecount then
	return 255
end if

choose case stylemap[index]
	case -1
		if styledef[index]=-1 then	return this.GetSysColor(5)//COLOR_WINDOW
	case -2
		if styledef[index]=-1 then	return this.GetSysColor(14)//COLOR_HIGHLIGHTTEXT
	case -3
		if styledef[index]=-1 then	return this.GetSysColor(13)//COLOR_HIGHLIGHT
end choose
return f_and(styledef[index],il_bold - 1)

end function

on n_sci_style.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sci_style.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;this.event ue_init()

end event

