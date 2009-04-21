HA$PBExportHeader$uo_menubar.sru
$PBExportComments$$Id: uo_menubar.sru,v 1.1 2003/05/20 12:55:25 lachinfophg Exp $
forward
global type uo_menubar from userobject
end type
type tv_pic from treeview within uo_menubar
end type
type t_tbbutton from structure within uo_menubar
end type
type t_tbaddbitmap from structure within uo_menubar
end type
type t_imageinfo from structure within uo_menubar
end type
type t_rect from structure within uo_menubar
end type
type t_nmhdr from structure within uo_menubar
end type
type t_buttoninfo from structure within uo_menubar
end type
type t_bitmap from structure within uo_menubar
end type
type t_coloradjustment from structure within uo_menubar
end type
end forward

type t_tbbutton from structure
	long		ibitmap
	long		idcommand
	integer		fsstate_fsstyle
	unsignedinteger		reserved
	unsignedlong		dwdata
	long		istring
end type

type t_tbaddbitmap from structure
	long		hinst
	long		nid
end type

type t_imageinfo from structure
	long		hbmimage
	long		hbmmask
	long		unused1
	long		unused2
	long		x
	long		y
	long		x2
	long		y2
end type

type t_rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

type t_nmhdr from structure
	unsignedlong		hwndfrom
	unsignedlong		idfrom
	unsignedlong		code
	unsignedlong		dwitemspec
end type

type t_buttoninfo from structure
	long		id
	string		tooltip
	string		text
end type

type t_bitmap from structure
	long		bmtype
	long		bmwidth
	long		bmheight
	long		bmwidthbytes
	integer		bmplanes
	integer		bmbitspixel
	long		bmbits
end type

type t_coloradjustment from structure
	integer		casize
	integer		caflags
	integer		cailluminantindex
	integer		caredgamma
	integer		cagreengamma
	integer		cabluegamma
	integer		careferenceblack
	integer		careferencewhite
	integer		cacontrast
	integer		cabrightness
	integer		cacolorfulness
	integer		caredgreentint
end type

global type uo_menubar from userobject
integer width = 800
integer height = 1404
long backcolor = 76585128
long tabtextcolor = 33554432
long tabbackcolor = 76585128
long picturemaskcolor = 553648127
event btn_clicked ( readonly long id )
event resize pbm_size
event btn_rclicked ( long id )
event uef_getaddress pbm_custom01
event syscolorchange pbm_syscolorchange
tv_pic tv_pic
end type
global uo_menubar uo_menubar

type prototypes
private function long CreateWindowEx(long dwExStyle,string lpClassName,string lpWindowName,long dwStyle,long nx,long ny,long nWidth,long nHeight,long hWndParent,long hMenu,	long hInstance,long lpParam)library 'user32' alias for "CreateWindowExW"
private function long SendMessage(long hwndDst,long msg,long wparm,ref t_rect rect)library 'user32' alias for "SendMessageW"
private function long SendMessage(long hwndDst,long msg,long wparm,ref t_tbbutton lparam[] )library 'user32' alias for "SendMessageW"
private function long SendMessage(long hwndDst,long msg,long wparm,ref string lparam )library 'user32' alias for "SendMessageW"
private function long SendMessage(long hwndDst,long msg,long wparm,ref blob lparam )library 'user32' alias for "SendMessageW"
//private function long SendMessage(long hwndDst,long msg,long wparm,ref long lparam )library 'user32' alias for "SendMessageW"
private function boolean DestroyWindow (long hWndDst)library 'user32'
private function boolean GetClientRect(long hWndDst,ref t_rect lpRect)library 'user32' alias for "GetClientRect"

private subroutine RtlMoveMemory( ref t_nmhdr dest, long src, long srclen ) library 'kernel32' alias for "RtlMoveMemory"
private subroutine RtlMoveMemory( long dest,ref long src, long srclen ) library 'kernel32'

