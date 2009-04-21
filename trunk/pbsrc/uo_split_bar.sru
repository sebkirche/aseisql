HA$PBExportHeader$uo_split_bar.sru
$PBExportComments$$$HEX7$$3e0431044c0435043a0442042000$$ENDHEX$$- $$HEX13$$400430043704340435043b043804420435043b044c040d000a00$$ENDHEX$$forward
global type uo_split_bar from statictext
end type
end forward

global type uo_split_bar from statictext
integer width = 82
integer height = 404
string pointer = "SizeWE!"
long textcolor = 12639424
long backcolor = 12639424
boolean focusrectangle = false
event lbuttondown pbm_lbuttondown
event lbuttonup pbm_lbuttonup
event mousemove pbm_mousemove
event ue_moved ( )
event ue_moving ( )
event ue_parent_resize ( )
end type
global uo_split_bar uo_split_bar

type variables
private boolean busy=false
boolean vertical=true
private integer delta

integer FromBegin=500  //
integer FromEnd=2071  //

private window parentW
private userObject parentUO

private int wichParent=-1 //  1:win; 2:UO; ...
end variables

forward prototypes
public subroutine of_setspsize (string as_file, string as_section)
public subroutine of_getspsize (string as_file, string as_section)
end prototypes

event lbuttondown;busy=true

CHOOSE CASE wichParent
	CASE 1
		if vertical then
			delta=parentW.PointerX() - this.x
		else
			delta=parentW.PointerY() - this.y
		end if
	CASE 2
		if vertical then
			delta=parentUO.PointerX() - this.x
		else
			delta=parentUO.PointerY() - this.y
		end if
END CHOOSE



//if vertical then
//	delta=xpos
//else
//	delta=ypos
//end if

this.backcolor=276856960
this.BringToTop=true

end event

event lbuttonup;busy=false
CHOOSE CASE wichparent
	CASE 1
		this.backcolor=parentW.backcolor
	CASE 2
		this.backcolor=parentUO.backcolor
	CASE ELSE
END CHOOSE
TriggerEvent("ue_moved")

end event

event mousemove;long l
if busy then
	CHOOSE CASE wichParent
		CASE 1
			
			if vertical then
				l=parentW.width - FromEnd
				this.x=min(max(parentw.PointerX() - delta,FromBegin),l)
			else
				l=parentW.height - FromEnd
				this.y=min(max(parentw.PointerY() - delta,FromBegin),l)
			end if
		CASE 2

			if vertical then
				l=parentUO.width - FromEnd				
				this.x=min(max(parentUO.PointerX() - delta,FromBegin),l)
			else
				l=parentUO.height - FromEnd				
				this.y=min(max(parentUO.PointerY() - delta,FromBegin),l)
			end if
	END CHOOSE
	TriggerEvent("ue_moving")
end if

end event

event ue_parent_resize();call super::ue_parent_resize;long l
CHOOSE CASE wichParent
	CASE 1
		if vertical then
			l=parentW.width - FromEnd
			this.x=min(max(this.x,FromBegin),l)
		else
			l=parentW.height - FromEnd
			this.y=min(max(this.y,FromBegin),l)
		end if
	CASE 2
		if vertical then
			l=parentUO.width - FromEnd
			this.x=min(max(this.x,FromBegin),l)
		else
			l=parentUO.height - FromEnd
			this.y=min(max(this.y,FromBegin),l)
		end if
END CHOOSE

end event

public subroutine of_setspsize (string as_file, string as_section);/*********************************************************************
	<AUTH>	AB - Anna BULGAKOVA - FM2I-Dniepr </AUTH>

	<DESC>	Writes sizes and position of split bar in the profile file.
	</DESC>

	<USAGE>	(none) [zz_uo_split_bar].of_Setspsize(value String, value String)
	</USAGE>

	<ARGS>	as_file - a string whose value is the name of the profile file
            as_section - a string whose value is the name of the section 
				             in a profile file            
	</ARGS>

	<RETURN> (none) </RETURN>

	Date        :  14/01/2002
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
if vertical then
	SetProfileString(as_file, as_section, "x", string(x))
else
	SetProfileString(as_file, as_section, "y", string(y))
end if

end subroutine

public subroutine of_getspsize (string as_file, string as_section);/*********************************************************************
	<AUTH>	AB - Anna BULGAKOVA - FM2I-Dniepr </AUTH>

	<DESC>	Obtains sizes and position of the split bar of a setting
	         in the profile file
	</DESC>

	<USAGE>	(none) [zz_uo_split_bar].of_Getspsize(value String, value String)
	</USAGE>

	<ARGS>	as_file - a string whose value is the name of the profile file
            as_section - a string whose value is the name of the section 
				             in a profile file
	</ARGS>

	<RETURN> (none) </RETURN>

	Date        :  14/01/2002
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
if vertical then
	x=ProfileInt(as_file, as_section, "x", frombegin)
else
	y=ProfileInt(as_file, as_section, "y", frombegin)
end if

end subroutine

event constructor;GraphicObject which_control
BringToTop=true
which_control = GetParent( ) 

CHOOSE CASE TypeOf(which_control)
	CASE Window!
		parentW=which_control
		wichParent=1
		this.backcolor=parentW.backcolor
//		parentW.wf_register_object(this)
	CASE UserObject!
		parentUO = which_control
		wichParent=2
		this.backcolor=parentUO.backcolor
	CASE ELSE
END CHOOSE

end event

on uo_split_bar.create
end on

on uo_split_bar.destroy
end on

