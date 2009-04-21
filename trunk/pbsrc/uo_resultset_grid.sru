HA$PBExportHeader$uo_resultset_grid.sru
forward
global type uo_resultset_grid from uo_resultset
end type
type dw_1 from datawindow within uo_resultset_grid
end type
type st_tip from uo_tooltip within uo_resultset_grid
end type
type phl_filter_d from picturehyperlink within uo_resultset_grid
end type
type t_rect from structure within uo_resultset_grid
end type
type thwnd2obj from structure within uo_resultset_grid
end type
type in_text_metrics from n_text_metrics within uo_resultset_grid
end type
end forward

type t_rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

shared variables

end variables

global type uo_resultset_grid from uo_resultset
integer width = 1175
integer height = 992
event ue_ctrl_c ( )
dw_1 dw_1
st_tip st_tip
phl_filter_d phl_filter_d
in_text_metrics in_text_metrics
end type
global uo_resultset_grid uo_resultset_grid

type prototypes
function boolean GetClientRect(long hWnd, ref t_rect r) library "user32.dll" alias for "GetClientRect"

end prototypes

type variables
long current_col=1
//int ii_colw[]

long il_dwwidth
end variables

forward prototypes
public subroutine of_setcolumn (long col)
public subroutine of_print ()
public subroutine of_setfocus ()
public function boolean of_movecell (integer direction)
public function boolean of_save (boolean ab_prompt)
public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back)
public subroutine of_showsql (boolean show)
end prototypes

event ue_ctrl_c();string s
s=dw_1.Describe("DataWindow.Selected.Data")
//MessageBox('',s)
clipboard(RightTrim ( s))

end event

public subroutine of_setcolumn (long col);//
current_col=col
t_rect r

dw_1.Modify("DataWindow.Selected='"+string(dw_1.getRow())+"/"+string(dw_1.getRow())+"/col_"+string(col)+"'")
//dw_1.Modify("colid.expression='"+string(col)+"'")
dw_1.setRedraw(true)


long ll_dwx,ll_dww
long ll_cx,ll_cw
long ll_pos

ll_dwx=long(dw_1.describe('datawindow.HorizontalScrollPosition'))
GetClientRect(handle(dw_1),r)
ll_dww=r.right - r.left

ll_pos=ll_dwx

ll_cx=long(dw_1.describe('#'+string(col)+'.x'))
ll_cw=long(dw_1.describe('#'+string(col)+'.width'))

if ll_cx+ll_cw>ll_dwx+ll_dww then ll_pos += (ll_cx+ll_cw) - (ll_dwx+ll_dww) + 1
if ll_cx < ll_pos then ll_pos = ll_cx - 2

dw_1.modify('datawindow.HorizontalScrollPosition="'+string(ll_pos)+'"')



end subroutine

public subroutine of_print ();if PrintSetup()<>1 then return
dw_1.print()

end subroutine

public subroutine of_setfocus ();dw_1.setFocus()

end subroutine

public function boolean of_movecell (integer direction);current_col=current_col+direction
if current_col<1 then current_col=1
if current_col>in_rsinfo[il_rscount].il_colcount then current_col=in_rsinfo[il_rscount].il_colcount

of_setcolumn(current_col)

return true

end function

public function boolean of_save (boolean ab_prompt);if dw_1.saveas()=1 then return true
return false

end function