private function boolean SetWindowPos(long hWndDst, long hWndInsertAfter, long nX, long nY, long cx, long cy, ulong uFlags)library 'user32'

private function long CreateCompatibleDC(long hdc)library 'gdi32'
private function boolean DeleteDC(long hdc)library 'gdi32'
private function long GetObject(long hgdiobj, long cbBuffer, ref t_bitmap bmp)library 'gdi32' alias for 'GetObjectW'
private function long SelectObject(long hdc, long hgdiobj)library 'gdi32'
private function boolean SetStretchBltMode(long hdcDst, long HALFTONE) library 'gdi32'
private function boolean SetColorAdjustment(long hdc,ref T_COLORADJUSTMENT lpca) library 'gdi32' alias for "SetColorAdjustment"
private function boolean GetColorAdjustment(long hdc,ref T_COLORADJUSTMENT lpca) library 'gdi32' alias for "GetColorAdjustment"
private function boolean StretchBlt(long hdcDest,	long nXOriginDest,long nYOriginDest,long nWidthDest,long nHeightDest,long hdcSrc,long nXOriginSrc,long nYOriginSrc,long nWidthSrc,long nHeightSrc,long dwRop) library 'gdi32'
private function long CreateBitmapIndirect(ref T_BITMAP bmp) library 'gdi32' alias for "CreateBitmapIndirect"
private function boolean DeleteObject(long hObject) library 'gdi32'
private function boolean BitBlt(long hdcDest,long nXDest,long nYDest,long nWidth,long nHeight,long hdcSrc,long nXSrc,long nYSrc,long dwRop) library 'gdi32'

private function boolean ImageList_GetImageInfo(long himl, long i, ref T_IMAGEINFO pImageInfo) library 'comctl32' alias for "ImageList_GetImageInfo"
private function long ImageList_Merge(long himl1, long i1, long himl2, long i2, long dx, long dy) library 'comctl32'
private function boolean ImageList_Destroy(long himl) library 'comctl32'
private function long ImageList_Create(long cx, long cy, long flags, long cInitial, long cGrow	) library 'comctl32'
private function long ImageList_Add(long himl,long hbmImage, long hbmMask) library 'comctl32'
private function long ImageList_GetImageCount(long himl) library 'comctl32'

private function long CopyImage(long hImage,long uType,long cxDesired,long cyDesired,long fuFlags) library 'user32'


// Operations groupebox
function long SetFocus(long hWnd) library "user32"

end prototypes

type variables
private:
long hwndTB=0

//$$HEX9$$44044b04320430043f0440043e040d000a00$$ENDHEX$$//$$HEX8$$e900e800e700e0000d000a000d000a00$$ENDHEX$$long TB_BUTTONSTRUCTSIZE=1024+30
long TB_SETBUTTONSIZE=1024+31
long TB_SETBITMAPSIZE=1024+32
long TB_BUTTONCOUNT=1024+ 24
//long TB_ADDSTRINGA  =1024 + 28

long TB_ADDBITMAP     =1024+ 19
long TB_ADDBUTTONS =1024 + 20

long TB_ADDSTRINGW  =1024 + 77
t_tbbutton btn[]


boolean ib_staticedge=false
boolean ib_vertical=true
boolean ib_obscure=false

t_buttoninfo btnInf[]

integer img_width=16
integer img_height=16

long imgListDark

end variables

