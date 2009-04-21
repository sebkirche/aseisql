HA$PBExportHeader$uv_collateview.sru
forward
global type uv_collateview from userobject
end type
type st_11 from statictext within uv_collateview
end type
type st_21 from statictext within uv_collateview
end type
type st_12 from statictext within uv_collateview
end type
type st_22 from statictext within uv_collateview
end type
type st_13 from statictext within uv_collateview
end type
type st_23 from statictext within uv_collateview
end type
end forward

global type uv_collateview from userobject
integer width = 521
integer height = 216
st_11 st_11
st_21 st_21
st_12 st_12
st_22 st_22
st_13 st_13
st_23 st_23
end type
global uv_collateview uv_collateview

type variables
boolean collate=true
end variables

forward prototypes
public function integer  f_setcollate (boolean b)
public function boolean  f_getcollate ()
end prototypes

public function integer  f_setcollate (boolean b);if b<>collate then
	SetRedraw(false)
	if b then
		st_13.x=293
		st_13.y=17
		st_13.bringToTop=false
		st_12.x=257
		st_12.y=49
		st_12.bringToTop=true
		st_11.x=220
		st_11.y=81
		st_11.bringToTop=true
		
		st_23.x=92
		st_23.y=17
		st_23.bringToTop=false
		st_22.x=55
		st_22.y=49
		st_22.bringToTop=true
		st_21.x=19
		st_21.y=81
		st_21.bringToTop=true
	else
		st_11.x=55
		st_11.y=17
		st_11.bringToTop=false
		st_12.x=220
		st_12.y=17
		st_12.bringToTop=false
		st_13.x=385
		st_13.y=17
		st_13.bringToTop=false
		st_21.x=19
		st_21.y=65
		st_21.bringToTop=true
		st_22.x=183
		st_22.y=65
		st_22.bringToTop=true
		st_23.x=348
		st_23.y=65
		st_23.bringToTop=true
	end if
	collate=b
	SetRedraw(true)
end if
return(1)

end function

public function boolean  f_getcollate ();return(collate)

end function

on uv_collateview.create
this.st_11=create st_11
this.st_21=create st_21
this.st_12=create st_12
this.st_22=create st_22
this.st_13=create st_13
this.st_23=create st_23
this.Control[]={this.st_11,&
this.st_21,&
this.st_12,&
this.st_22,&
this.st_13,&
this.st_23}
end on

on uv_collateview.destroy
destroy(this.st_11)
destroy(this.st_21)
destroy(this.st_12)
destroy(this.st_22)
destroy(this.st_13)
destroy(this.st_23)
end on

event constructor;call super::constructor;width=522
height=217

end event

type st_11 from statictext within uv_collateview
integer x = 219
integer y = 80
integer width = 110
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "       1"
alignment alignment = right!
boolean border = true
long bordercolor = 33554432
boolean focusrectangle = false
end type

type st_21 from statictext within uv_collateview
integer x = 18
integer y = 80
integer width = 110
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "       1"
alignment alignment = right!
boolean border = true
long bordercolor = 33554432
boolean focusrectangle = false
end type

type st_12 from statictext within uv_collateview
integer x = 256
integer y = 48
integer width = 110
integer height = 112
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "       2"
alignment alignment = right!
boolean border = true
long bordercolor = 33554432
boolean focusrectangle = false
end type

type st_22 from statictext within uv_collateview
integer x = 55
integer y = 48
integer width = 110
integer height = 112
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "       2"
alignment alignment = right!
boolean border = true
long bordercolor = 33554432
boolean focusrectangle = false
end type

type st_13 from statictext within uv_collateview
integer x = 293
integer y = 16
integer width = 110
integer height = 112
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "       3"
alignment alignment = right!
boolean border = true
long bordercolor = 33554432
boolean focusrectangle = false
end type

type st_23 from statictext within uv_collateview
integer x = 91
integer y = 16
integer width = 110
integer height = 112
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean enabled = false
string text = "       3"
alignment alignment = right!
boolean border = true
long bordercolor = 33554432
boolean focusrectangle = false
end type