public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back);long row,col,currow=1,curcol=1,rowcount,colcount
string ls,ls_text
long pos,textlen,direction=1
string ls_delim='~h01~h02~h03~h04~h05~h06~h07~h08~h09~h0A~h0B~h0C~h0D~h0E~h0F~r~n~t !"#$%&~'()*+,-./:;<=>?[\]^`{|}~~$$HEX15$$a000a400a600a700a900ab00ac00ad00ae00b000b100b500b600b700bb00$$ENDHEX$$'
///not working code

rowcount=dw_1.rowcount()
if rowcount=0 then return false
colcount=long(dw_1.describe('DataWindow.Column.Count'))
if colcount=0 then return false

if find_back then direction=-1

if find_case then
	ls_text=find_text
else
	ls_text=lower(find_text)
end if
textlen=len(ls_text)

n_dw_selection ln_sel

//take the first selection 
ln_sel=create n_dw_selection
if ln_sel.of_init(dw_1)>0 then
	currow=ln_sel.row_start
	curcol=long(dw_1.describe( ln_sel.column[1]+'.id' ))
end if
destroy ln_sel

//
col=curcol
do while col<=colcount and col>0
	row=currow+direction
	do while row<=rowcount and row>0
		ls=dw_1.getitemstring( row, col)
		if not find_case then ls=lower(ls)
		pos=pos(ls,ls_text)
		if pos>0 then
			if not find_wstart or pos=1 or pos(ls_delim,mid(ls_text,pos - 1,1))>0 then
				if not find_wword or ( (pos=1 or pos(ls_delim,mid(ls_text,pos - 1,1))>0) and (pos+textlen=len(ls)+1 or pos(ls_delim,mid(ls_text,pos+textlen,1))>0) ) then
					dw_1.scrolltorow(row)
					of_setcolumn(col)
					return true
				end if
			end if
		end if
		row+=direction
	loop
	
	currow=0 
	if find_back then currow=rowcount+1
	col+=direction
loop

return false

end function

public subroutine of_showsql (boolean show);super::of_showsql(show)
phl_filter_d.y=this.iwo_result.y+4

end subroutine

on uo_resultset_grid.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_tip=create st_tip
this.phl_filter_d=create phl_filter_d
this.in_text_metrics=create in_text_metrics
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_tip
this.Control[iCurrent+3]=this.phl_filter_d
end on

on uo_resultset_grid.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.st_tip)
destroy(this.phl_filter_d)
destroy(this.in_text_metrics)
end on

event constructor;call super::constructor;this.iwo_result=dw_1
of_updateview()

end event

event ue_resultset_begin;call super::ue_resultset_begin;string ls_work=''//,ls_work1=''    //work strings 
string ls_err                     //error string
string ls_syntax		             //string with DW syntax	
long li_i=0                      //counter
long li_x=2                   //coordinate of column
long li_width                  //width of column
long li_textheight

string hdr_text
long hdr_len
long pos

of_updateview()

in_text_metrics.of_setfont(cfg.is_resultset_font_name,cfg.il_resultset_font_size,false,false)

li_textheight=in_text_metrics.of_getTextH('W')
if in_rsinfo[il_rscount].is_name>'' then this.text=in_rsinfo[il_rscount].is_name

//Generates DW syntax string 
ls_syntax='release 7;~r~ndatawindow(units=1 timer_interval=0 color=1090519039 '+&
'processing=1 print.margin.bottom=24 print.margin.left=24 '+&
'print.margin.right=24 print.margin.top=24 print.preview.buttons=no '/*+'grid.columnmove=no '*/+&
')~r~ntable(~r~n'


//ls_work+='compute(band=detail alignment="0" expression="getrow()" border="0" color="33554432" x="5" y="4" height="64" width="219" format="[GENERAL]"  name=crow  font.face="Microsoft Sans Serif" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="204" background.mode="0" background.color="79741120" )~r~n'
//ls_work+='text(band=header alignment="2" text="<row no>" border="6" color="33554432" x="5" y="8" height="52" width="219"  name=crow_t  font.face="Microsoft Sans Serif" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="204" background.mode="1" background.color="536870912" )~r~n'

for li_i=1 to in_rsinfo[il_rscount].il_colcount
	hdr_text=in_rsinfo[il_rscount].it_col[li_i].name
	hdr_len=in_rsinfo[il_rscount].it_col[li_i].displaylen
	
	ls_syntax+=' column=(type=char('+string(hdr_len)+&
	') updatewhereclause = yes name=col_'+string(li_i)+'  dbname="'+hdr_text+'")~r~n'
	 
	//ls_work1=ls_work1+space(max_length[li_i])+"' as "+header_id[li_i]+", '"
	 
	//li_width=min(max(hdr_len,len(hdr_text))*5.9+2,UnitsToPixels(dw_1.width,XUnitsToPixels!) -40)
	li_width=min(in_text_metrics.of_gettextw(hdr_text)+10,UnitsToPixels(dw_1.width,XUnitsToPixels!) -40)
	in_rsinfo[il_rscount].it_col[li_i].maxpixels=li_width
	
	ls_work+='column(band=detail id='+string(li_i)+' x="'+&
	string(li_x)+'" y="1" height="'+string(li_textheight)+'" width="'+string(li_width)+'" edit.limit='+&
	string(hdr_len)+' alignment="0" font.face="'+cfg.is_resultset_font_name+'" '+&
	'font.height="-'+string(cfg.il_resultset_font_size)+'" font.weight="400" font.charset="0" font.pitch="2"'+&
	' font.family="2" font.underline="0" font.italic="0" border="0" color="0" '+&
	'background.mode="1" background.color="1090519039"  edit.autoselect=yes '+&
	'edit.autohscroll=yes edit.autovscroll=no edit.focusrectangle=no )~r~n'+&
	'text(band=header tag="'+in_rsinfo[il_rscount].it_col[li_i].sqltype+'" text="'+hdr_text+'" x="'+string(li_x)+&
	'" y="2" height="'+string(li_textheight +1)+'" width="'+string(li_width)+'" font.face="'+cfg.is_resultset_font_name+'"'+&
	' font.height="-'+string(cfg.il_resultset_font_size)+'" font.weight="400" font.charset="0" font.pitch="2"'+&
	' font.family="2" font.underline="0" font.italic="0" border="6"'+&
	' color="0" background.mode="1" background.color="67108864" alignment="2"  name='+&
	'col_'+string(li_i)+'_t )~r~n'
	
	li_x=li_x+li_width+2
	
next

li_textheight+=2

ls_syntax=ls_syntax+&
')~r~nheader(height='+string(li_textheight)+' color="67108864")~r~ndetail(height='+string(li_textheight)+')~r~nfooter(height='+string(li_textheight)+' color="79741120" )'+ls_work+&
' compute(band=footer alignment="0" expression="~'Rows ~'+string(currentrow())+~' of ~'+string(rowcount())" &
				border="0" color="0" x="2~t2" y="1" height="'+string(li_textheight -1)+'" width="212~t212" &
				font.face="'+cfg.is_resultset_font_name+'" font.height="-'+string(cfg.il_resultset_font_size)+'" font.weight="400" &
				font.family="2" font.pitch="2" font.charset="0" background.mode="2" &
				background.color="536870912" name=c_rowcount)~r~n'//+&
//'bitmap(band=foreground filename="img\filter_d.bmp" x="1" y="1" height="12" width="12" border="2"  name=p_1 pointer="Arrow!" visible="1" )~r~n'

//Creates a DW object using DW syntax string 
dw_1.Create(ls_syntax, ls_err)
if Len(ls_err) > 0 then
	f_error("Error creating datawindow from result set: " + ls_err)
	return
end if
dw_1.SetRowFocusIndicator(FocusRect!)
//in_layout.of_init(dw_1)
st_tip.of_settooltip(dw_1)

end event

event ue_setfield;call super::ue_setfield;int i

if isNull(as_value) then
	i=in_text_metrics.of_gettextw(is_nullvalue)+10
	if i - in_rsinfo[il_rscount].it_col[al_col].maxpixels > 9 then 
		in_rsinfo[il_rscount].it_col[al_col].maxpixels=i
		dw_1.modify('#'+string(al_col)+'.width='+string(i))
	end if
	dw_1.SetItem(in_rsinfo[il_rscount].il_rowcount,al_col,is_nullvalue)
else
	i=in_text_metrics.of_gettextw(as_value)+10
	if i - in_rsinfo[il_rscount].it_col[al_col].maxpixels > 9 then 
		in_rsinfo[il_rscount].it_col[al_col].maxpixels=i
		dw_1.modify('#'+string(al_col)+'.width='+string(i))
	end if
	dw_1.SetItem(in_rsinfo[il_rscount].il_rowcount,al_col,as_value)
end if

end event

event ue_newrow;call super::ue_newrow;dw_1.InsertRow( this.in_rsinfo[il_rscount].il_rowcount )

end event

type mle_1 from uo_resultset`mle_1 within uo_resultset_grid
end type