forward prototypes
public function long of_count ()
private function long of_addstring (readonly string as_text)
public subroutine of_setstaticedge (boolean b)
public subroutine of_setimagesize (integer pixel_width, integer pixel_height)
public function boolean of_enable (long al_id, boolean ab_enable)
public function boolean of_check (long al_id, boolean ab_check)
public function boolean of_isenabled (long al_id)
public function boolean of_ischecked (long al_id)
public subroutine of_setvertical (boolean b)
private function long of_gettooltips ()
public function boolean of_getsize (ref long ww, ref long hh)
private subroutine of_translatemsg (long msgid, long wparm, long lparm)
public subroutine of_setobscure (boolean b)
public function boolean of_apply ()
public function long of_darkimglist (long imglist)
private function boolean of_error (readonly string msg)
public function boolean of_hide (long al_id, boolean ab_hide)
public function boolean of_ishidden (long al_id)
private function long of_addbitmap (readonly string as_picture)
public function string of_gettext (long al_id)
public function string of_gettooltip (long al_id)
private subroutine of_setbuttonwidth ()
public function boolean of_init ()
public function integer of_state_style (integer ai_state, integer ai_style)
public function boolean of_addbutton (readonly long al_id, string as_picture, string as_text, string as_tooltip)
public subroutine of_getitemrect (integer ai_index, ref long ll, ref long tt, ref long rr, ref long bb)
public function integer setfocus ()
end prototypes

event resize;long TB_SETROWS      = 1024 + 39
t_rect r

tv_pic.move(0,0)
tv_pic.resize(newwidth,newheight)

newwidth=UnitsToPixels(newwidth,XUnitsToPixels!)
newheight=UnitsToPixels(newheight,YUnitsToPixels!)

if ib_vertical then
	SendMessage(hwndTB,TB_SETROWS,long(upperbound(btn),1),r)
end if
SetWindowPos(hwndTB,0,0,0,newwidth,newheight,534)
of_setbuttonwidth()
//post(hwndTB,TB_AUTOSIZE,0,0)

end event

event uef_getaddress;return lparam

end event

event syscolorchange;this.backcolor=this.backcolor

end event

public function long of_count ();return send(hwndTB,TB_BUTTONCOUNT,0,0)

end function

private function long of_addstring (readonly string as_text);blob b
long i=0
long l=len(blob(' ')) //char size

//convert text to blob + concatenate some additional chars
b=blob(as_text+'    Z')
//replace the last character with two 0x0 characters
/* count begins from 1 that's why we use +1 expression */
i=BlobEdit(b,len(as_text)*l+1,i)

//for debug purpose
//integer li_FileNum
//
//li_FileNum = FileOpen("C:\blob.txt", StreamMode!, Write!, LockWrite!, Replace!)
//
//FileWrite(li_FileNum, b)
//fileclose(li_FileNum)
//
//if MessageBox('',as_text,Information!,OkCancel!)=2 then halt


//return send(hwndTB,TB_ADDSTRINGW,0,as_text+"~000~000~000~000") //not working in PB10
//return send(hwndTB,TB_ADDSTRINGA,0,as_text+"~000")
return sendMessage(hwndTB,TB_ADDSTRINGW,0,b)

end function

public subroutine of_setstaticedge (boolean b);ib_staticedge=b

end subroutine

public subroutine of_setimagesize (integer pixel_width, integer pixel_height);img_width=pixel_width
img_height=pixel_height

end subroutine

public function boolean of_enable (long al_id, boolean ab_enable);//enable/disable buttons with id=al_id

long i,count
long TB_ENABLEBUTTON=1024+1
long ll_enable=0
if ab_enable then ll_enable=1

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		send(hwndtb,TB_ENABLEBUTTON,i,ll_enable)
	end if
next

return true

end function

public function boolean of_check (long al_id, boolean ab_check);//check/uncheck buttons with id=al_id



long i,count
long TB_CHECKBUTTON=1024+2
long ll_check=0
if ab_check then ll_check=1

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		send(hwndtb,TB_CHECKBUTTON,i,ll_check)
	end if
next

return true

end function

public function boolean of_isenabled (long al_id);//returns true if button enabled
long i,count
long TB_ISBUTTONENABLED=1024 + 9

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		return send(hwndtb,TB_ISBUTTONENABLED,i,0)<>0
	end if
next

return false

end function

public function boolean of_ischecked (long al_id);//returns true if button checked

long i,count
long TB_ISBUTTONCHECKED=1024 + 10

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		return send(hwndtb,TB_ISBUTTONCHECKED,i,0)<>0
	end if
next

return false

end function

