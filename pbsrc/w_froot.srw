HA$PBExportHeader$w_froot.srw
forward
global type w_froot from window
end type
type cb_cancel from commandbutton within w_froot
end type
type cb_ok from commandbutton within w_froot
end type
type st_2 from statictext within w_froot
end type
type st_1 from statictext within w_froot
end type
type sle_path from singlelineedit within w_froot
end type
type cb_browse from commandbutton within w_froot
end type
type sle_name from singlelineedit within w_froot
end type
type t_browse_info from structure within w_froot
end type
end forward

type t_browse_info from structure
	long		hWndOwner
	long		pIDLRoot
	long		pszDisplayName
	long		lpszTitle
	long		ulFlags
	long		lpfnCallback
	long		lParam
	long		iImage      
end type

global type w_froot from window
integer width = 1413
integer height = 528
boolean titlebar = true
string title = "File root"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
st_2 st_2
st_1 st_1
sle_path sle_path
cb_browse cb_browse
sle_name sle_name
end type
global w_froot w_froot

type prototypes
// The Win 32 API's function for displaying selection directory dialog box
private Function long SHBrowseForFolder (ref t_browse_Info sBrowseInfo) Library "Shell32" alias for "SHBrowseForFolderW"
// The Win 32 API's function for converting path identifier to a file system path
private Function long SHGetPathFromIDList (long pidList, ref string lpBuffer) Library "Shell32" alias for "SHGetPathFromIDListW"

end prototypes

type variables
n_hashtable parm

end variables

forward prototypes
public subroutine of_check ()
end prototypes

public subroutine of_check ();boolean b

b = len(trim(sle_name.text))>0 and DirectoryExists(sle_path.text) and right(sle_path.text,1)<>'\' and right(sle_path.text,1)<>'/'
cb_ok.enabled=b

end subroutine

on w_froot.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_2=create st_2
this.st_1=create st_1
this.sle_path=create sle_path
this.cb_browse=create cb_browse
this.sle_name=create sle_name
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.st_2,&
this.st_1,&
this.sle_path,&
this.cb_browse,&
this.sle_name}
end on

on w_froot.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_path)
destroy(this.cb_browse)
destroy(this.sle_name)
end on

event open;f_autosize(this)
f_centerwindow(this)
parm=message.powerobjectparm

sle_name.text=parm.of_get('name','')
sle_path.text=parm.of_get('path','')
parm.of_set('ok',false)

end event

type cb_cancel from commandbutton within w_froot
integer x = 745
integer y = 304
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cb_ok from commandbutton within w_froot
integer x = 329
integer y = 304
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "ok"
boolean default = true
end type

event clicked;if len(cfg.of_getstring('froots.def',trim(sle_name.text)))>0 then
	if trim(sle_name.text)<>parm.of_get('name','') then
		f_error('This name already exists.')
		sle_name.post SetFocus()
		return 0
	end if
end if

parm.of_set('name',trim(sle_name.text))
parm.of_set('path',sle_path.text)
parm.of_set('ok',true)
close(parent)

end event

type st_2 from statictext within w_froot
integer x = 46
integer y = 192
integer width = 183
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Path:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_froot
integer x = 46
integer y = 68
integer width = 183
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Name:"
boolean focusrectangle = false
end type

type sle_path from singlelineedit within w_froot
event change pbm_enchange
integer x = 247
integer y = 180
integer width = 937
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event change();of_check()

end event

type cb_browse from commandbutton within w_froot
integer x = 1184
integer y = 180
integer width = 110
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "..."
end type

event clicked;t_browse_info tBrowseInfo	// BROWSE_INFO Win32 API's structure
Long lpIDList			// Pointer that specifies the location of the selected directory
Constant long BIF_RETURNONLYFSDIRS = 1 						// Only return file system directories  
string s

// Setting handle to the w_profile Window for the dialog box
tBrowseInfo.hWndOwner = Handle(parent)

// Specifying the options for the dialog box
tBrowseInfo.ulFlags = BIF_RETURNONLYFSDIRS

// Getting selected directory path
lpIDList = SHBrowseForFolder(tBrowseInfo)

// Checking whether the user selects directory from the standard Windows dialog
If lpIDList<>0 Then
	s = Space(4000)
	SHGetPathFromIDList(lpIDList, s)
	sle_path.text=''
	sle_path.replacetext( s )
	if sle_name.text='' then 
		sle_name.text=sle_path.text
		sle_name.selecttext( 1, 4000)
		sle_name.post setFocus()
	end if
End If

end event

type sle_name from singlelineedit within w_froot
event change pbm_enchange
integer x = 247
integer y = 64
integer width = 937
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event change;of_check()

end event