type dw_1 from datawindow within uo_resultset_grid
event ue_keydown pbm_dwnkey
event lbuttonup pbm_dwnlbuttonup
event lbuttondown pbm_lbuttondown
integer y = 332
integer width = 1033
integer height = 608
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;if key=KeyInsert! or key=KeyC! then
	if keyflags=2 then
		parent.post event ue_ctrl_c()
	end if
elseif key=keyRightArrow! then
	of_movecell(+1)
	return 1
elseif key=keyleftArrow! then
	of_movecell(-1)
	return 1
elseif key=keyHome! then
	of_setcolumn(1)
elseif key=keyEnd! then
	of_setcolumn(in_rsinfo[il_rscount].il_colcount)
//elseif key=keyEscape! then
//	this.SetFilter('')
//	this.filter()
elseif key=KeyEnter! then
	//MessageBox(col,row)
	if ib_displayonly then return 1
	open(w_view_data)
	w_view_data.of_set(this.getitemstring( getRow(), current_col ) )
	return 1
end if
return 0

end event

event lbuttonup;string s

s=dwo.name

if match(s,'^col_[0-9]+_t$') and KeyDown(KeyAlt!) then
	s=left(s,len(s)-2)
	this.setSort(s+' A')
	this.post sort()
end if

end event

event rbuttondown;if ib_displayonly then return 0