public subroutine of_setvertical (boolean b);ib_vertical=b

end subroutine

private function long of_gettooltips ();//The TB_GETTOOLTIPS message retrieves the handle to the tooltip control, 
//if any, associated with the toolbar. 
//Returns the handle to the tooltip control or NULL if the toolbar has no associated tooltip. 

long TB_GETTOOLTIPS=1024+35

return send(hwndtb,TB_GETTOOLTIPS,0,0)

end function

public function boolean of_getsize (ref long ww, ref long hh);long TB_GETITEMRECT=1024 + 29
long i
t_rect r

/* search right visible item*/
i = of_count()
do while i>1
	if not of_ishidden(btnInf[i].id)then exit
	i --
loop

SendMessage(hwndtb,TB_GETITEMRECT,i -1,r)

ww=PixelsToUnits(r.right,XPixelsToUnits!)
hh=PixelsToUnits(r.bottom,YPixelsToUnits!)

return true

end function

private subroutine of_translatemsg (long msgid, long wparm, long lparm);//WM_NOTIFY   0x004E
if msgID=78 then
	t_nmhdr nmhdr
	RtlMoveMemory(nmhdr,lparm,16)
	if nmhdr.hwndFrom=hwndTB then
		CHOOSE CASE nmhdr.code
			CASE -2//4294967294	//NM_CLICKED
				if nmhdr.dwItemSpec<>-1 then this.event btn_clicked(btnInf[nmhdr.dwItemSpec].id)
			CASE -5	//NM_RCLICK
				if nmhdr.dwItemSpec<>-1 then 
					this.event btn_rclicked(btnInf[nmhdr.dwItemSpec].id)
				else
					this.triggerevent(rbuttondown!)
				end if
		END CHOOSE

	end if
	if nmhdr.code=-530 then
		if /*of_gettooltips()=nmhdr.hwndFrom and */nmhdr.idFrom>0 and nmhdr.idFrom<=upperbound(btnInf) then
			if btnInf[nmhdr.idFrom].tooltip<>'' then
				long ll_tt
				ll_tt=sendMessage(handle(this),1024,0,btnInf[nmhdr.idFrom].tooltip)
				RtlMoveMemory(lparm+12,ll_tt,4)
			end if
		end if
	end if
end if

end subroutine

public subroutine of_setobscure (boolean b);ib_obscure=b


end subroutine

public function boolean of_apply ();long TVM_GETIMAGELIST= 4352 + 8 //TVM_GETIMAGELIST        (TV_FIRST + 8)
long imgList
//long imgListDark
long TB_SETIMAGELIST = 1024 + 48
long TB_SETHOTIMAGELIST =1024 + 52
long TB_SETROWS      = 1024 + 39
long TB_AUTOSIZE     = 1024 + 33
t_rect r
long ret


if imgListDark<>0 then 
	ImageList_Destroy(imgListDark)
	imgListDark=0
end if

//T_IMAGEINFO imginfo
imgList=send(handle(tv_pic),TVM_GETIMAGELIST,0,0)

if ib_obscure then
	imgListDark=of_darkimglist(imglist)
	if imgListDark<>0 then
		ret=send(hwndTB,TB_SETIMAGELIST,0,imgListDark)
		ret=send(hwndTB,TB_SETHOTIMAGELIST,0,imgList)
	else
		ret=send(hwndTB,TB_SETIMAGELIST,0,imgList)
	end if
else
	ret=send(hwndTB,TB_SETIMAGELIST,0,imgList)
end if


ret=SendMessage(hwndTB,TB_ADDBUTTONS,upperbound(btn),btn)
ret=Send(hwndTB,TB_AUTOSIZE,0,0)
//ret=SendMessage(hwndTB,TB_SETROWS,long(upperbound(btn),1),r)
this.setRedraw(true)
return true

end function

public function long of_darkimglist (long imglist);long hdc=0

long hbmpOld=0
long hbmpOldM=0
long hbmp=0
long hbmm=0

