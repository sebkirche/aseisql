HA$PBExportHeader$n_hashtable.sru
$PBExportComments$HashTable object. $Id: n_hashtable.sru,v 1.8 2003/05/20 12:28:17 lachinfophg Exp $
forward
global type n_hashtable from nonvisualobject
end type
type ost_element from structure within n_hashtable
end type
end forward

type ost_element from structure
	integer		flag
	unsignedlong		hash
	string		keytype
	any		key
	any		value
end type

global type n_hashtable from nonvisualobject
event uef_log ( )
end type
global n_hashtable n_hashtable

type variables
private ost_element ist_elements[] // array to store elements of the hashtable

public privatewrite long il_size // size of the array
public privatewrite long il_count // number of elements in hashtable (<= il_size)
public privatewrite long il_nonvoid // number of non void elements
public privatewrite double id_factor // resize factor

/*
Structure ost_element
	integer		flag  0 = empty, 1 = delete , 2 = full
	unsignedlong		hash hashcode
	string		keytype keytype (typeof)
	any		key key value
	fml_n_dw_srv		value item value
*/
end variables

forward prototypes
public function boolean of_delete (readonly any aa_key)
private function boolean of_extend (readonly long al_size)
private function any of_get (readonly any aa_key, readonly any aa_default)
public function blob of_get (readonly any aa_key, readonly blob aa_default)
public function boolean of_get (readonly any aa_key, readonly boolean aa_default)
public function date of_get (readonly any aa_key, readonly date aa_default)
public function datetime of_get (readonly any aa_key, readonly datetime aa_default)
public function decimal of_get (readonly any aa_key, readonly decimal aa_default)
public function double of_get (readonly any aa_key, readonly double aa_default)
public function powerobject of_get (readonly any aa_key, readonly powerobject aa_default)
public function string of_get (readonly any aa_key, readonly string aa_default)
public function time of_get (readonly any aa_key, readonly time aa_default)
public function any of_getfirstkey ()
public function any of_getnextkey (readonly any aa_key)
protected function unsignedlong of_hashcode (readonly string as_keytype, readonly any aa_key)
private function long of_index (readonly any aa_key)
public function boolean of_init ()
public function boolean of_init (readonly long al_total)
public function boolean of_init (readonly long al_total, readonly double ad_factor)
public function boolean of_keyexists (readonly any aa_key)
public function boolean of_rehash ()
public function boolean of_rehash (readonly boolean ab_optimize)
public subroutine of_set (readonly any aa_key, readonly any aa_value)
end prototypes

event uef_log();/*
$Log: n_hashtable.sru,v $
Revision 1.8  2003/05/20 12:28:17  lachinfophg
Datawindow Migration

Revision 1.7  2003/02/20 15:15:01  lachinfophg
log cvs

*/

end event

public function boolean of_delete (readonly any aa_key);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Delete the item at specified key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Delete(Any)</USAGE>

<ARGS>Any aa_key</ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index 
ulong lul_hash
string ls_keytype

IF il_count > 0 THEN
	ls_keytype = ClassName(aa_key)

	lul_hash = This.of_hashcode(ls_keytype, aa_key)
	ll_index = Mod(lul_hash, il_size) + 1
	
	DO UNTIL ist_elements[ll_index].flag = 0
		IF ist_elements[ll_index].hash = lul_hash THEN
			IF ist_elements[ll_index].keytype = ls_keytype THEN
				IF ist_elements[ll_index].key = aa_key THEN EXIT
			END IF	
		END IF
	
		ll_index = Mod(ll_index, il_size) + 1
	LOOP
	
	IF ist_elements[ll_index].flag = 2 THEN
		ist_elements[ll_index].flag = 1
		SetNull(ist_elements[ll_index].value)
					
		il_count -= 1
		
		RETURN TRUE
	END IF	
END IF

RETURN FALSE
end function

private function boolean of_extend (readonly long al_size);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Resize internal storage to the new size
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Extend(Long)</USAGE>

<ARGS>Long al_size</ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_i, ll_index
ost_element lst_elements[]