m_pop_rs m
menu mi
powerobject po
window w
long i
n_dw_selection ln_sel

po=parent

do while isvalid(po) and po.typeof()<>window!
	po=po.getParent()
loop
if isNull(po) then return
if not isValid(po) then return
w=po

ln_sel=create n_dw_selection
i=ln_sel.of_init(this)

if dwo.type='column' and row>0 then
	if i > 0 and ln_sel.of_contains(row,dwo.name) then
	else
		this.scrollToRow(row)
		this.Modify("DataWindow.Selected='"+string(row)+"/"+string(row)+"/"+dwo.name+"/"+dwo.name+"'")
		destroy ln_sel
		ln_sel=create n_dw_selection
		i=ln_sel.of_init(this)
	end if
end if	

m=create m_pop_rs

m.m_copy.enabled=i>0
m.m_copywithheaders.enabled=i>0
m.m_copyall.enabled=i>0

m.m_copycommadelimiteddata.enabled=i>0 and ln_sel.of_isonecolumn()

if il_pagetype=typeRsProcess and not sqlca.ib_executing then
	gn_sqlmenu.of_addstubsmenu( m, gn_sqlmenu.typeProcess , 'spid', getItemString(getRow(),1) )
end if

m.item[ upperbound(m.item)+1 ]=create menu
m.item[ upperbound(m.item) ].text='-'
m.item[ upperbound(m.item)+1 ]=create menu
m.item[ upperbound(m.item) ].text='SQL'

if ln_sel.of_iscell() then
	m.item[ upperbound(m.item) ].enabled=gn_sqlmenu.of_generatemenu(m.item[ upperbound(m.item) ],getItemString(ln_sel.row_start,ln_sel.column[1] ))
end if

m.idw=this
destroy ln_sel

m.popmenu(w.pointerx(),w.pointery())

destroy m

end event

event doubleclicked;if ib_displayonly then return 0

if dwo.type='column' and row>0 then
	open(w_view_data)
	w_view_data.of_set(this.getitemstring( row, string(dwo.name) ) )
end if


end event

event clicked;string s

//if in_layout.of_dwnclicked( xpos, ypos, row, dwo ) then return 0

if row>0 then this.scrollToRow(row)

if row>0 and row<=rowCount() then
	CHOOSE CASE dwo.type
		CASE 'column'
			current_col=long(dwo.id)
			if KeyDown(KeyAlt!) then
				s=getItemString(row,current_col)
				if isNull(s) then
					this.setFilter('isNull('+dwo.name+')')
				else
					this.setFilter(''+dwo.name+'="'+f_replaceall(s,'"','~~"')+'"')
				end if
				this.filter()
				phl_filter_d.visible=true
			end if
		CASE 'text'

	END CHOOSE

end if


end event

event rowfocuschanged;//
if not keyDown(KeyControl!) and not keyDown(KeyShift!) then
	dw_1.Modify("DataWindow.Selected='"+string(currentrow)+"/"+string(currentrow)+"/col_"+string(current_col)+"'")
end if


end event

event resize;il_dwwidth=newwidth

end event

type st_tip from uo_tooltip within uo_resultset_grid
integer x = 745
integer y = 164
boolean bringtotop = true
end type

event needtext;call super::needtext;string s
long pos
if handle=handle(dw_1) then
	s=dw_1.getObjectatpointer( )
	pos=pos(s,'~t')
	s=left(s,pos -1)
	if dw_1.describe(s+'.type')='text' then
		return dw_1.describe(s+'.tag')
	end if
end if
return ''

end event

type phl_filter_d from picturehyperlink within uo_resultset_grid
boolean visible = false
integer x = 5
integer y = 336
integer width = 55
integer height = 48
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "img\filter_d.bmp"
string powertiptext = "Reset Filter"
end type

event clicked;dw_1.SetFilter('')
dw_1.filter()
this.visible=false

end event

type in_text_metrics from n_text_metrics within uo_resultset_grid descriptor "pb_nvo" = "true" 
end type

on in_text_metrics.create
call super::create
end on

on in_text_metrics.destroy
call super::destroy
end on