long imgListNew=0
T_IMAGEINFO ImgInfo
t_bitmap bmpInfo
t_coloradjustment clradj

hdc=CreateCompatibleDC(0)
if hdc=0 then goto error

//get imgListNew and it's bitmap info
if not ImageList_GetImageInfo(imgList, 0, ImgInfo) then goto error
if GetObject(imgInfo.hbmimage, 24, bmpInfo)<>24 then goto error

//hbmp=CreateBitmapIndirect(bmpInfo)//copy the bitmap of the imgListNew
hbmp=CopyImage(imgInfo.hbmimage,0,bmpInfo.bmWidth,bmpInfo.bmHeight,4)

hbmpOld=SelectObject(hdc,hbmp)//select bmp into hdc 
if not SetStretchBltMode(hdc, 4) then goto error//HALFTONE
//set color adjustment
clrAdj.casize=24
GetColorAdjustment(hdc,clrAdj)
//clrAdj.caColorfulness=-50
clrAdj.caBrightness=30
clrAdj.caContrast=-30
SetColorAdjustment(hdc,clrAdj)
//copy bmp into itself to make it darker
StretchBlt(hdc,0,0,bmpInfo.bmWidth,bmpInfo.bmHeight,hdc,0,0,bmpInfo.bmWidth,bmpInfo.bmHeight,13369376)
//copy bmp on the screen
//StretchBlt(GetWindowDC(handle(this)),50,100,bmpInfo.bmWidth,bmpInfo.bmHeight,hdc,0,0,bmpInfo.bmWidth,bmpInfo.bmHeight,13369376)
SelectObject(hdc,hbmpOld)
hbmpOld=0

//create New  imagelist
imgListNew=ImageList_Create(ImgInfo.x2,ImgInfo.y2, 254+1, 4, 4	)
if imgListNew=0 then goto error

//copy mask
hbmm=CopyImage(imgInfo.hbmmask,0,bmpInfo.bmWidth,bmpInfo.bmHeight,4)
//show mask img
//hbmpOld=SelectObject(hdc,hbmm)//select bmp into hdc 
//StretchBlt(GetWindowDC(handle(this)),50,50+32+32,bmpInfo.bmWidth,bmpInfo.bmHeight,hdc,0,0,bmpInfo.bmWidth,bmpInfo.bmHeight,13369376)
//SelectObject(hdc,hbmpOld)
//hbmpOld=0

//Add images to the new image list
if ImageList_Add(imgListNew,hbmp,hbmm)=-1 then goto error

long xCount,yCount,imgCount,i
xCount=bmpInfo.bmWidth/imgInfo.x2
yCount=bmpInfo.bmHeight/imgInfo.y2
imgCount=ImageList_GetImageCount(imgList)
for i=1 to yCount - 1
	hbmpOld=SelectObject(hdc,hbmp)
	BitBlt(hdc,0,0,bmpInfo.bmWidth,imgInfo.y2,hdc,0,i*imgInfo.y2,13369376)//SRCCOPY=0x00CC0020
	SelectObject(hdc,hbmm)
	BitBlt(hdc,0,0,bmpInfo.bmWidth,imgInfo.y2,hdc,0,i*imgInfo.y2,13369376)//SRCCOPY=0x00CC0020
	SelectObject(hdc,hbmpOld)
	hbmpOld=0
	
	if ImageList_Add(imgListNew,hbmp,hbmm)=-1 then goto error
	
	if i*xCount>=imgCount then exit
next
//i=(bmpInfo.bmWidth/imgInfo.x2)*(bmpInfo.bmHeight/imgInfo.y2)


ImageList_GetImageInfo(imgListNew, 0, ImgInfo)
GetObject(imgInfo.hbmimage, 24, bmpInfo)


goto clear
error:
if imgListNew<>0 then ImageList_Destroy(imgListNew)
imgListNew=0
clear:
if hbmpOld<>0 then SelectObject(hdc,hbmpOld)
if hdc<>0 then DeleteDC(hdc)
if hbmp<>0 then DeleteObject(hbmp)
if hbmm<>0 then DeleteObject(hbmm)