IF al_size > 0 THEN
	lst_elements[al_size].flag = 0	
	
	FOR ll_i = 1 TO il_size
		IF ist_elements[ll_i].flag = 2 THEN 
			ll_index = Mod(ist_elements[ll_i].hash, al_size) + 1
			
			DO UNTIL lst_elements[ll_index].flag = 0	
				ll_index = Mod(ll_index, al_size) + 1
			LOOP
			
			lst_elements[ll_index].flag = ist_elements[ll_i].flag
			lst_elements[ll_index].hash = ist_elements[ll_i].hash
			lst_elements[ll_index].keytype = ist_elements[ll_i].keytype
			lst_elements[ll_index].key = ist_elements[ll_i].key
			lst_elements[ll_index].value = ist_elements[ll_i].value
		END IF
	NEXT
		
	il_size = al_size
	il_nonvoid = il_count
	ist_elements = lst_elements   
	
	RETURN TRUE
END IF

RETURN FALSE
end function

private function any of_get (readonly any aa_key, readonly any aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Any [n_hashtable].of_Get(Any, Any)</USAGE>

<ARGS>Any aa_key
                    Any aa_default</ARGS>

<RETURN>Any</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index
ll_index=of_index(aa_key)
if ll_index >0 then return ist_elements[ll_index].value
return aa_default

end function

public function blob of_get (readonly any aa_key, readonly blob aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Blob [n_hashtable].of_Get(Any, Blob)</USAGE>

<ARGS>Any aa_key
                    Blob aa_default</ARGS>

<RETURN>Blob</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index
blob nullvalue
setNull(nullvalue)

ll_index=of_index(aa_key)
if ll_index >0 then 
	if isNull(ist_elements[ll_index].value) then return nullvalue
	return ist_elements[ll_index].value
end if
return aa_default

end function

public function boolean of_get (readonly any aa_key, readonly boolean aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Get(Any, Boolean)</USAGE>

<ARGS>Any aa_key
                    Boolean aa_default</ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/

long ll_index
boolean nullvalue
setNull(nullvalue)

ll_index=of_index(aa_key)
if ll_index >0 then 
	if isNull(ist_elements[ll_index].value) then return nullvalue
	return ist_elements[ll_index].value
end if
return aa_default

end function

public function date of_get (readonly any aa_key, readonly date aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Date [n_hashtable].of_Get(Any, Date)</USAGE>

<ARGS>Any aa_key
                    Date aa_default</ARGS>

<RETURN>Date</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/

long ll_index
ll_index=of_index(aa_key)
if ll_index >0 then return date(ist_elements[ll_index].value)
return aa_default

end function

public function datetime of_get (readonly any aa_key, readonly datetime aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Datetime [n_hashtable].of_Get(Any, Datetime)</USAGE>

<ARGS>Any aa_key
                    Datetime aa_default</ARGS>

<RETURN>Datetime</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/

long ll_index
ll_index=of_index(aa_key)
if ll_index >0 then return datetime(ist_elements[ll_index].value)
return aa_default

end function

public function decimal of_get (readonly any aa_key, readonly decimal aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Decimal [n_hashtable].of_Get(Any, Decimal)</USAGE>

<ARGS>Any aa_key
                    Decimal aa_default</ARGS>

<RETURN>Decimal</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index
ll_index=of_index(aa_key)
if ll_index >0 then return dec(ist_elements[ll_index].value)
return aa_default

end function

public function double of_get (readonly any aa_key, readonly double aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Double [n_hashtable].of_Get(Any, Double)</USAGE>

<ARGS>Any aa_key
                    Double aa_default</ARGS>

<RETURN>Double</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index
ll_index=of_index(aa_key)
if ll_index >0 then return double(ist_elements[ll_index].value)
return aa_default

end function

public function powerobject of_get (readonly any aa_key, readonly powerobject aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>PowerObject [n_hashtable].of_Get(Any, PowerObject)</USAGE>

<ARGS>Any aa_key
                    PowerObject aa_default</ARGS>

<RETURN>PowerObject</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index
powerobject nullvalue
setNull(nullvalue)

ll_index=of_index(aa_key)
if ll_index >0 then 
	if isNull(ist_elements[ll_index].value) then return nullvalue
	return ist_elements[ll_index].value
end if
return aa_default

end function

public function string of_get (readonly any aa_key, readonly string aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>String [n_hashtable].of_Get(Any, String)</USAGE>

<ARGS>Any aa_key
                    String aa_default</ARGS>

<RETURN>String</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index
ll_index=of_index(aa_key)
if ll_index >0 then return string(ist_elements[ll_index].value)
return aa_default

end function

public function time of_get (readonly any aa_key, readonly time aa_default);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the value at key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Time [n_hashtable].of_Get(Any, Time)</USAGE>

<ARGS>Any aa_key
                    Time aa_default</ARGS>

<RETURN>Time</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index
ll_index=of_index(aa_key)
if ll_index >0 then return time(ist_elements[ll_index].value)
return aa_default

end function

public function any of_getfirstkey ();/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Return first key in hashtable (use it to parse hashtable)
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Any [n_hashtable].of_Getfirstkey()</USAGE>

<ARGS></ARGS>

<RETURN>Any</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_i
any la_null

SetNull(la_null)

IF il_count > 0 THEN
	FOR ll_i = 1 TO il_size
		IF ist_elements[ll_i].flag = 2 THEN RETURN ist_elements[ll_i].key
	NEXT
END IF

RETURN la_null
end function

public function any of_getnextkey (readonly any aa_key);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Get the next key from specified one (usefull to parse hashtable)
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Any [n_hashtable].of_Getnextkey(Any)</USAGE>

<ARGS>Any aa_key</ARGS>

<RETURN>Any</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_i, ll_index
ulong lul_hash
string ls_keytype
any la_null

SetNull(la_null)

IF il_count > 0 THEN
	ls_keytype = ClassName(aa_key)

	lul_hash = This.of_hashcode(ls_keytype, aa_key)
	ll_index = Mod(lul_hash, il_size) + 1
	
	DO UNTIL ist_elements[ll_index].flag = 0
		IF ist_elements[ll_index].flag = 2 THEN
			IF ist_elements[ll_index].hash = lul_hash THEN
				IF ist_elements[ll_index].keytype  = ls_keytype THEN
					IF ist_elements[ll_index].key  = aa_key THEN
						FOR ll_i = ll_index + 1 TO il_size
							IF ist_elements[ll_i].flag = 2 THEN RETURN ist_elements[ll_i].key
						NEXT
						EXIT
					END IF
				END IF
			END IF
		END IF
		
		ll_index = Mod(ll_index, il_size) + 1
	LOOP
END IF

RETURN la_null
end function

protected function unsignedlong of_hashcode (readonly string as_keytype, readonly any aa_key);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Return hashcode of the key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>UnsignedLong [n_hashtable].of_Hashcode(String, Any)</USAGE>

<ARGS>String as_keytype
                    Any aa_key</ARGS>

<RETURN>UnsignedLong</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_i, ll_length
ulong lul_hash 
char lc_symbols[]

CHOOSE CASE as_keytype
	CASE "string"
		lc_symbols = string(aa_key)
		ll_length = UpperBound(lc_symbols)
	
		FOR ll_i = 1 TO ll_length
			lul_hash = (lul_hash + Asc(lc_symbols[ll_i])) * 31
		NEXT
	CASE "long"
		lul_hash = aa_key
	CASE ELSE
		SignalError(0, "Hash code is equal to zero for a " + Upper(as_keytype) + " data type.")
END CHOOSE

RETURN lul_hash
end function

private function long of_index (readonly any aa_key);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Returns index of key
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Long [n_hashtable].of_Index(Any)</USAGE>

<ARGS>Any aa_key</ARGS>

<RETURN>Long</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index 
ulong lul_hash
string ls_keytype

IF il_count > 0 THEN
	ls_keytype = ClassName(aa_key)

	lul_hash = This.of_hashcode(ls_keytype, aa_key)
	ll_index = Mod(lul_hash, il_size) + 1
	
	DO UNTIL ist_elements[ll_index].flag = 0
		IF ist_elements[ll_index].flag = 2 THEN
			IF ist_elements[ll_index].hash = lul_hash THEN
				IF ist_elements[ll_index].keytype = ls_keytype THEN
					IF ist_elements[ll_index].key = aa_key THEN RETURN ll_index
				END IF	
			END IF
		END IF
		
		ll_index = Mod(ll_index, il_size) + 1
	LOOP
END IF

RETURN 0

end function

public function boolean of_init ();/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Initialize with 75 elements
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Init()</USAGE>

<ARGS></ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
return of_init(75)

end function

public function boolean of_init (readonly long al_total);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Initialize with al_total elements and filling factor of 0.75%
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Init(Long)</USAGE>

<ARGS>Long al_total</ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
RETURN This.of_init(al_total, 0.75)
end function

public function boolean of_init (readonly long al_total, readonly double ad_factor);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Initialize with al_total elements and filling factor of ad_factor%
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Init(Long, Double)</USAGE>

<ARGS>Long al_total
                    Double ad_factor</ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
ost_element lst_elements[]

IF al_total > 0 AND ad_factor > 0 AND ad_factor < 1 THEN
	il_size = (al_total / ad_factor) + 1
	id_factor = ad_factor
	
	il_count = 0
	il_nonvoid = 0
	ist_elements = lst_elements 
	
	ist_elements[il_size].flag = 0

	RETURN TRUE
END IF

RETURN FALSE
end function

public function boolean of_keyexists (readonly any aa_key);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Determine if key exists
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Keyexists(Any)</USAGE>

<ARGS>Any aa_key</ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
RETURN of_index(aa_key)>0

end function

public function boolean of_rehash ();/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Rehash table
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Rehash()</USAGE>

<ARGS></ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
RETURN This.of_rehash(FALSE)
end function

public function boolean of_rehash (readonly boolean ab_optimize);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Rehashg table
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>Boolean [n_hashtable].of_Rehash(Boolean)</USAGE>

<ARGS>Boolean ab_optimize</ARGS>

<RETURN>Boolean</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
IF ab_optimize THEN
	IF id_factor > 0 AND id_factor < 1 THEN
		RETURN This.of_extend((il_count / id_factor) + 1)
	END IF
	
	RETURN FALSE
ELSE
	RETURN This.of_extend(il_size)
END IF
end function

public subroutine of_set (readonly any aa_key, readonly any aa_value);/*********************************************************************
<AUTH>LC - Laurent CHASTEL - FM Logistic - FM2i - Entrep$$HEX1$$4404$$ENDHEX$$t Opale 2000 </AUTH>

<DESC>Add a element in hashtable
     <TODO>
     </TODO>
</DESC>
  
<ACCESS>public </ACCESS>

<USAGE>(none) [n_hashtable].of_Set(Any, Any)</USAGE>

<ARGS>Any aa_key
                    Any aa_value</ARGS>

<RETURN>(none)</RETURN>

Date :  25/03/2003
	
Log		:
...Date.....Auteur..................Objet............................
_____________________________________________________________________

********************************************************************/
long ll_index 
ulong lul_hash
string ls_keytype

IF il_size = 0 THEN This.of_init()

ls_keytype = ClassName(aa_key)

lul_hash = This.of_hashcode(ls_keytype, aa_key)
ll_index = Mod(lul_hash, il_size) + 1
	
DO UNTIL ist_elements[ll_index].flag = 0
	IF ist_elements[ll_index].hash = lul_hash THEN
		IF ist_elements[ll_index].keytype = ls_keytype THEN
			IF ist_elements[ll_index].key = aa_key THEN EXIT
		END IF	
	END IF
	
	ll_index = Mod(ll_index, il_size) + 1
LOOP

CHOOSE CASE ist_elements[ll_index].flag
	CASE 0
		il_count += 1
		il_nonvoid += 1
	
		ist_elements[ll_index].flag = 2
		ist_elements[ll_index].hash = lul_hash
		ist_elements[ll_index].keytype = ls_keytype
		ist_elements[ll_index].key = aa_key
		ist_elements[ll_index].value = aa_value
		
		IF il_nonvoid > il_size * id_factor THEN This.of_extend(il_size * 2 + 1)
	CASE 1
		il_count += 1
		
		ist_elements[ll_index].flag = 2
		ist_elements[ll_index].value = aa_value
	CASE 2
		ist_elements[ll_index].value = aa_value
END CHOOSE
end subroutine

on n_hashtable.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_hashtable.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

