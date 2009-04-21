HA$PBExportHeader$n_vector.sru
forward
global type n_vector from nonvisualobject
end type
end forward

global type n_vector from nonvisualobject
end type
global n_vector n_vector

type variables
private any ia_array[]
public privatewrite long il_size

end variables

forward prototypes
public function any of_get (readonly long al_index)
public function integer of_add (readonly any aa_value)
public function boolean of_set (readonly long al_index, readonly any aa_value)
public function any of_delete (readonly long al_index)
public subroutine of_deleteall ()
end prototypes

public function any of_get (readonly long al_index);any ll_value

IF il_size > 0 THEN
	IF al_index > 0 AND al_index <= il_size THEN 
		ll_value = ia_array[al_index]
	ELSE
		SignalError(0, "The index of the array " + string(al_index)  + " is out of range from 1 to " + string(il_size) + ".")
	END IF
ELSE
	SignalError(0, "The array doesn't have any elements.")
END IF

RETURN ll_value

end function

public function integer of_add (readonly any aa_value);long ll_index

ll_index=il_size+1

IF ll_index > 0  THEN
	ia_array[ll_index] = aa_value
	
	il_size = ll_index
	
	RETURN ll_index
END IF

RETURN -1

end function

public function boolean of_set (readonly long al_index, readonly any aa_value);IF al_index > 0  THEN
	ia_array[al_index] = aa_value
	
	IF al_index > il_size THEN
		il_size = al_index
	END IF
	
	RETURN true
END IF

RETURN false


end function

public function any of_delete (readonly long al_index);long ll_index 
any ll_value
any al_old_value

ll_index = al_index 

IF ll_index > 0 AND ll_index <= il_size THEN
	al_old_value=ia_array[al_index] 
	DO WHILE ll_index < il_size
		ia_array[ll_index] = ia_array[ll_index + 1]
		ll_index += 1
	LOOP

	ia_array[ll_index] = ll_value
	il_size -= 1
	
END IF

RETURN al_old_value

end function

public subroutine of_deleteall ();any la_array[]

il_size = 0
ia_array = la_array
end subroutine

on n_vector.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_vector.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