return imgListNew

end function

private function boolean of_error (readonly string msg);f_error(msg)
return false

end function

public function boolean of_hide (long al_id, boolean ab_hide);//hide/unhide buttons with id=al_id

long i,count
long TB_HIDEBUTTON=1024+4
long ll_hide=0
if ab_hide then ll_hide=1

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		send(hwndtb,TB_HIDEBUTTON,i,ll_hide)
	end if
next

return true

end function

public function boolean of_ishidden (long al_id);//returns true if button hidden

long i,count
long TB_ISBUTTONHIDDEN=1024 + 12

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		return send(hwndtb,TB_ISBUTTONHIDDEN,i,0)<>0
	end if
next

return false

end function

private function long of_addbitmap (readonly string as_picture);int pic
pic=tv_pic.AddPicture(as_picture)
if pic>0 then pic --
return pic

end function

public function string of_gettext (long al_id);//returns the text of button
long i,count

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		return btnInf[i].text
	end if
next

return ''

end function

public function string of_gettooltip (long al_id);//returns the tooltip of button
long i,count

count=upperBound(btn)
for i=1 to count
	if btnInf[i].id=al_id then
		return btnInf[i].tooltip
	end if
next

return ''

end function

private subroutine of_setbuttonwidth ();if ib_vertical then
	long TB_SETBUTTONWIDTH  = 1024 + 59
	t_rect r
	GetClientRect(hwndTB,r)
	send(hwndTB,TB_SETBUTTONWIDTH,0, long(r.right,r.right) )
end if

end subroutine

public function boolean of_init ();long lWS_CHILD,lWS_VISIBLE,lTBSTYLE_FLAT,lTBSTYLE_TOOLTIPS,lTBSTYLE_LIST,lCCS_VERT,lCCS_TOP,lCCS_NORESIZE,lCCS_NODIVIDER,lTBSTYLE_WRAPABLE
long dwStyle
long exStyle=0
t_tbbutton btn_empty[]
t_buttonInfo btnInf_empty[]

long TB_SETEXTENDEDSTYLE= 1024 + 84

t_rect r

lWS_CHILD=  f_hex2long('40000000')
lWS_VISIBLE=f_hex2long('10000000')

lTBSTYLE_TOOLTIPS=f_hex2long('100')
lTBSTYLE_FLAT=f_hex2long('800')
lTBSTYLE_LIST=f_hex2long('1000')
lTBSTYLE_WRAPABLE=f_hex2long('0200')

lCCS_VERT=f_hex2long('80')
lCCS_TOP=1
lCCS_NORESIZE=4
lCCS_NODIVIDER=f_hex2long('40')

if ib_staticedge then exStyle+=f_hex2long('20000')

dwStyle=lWS_CHILD+lWS_VISIBLE
dwStyle+=lTBSTYLE_TOOLTIPS+lCCS_NORESIZE+lCCS_NODIVIDER+lCCS_TOP+lTBSTYLE_FLAT
if ib_vertical then dwStyle+=lCCS_VERT+lTBSTYLE_LIST+lTBSTYLE_WRAPABLE

SetRedraw(false)
if hwndTB<>0 then DestroyWindow(hwndTB)
btn=btn_empty
btnInf=btnInf_empty
tv_pic.DeletePictures()
tv_pic.PictureHeight = img_width
tv_pic.PictureWidth = img_height
GetClientRect(handle(this),r)
hwndTB=CreateWindowEx(exStyle,'ToolbarWindow32','menubar',dwStyle,0,0,r.right,r.bottom,handle(tv_pic),0,0,0)

if hwndTB=0 then 
	SetRedraw(true)
	return of_error('Error creating menubar window')
