HA$PBExportHeader$uo_resultset_text.sru
forward
global type uo_resultset_text from uo_resultset
end type
type uo_edit from uo_scintilla within uo_resultset_text
end type
type in_data from n_hashtable within uo_resultset_text
end type
end forward

shared variables
n_sci_style_rstext sn_style

end variables

global type uo_resultset_text from uo_resultset
boolean ib_multi_resultsets = true
uo_edit uo_edit
in_data in_data
end type
global uo_resultset_text uo_resultset_text

type variables
long marker_inf=1
long marker_err=2

end variables

forward prototypes
public function string of_formatcolumn (long al_col, readonly string as_text)
public subroutine of_style_line (long line, long al_style)
public subroutine of_appendln (integer count)
end prototypes

public function string of_formatcolumn (long al_col, readonly string as_text);long ll_posr, ll_posn, ll_post
string ls_text
boolean lb_altertext=false
//in_rsinfo[il_rscount].il_rowcount

ll_posr=pos(as_text,'~r')
ll_posn=pos(as_text,'~n')
ll_post=pos(as_text,'~t')

if ll_posr>0 or ll_posn>0 then
	ls_text=f_replaceall(as_text,'~r',' ')
	ls_text=f_replaceall(ls_text,'~n',' ')
	ls_text=f_replaceall(ls_text,'~t',' ')
	ls_text=f_replaceall(ls_text,'  ',' ')
	ls_text=f_replaceall(ls_text,'  ',' ')
	
	if len(ls_text)>cfg.il_resultset_text_maxchar then ls_text=left(ls_text,cfg.il_resultset_text_maxchar )
	lb_altertext=true
else
	if len(as_text)>cfg.il_resultset_text_maxchar then 
		ls_text=left(as_text,cfg.il_resultset_text_maxchar )
		lb_altertext=true
	end if
end if

if lb_altertext then
	//store original text in the in_data hash
	//.....
	//and return value
	return ls_text+space(in_rsinfo[il_rscount].it_col[al_col].displaylen - len(ls_text))+'~t'
end if


return as_text+space(in_rsinfo[il_rscount].it_col[al_col].displaylen - len(as_text))+'~t'

end function

public subroutine of_style_line (long line, long al_style);long ii_s,ii_l

if line=-1 then line=uo_edit.of_send(uo_edit.SCI_GETLINECOUNT,0,0)-1
ii_s=uo_edit.of_send(uo_edit.SCI_POSITIONFROMLINE,line,0)
ii_l=uo_edit.of_send(uo_edit.SCI_LINELENGTH,line,0)

uo_edit.of_send(uo_edit.SCI_STARTSTYLING,  ii_s, 31)
uo_edit.of_send(uo_edit.SCI_SETSTYLING,    ii_l, al_style)

end subroutine

public subroutine of_appendln (integer count);uo_edit.of_appendtext(fill('~r~n',count*2))

end subroutine

on uo_resultset_text.create
int iCurrent
call super::create
this.uo_edit=create uo_edit
this.in_data=create in_data
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_edit
end on

on uo_resultset_text.destroy
call super::destroy
destroy(this.uo_edit)
destroy(this.in_data)
end on

event constructor;call super::constructor;this.iwo_result=uo_edit
of_updateview()


end event

event ue_resultset_begin;call super::ue_resultset_begin;long li_i

if il_rscount>1 then uo_edit.of_appendtext('~r~n~r~n')

for li_i=1 to in_rsinfo[il_rscount].il_colcount
	uo_edit.of_appendtext( of_formatcolumn(li_i,in_rsinfo[il_rscount].it_col[li_i].name))
next
this.of_style_line( -1, 1)
uo_edit.of_appendtext( "~r~n" )
for li_i=1 to in_rsinfo[il_rscount].il_colcount
	uo_edit.of_appendtext( of_formatcolumn(li_i,in_rsinfo[il_rscount].it_col[li_i].sqltype ))
next
uo_edit.of_appendtext( "~r~n" )
for li_i=1 to in_rsinfo[il_rscount].il_colcount
	uo_edit.of_appendtext( fill('-',in_rsinfo[il_rscount].it_col[li_i].displaylen)+'~t' )
next
uo_edit.of_appendtext( "~r~n" )

end event

event ue_setfield;call super::ue_setfield;if isNull(as_value) then 
	uo_edit.of_appendtext(of_formatcolumn(al_col,'NULL'))
else
	uo_edit.of_appendtext(of_formatcolumn(al_col,as_value))
end if

end event

event ue_resultset_end;call super::ue_resultset_end;uo_edit.of_appendtext('resultset end')

end event

event ue_init;call super::ue_init;sn_style.of_colorize(uo_edit)

end event

event ue_row_end;call super::ue_row_end;uo_edit.of_appendtext('~r~n')

end event

event ue_message;call super::ue_message;long line

if len(as_number)>0 then
	uo_edit.of_appendtext( as_time+' ['+right('     '+as_number,6)+'] '+as_object+': '+as_message )
else
	uo_edit.of_appendtext( as_time+' '+as_object+': '+as_message )
end if

if ai_level>0 then
	line=uo_edit.of_send(uo_edit.SCI_GETLINECOUNT,0,0)-1
	uo_edit.of_send(uo_edit.SCI_MARKERADD,line, ai_level)
	this.of_style_line( -1, 1+ai_level )
else
	this.of_style_line( -1, 2 )
end if

this.of_appendln(1)

end event

type mle_1 from uo_resultset`mle_1 within uo_resultset_text
end type

type uo_edit from uo_scintilla within uo_resultset_text
integer y = 328
integer taborder = 40
boolean bringtotop = true
end type

on uo_edit.destroy
call uo_scintilla::destroy
end on

event constructor;call super::constructor;//information marker
of_send(SCI_MARKERDEFINE,marker_inf, SC_MARK_CIRCLE)
of_send(SCI_MARKERSETBACK,marker_inf,rgb(128,255,255))
//error marker
of_send(SCI_MARKERDEFINE,marker_err, SC_MARK_CIRCLE)
of_send(SCI_MARKERSETBACK,marker_err,rgb(255,0,0))

//set readonly
//of_send(SCI_SETREADONLY,1,0)

//don't collect undo information
of_send(SCI_SETUNDOCOLLECTION,0,0)

//set margin for log elements
uo_edit.of_send(uo_edit.SCI_SETMARGINWIDTHN,1   ,11)

end event

type in_data from n_hashtable within uo_resultset_text descriptor "pb_nvo" = "true" 
end type

on in_data.create
call super::create
end on

on in_data.destroy
call super::destroy
end on

