HA$PBExportHeader$n_string_builder.sru
forward
global type n_string_builder from nonvisualobject
end type
end forward

global type n_string_builder from nonvisualobject
end type
global n_string_builder n_string_builder

type variables
private blob ib_data
private long il_length
end variables

forward prototypes
public subroutine of_init ( )
public subroutine of_build_string (readonly string as_value)
public function string of_string ()
end prototypes

public subroutine of_init ( );
il_length = 0
ib_data =&
	blob(space(256))

end subroutine

public subroutine of_build_string (readonly string as_value);long ll_ret

if isnull(as_value) then return 
	
do
	ll_ret = blobedit(ib_data,  il_length + 1,  as_value)
	// a null tells us there is no more room in the blob
	if not isnull(ll_ret) then exit
	
	if len(ib_data) = 0 then
		of_init()
		continue
	end if
	
	// double the buffer size and try again
	ib_data = ib_data + ib_data
loop while true

// cut off the null terminator
il_length =ll_ret - 3

end subroutine

public function string of_string ();
if il_length = 0 then return ""

// make certain there's a NULL at the end (there should be already, unless the blob is "empty")
blobedit(ib_data,  il_length + 1,  integer(0))
return string(ib_data)

end function

on n_string_builder.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_string_builder.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