end if
send(hwndTB,tb_buttonstructsize,20,0)
//if send(hwndTB,TB_SETBUTTONSIZE,0,long(r.right,30))=0 then of_error('Error setting button size for menubar')
//if send(hwndTB,TB_SETBITMAPSIZE,0,long(25,25))=0 then of_error('Error setting bitmap size for menubar')
of_setbuttonwidth()
//send(hwndTB,TB_SETBUTTONWIDTH,0, long(r.right,r.right) )
//Send(hwndTB, TB_SETEXTENDEDSTYLE, 0, 1)

// VLGN
SetFocus(hwndTB)

return true

end function

public function integer of_state_style (integer ai_state, integer ai_style);return ai_style * 256 +  ai_state
end function

public function boolean of_addbutton (readonly long al_id, string as_picture, string as_text, string as_tooltip);long bmpID
long strID
long id


id=upperbound(btn)+1

if isNull(as_picture) then as_picture=''
if isNull(as_text) then as_text=''
if isNull(as_tooltip) then as_tooltip=''

if as_picture='' and as_text='' then
	btn[id].iBitmap=-1
	btn[id].idCommand=0
//	btn[id].fsState='~000'
//	btn[id].fsStyle='~001'
	btn[id].fsstate_fsstyle = of_state_style(0,1)
	btn[id].dwData=0
	btn[id].iString=-1
else
	bmpID=of_addbitmap(as_picture)
	if bmpID<0 then 
		//of_error('Error adding picture to menubar :~r~npicture~t: '+as_picture)
		bmpID=of_addbitmap('NotFound!')
	end if
	if as_text='' then
		strID=-1
	else
		strID=of_addString(as_text)
		if strID<0 then return of_error('Error adding string to menubar :~r~n'+as_text)
	end if
	
	btn[id].iBitmap=bmpID
	btn[id].idCommand=id
//	btn[id].fsState='~h04'
//	if ib_vertical then btn[id].fsState='~h24'
//	btn[id].fsStyle='~h00'
	btn[id].fsstate_fsstyle = of_state_style(4,0)
	if ib_vertical then btn[id].fsstate_fsstyle = of_state_style(36,0)
	
	btn[id].dwData=0
	btn[id].iString=strID
	
	btnInf[id].id=al_id
	btnInf[id].tooltip=as_tooltip
	btnInf[id].text=as_text
end if

return true

end function

public subroutine of_getitemrect (integer ai_index, ref long ll, ref long tt, ref long rr, ref long bb);//VG 21.04.05 Macros project
long TB_GETITEMRECT=1024 + 29
t_rect r

SendMessage(hwndtb,TB_GETITEMRECT, ai_index,r)

ll = PixelsToUnits(r.left,XPixelsToUnits!)
tt = PixelsToUnits(r.top,YPixelsToUnits!)
rr = PixelsToUnits(r.right,XPixelsToUnits!)
bb = PixelsToUnits(r.bottom,YPixelsToUnits!)

end subroutine

public function integer setfocus ();return SetFocus(hwndTB)
end function

event uef_log();
/*
$Log: uo_menubar.sru,v $
Revision 1.1  2003/05/20 12:55:25  lachinfophg
Add datawindow objects

*/
end event

on uo_menubar.create
this.tv_pic=create tv_pic
this.Control[]={this.tv_pic}
end on

on uo_menubar.destroy
destroy(this.tv_pic)
end on

event constructor;tv_pic.move(0,0)
tv_pic.resize(this.width,this.height)

end event

event destructor;if imgListDark<>0 then 
	ImageList_Destroy(imgListDark)
	imgListDark=0
end if

end event

type tv_pic from treeview within uo_menubar
event syscolorchange pbm_syscolorchange
integer width = 667
integer height = 956
integer taborder = 1
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 76585128
boolean border = false
string picturename[] = {"NotFound!"}
integer picturewidth = 16
integer pictureheight = 16
long picturemaskcolor = 12632256
long statepicturemaskcolor = 536870912
end type

event syscolorchange;this.backcolor=this.backcolor

end event

event other;of_translatemsg(message.number,wparam,lparam)

end event

