HA$PBExportHeader$n_asql.sru
$PBExportComments$VV: analysis sql code
forward
global type n_asql from nonvisualobject
end type
end forward

shared variables
string s_textin
string s_textout
char c_textin[]

long l_textlen

string s_begin = 'begin'
string s_end = 'end'

string s_tab = '~t'
string s_n = '~n'
string s_r = '~r'
string s_newline = '~r~n'
string s_space = ' '

string reservedlist[] = {	'alter', &
									'as', &
									'begin', &
									'case ', &
									'close', &
									'commit', &
									'convert', &
									'create', &
									'deallocate', &
									'declare', &
									'delete', &
									'drop', &
									'end', &
									'exec', &
									'execute', &
									'fetch', &
									'go', &
									'goto', &
									'grant', &
									'if', &
									'insert', &
									'into', &
									'open', &
									'print', &
									'return', &
									'rollback', &
									'save', &
									'select', &
									'use', &
									'waitfor', &
									'while'}

end variables

global type n_asql from nonvisualobject
end type
global n_asql n_asql

type variables
hprogressbar progressbar
end variables

forward prototypes
protected function integer of_kindofsymb (string fa_symb)
protected function integer of_prbar ()
protected function string of_getlex (long fa_start)
public function integer of_reservedlist (string fa_word)
protected subroutine of_analysis ()
protected subroutine of_init (readonly string fa_data)
public function string of_format (readonly string fa_text)
public function character of_char (long i)
end prototypes

protected function integer of_kindofsymb (string fa_symb);/*letter -  return 1*/
/*digit -  return 2*/
/*other symbol -  return 0*/
IF (65 <= Asc(fa_symb) and Asc(fa_symb) <= 90) or &
(97 <= Asc(fa_symb) and Asc(fa_symb) <= 122) or &
(192 <= Asc(fa_symb) and Asc(fa_symb) <= 214) or &
(216 <= Asc(fa_symb) and Asc(fa_symb) <= 246) or &
(248 <= Asc(fa_symb) and Asc(fa_symb) <= 254) THEN return 1
IF (48 <= Asc(fa_symb) and Asc(fa_symb) <= 57) THEN return 2
return 0
end function

protected function integer of_prbar ();if IsValid(progressbar) = true then return 1
return 0
end function

protected function string of_getlex (long fa_start);/*This function get the word since the position fa_start*/
string ls_lex = ''
long ll_i
ll_i = fa_start

DO WHILE (ll_i <= l_textlen) and (of_kindofsymb(string(c_textin[ll_i])) = 0)
	if ll_i = l_textlen then exit
	if ll_i <= l_textlen then ll_i ++
LOOP

DO WHILE (ll_i <= l_textlen) and (of_kindofsymb(string(c_textin[ll_i])) <> 0)
	ls_lex += Lower(string(c_textin[ll_i]))
	//ls_lex += string(c_textin[ll_i])
	if ll_i = l_textlen then exit
	if ll_i < l_textlen then ll_i++
LOOP

return ls_lex
end function

public function integer of_reservedlist (string fa_word);integer ll_i, ll_l
ll_i = 1
ll_l = UpperBound (reservedlist)
DO WHILE (ll_i <= ll_l)
	if Lower(fa_word) = reservedlist[ll_i] then return 1
	ll_i++
LOOP
return 0
end function

protected subroutine of_analysis ();long ll_insert, ll_notab, ll_tabcount = 1
long ll_current
string ls_char, ls_char1, ls_char2, ls_char3, ls_char4, ls_char5, ls_last3, ls_last5, ls_char6, ls_char7, ls_lastlex
string ls_mode = 'default' // values = string1 ('), string2 ("), comment (/*), commentline (--)
integer li_comment = 0
boolean lb_newline = false, lb_multilinecomment = false

if of_prbar() = 1 then ProgressBar.position = 1
if of_prbar() = 1 then ProgressBar.maxposition = l_textlen 

s_textout = ''
ls_char6 = ''
ls_char5 = ''
ls_char4 = ''
ls_char3 = ''
ls_char2 = ''
ls_char1 = ''
ls_char = ''
ll_current = 1

DO WHILE ll_current <= l_textlen
	
	//last six symbols
	ls_char6 = ls_char5
	ls_char5 = ls_char4
	ls_char4 = ls_char3
	ls_char3 = ls_char2
	ls_char2 = ls_char1
	ls_char1 = ls_char
	ls_char = c_textin[ll_current] 
	ls_last5 = ls_char5 + ls_char4 + ls_char3 + ls_char2 +ls_char1
	ls_last3 = ls_char3 + ls_char2 +ls_char1
	
	//MessageBox(string(ll_current), ls_char)
	//if ls_char = '~n' then MessageBox(String(ll_current), 'n')
	//if ls_char = '~r' then MessageBox(String(ll_current), 'r')
	//def. new line
	if (ls_char1 = '~n') or (ls_char1 = '') THEN lb_newline = true ELSE	lb_newline = false

	// select mode: default/string1/string2/comment/commentline 
	CHOOSE CASE ls_mode
	CASE 'default'
		IF (Lower(ls_last5) = s_begin) and of_kindofsymb(string(ls_char)) = 0 and of_kindofsymb(string(ls_char6)) = 0 and of_getlex(ll_current)<>'tran' then ll_tabcount ++
		IF (Lower(ls_last3) = s_end) and of_kindofsymb(string(ls_char)) = 0 and of_kindofsymb(string(ls_char4)) = 0 then ll_tabcount --
//		IF (ls_last5 = s_begin) and (ls_char = ' ' or ls_char = '~n' or ls_char = '~r' or ls_char = '/') &
//		and ((ls_char6 = ' ') or (ls_char6 = '') or (ls_char6 = '~n') or (ls_char6 = '~r') or (ls_char6 = '/')) &
//		and of_getlex(ll_current)<>'tran' then ll_tabcount ++
//		IF (ls_last3 = s_end) and (ls_char = ' ' or ls_char = '~n' or ls_char = '~r' or ls_char = '/')&
//		and ((ls_char4 = ' ') or (ls_char4 = '') or (ls_char4 = '~n') or (ls_char4 = '~r') or (ls_char4 = '/')) &
//		then ll_tabcount --
		
		IF (ls_char2 = '/') and (ls_char1 = '*') THEN
			ls_mode = 'comment'
			li_comment  = 1
		END IF
		IF (ls_char2 = '-') and (ls_char1 = '-') THEN 
			ls_mode = 'commentline'
		END IF
//		IF (ls_char3 = '/') and (ls_char2 = '*') and (ls_char1 = '*') THEN 
//			ls_mode = 'multilinecomment'
//		END IF
		IF (ls_char1 = "'") THEN ls_mode = 'string1'
		IF (ls_char1 = '"') THEN ls_mode = 'string2'
	CASE 'comment'
		IF (ls_char2 = '*') THEN lb_multilinecomment = true
		IF (ls_char2 = '/') and (ls_char1 = '*') THEN li_comment ++
		IF (ls_char2 = '*') and (ls_char1 = '/') and (ls_char3 <> '/') THEN li_comment --
		IF li_comment = 0 THEN 
			ls_mode = 'default'
			lb_multilinecomment = false
		END IF
	CASE 'commentline'
		IF /*(ls_char2 = '~r') and*/ (ls_char1 = '~n') THEN ls_mode = 'default'
	CASE 'string1'
		IF (ls_char1 = "'") THEN ls_mode = 'default'
	CASE 'string2'
		IF (ls_char1 = '"') THEN ls_mode = 'default'
	END CHOOSE	
	
	// skip tabs and spaces on the begin of the line
	IF ((ls_char = ' ') or (ls_char = '~t')) and lb_newline = true THEN
		DO WHILE ((ls_char = ' ') or (ls_char = '~t'))
		ll_current ++
		ls_char = c_textin[ll_current] 
		LOOP	
	END IF
	
	//Insert tabs
	//tabcount-- befor 'end'
	// "/**"
	IF lb_newline = true THEN
		ll_notab = 0
		//IF of_getlex(ll_current) = s_end and ls_char = 'e' THEN ll_notab = 1 else ll_notab = 0
		IF of_reservedlist(of_getlex(ll_current)) = 1 THEN ll_notab = 1
		IF ls_char = '/' and of_char(ll_current+1) = '*' THEN ll_notab = 1
		IF ls_char = '*' THEN ll_notab = 1
		IF ls_char = '-' and of_char(ll_current+1) = '-' THEN ll_notab = 1
		if ll_current+2<=l_textlen then
			IF ls_char = '/' and of_char(ll_current+1) = '*' and of_char(ll_current+2) = '*' THEN lb_multilinecomment = true
		end if
		IF of_getlex(ll_current) = s_end and Lower(ls_char) = 'e' THEN ll_notab = 2
		IF lb_multilinecomment = false THEN
			FOR ll_insert = 1 TO ll_tabcount - ll_notab
				s_textout += s_tab
			NEXT
		END IF
	END IF
	
	//remove trailing blanks
	if (ls_char = '~n' or ls_char = '~r') and right(s_textout,1)=' ' then
		s_textout = righttrim(s_textout)
	end if
	
	if ls_char = '~n' and (ls_char1 <> '~r') then
		s_textout += '~r'
		lb_newline = true
	end if
	
	s_textout += ls_char
	ll_current ++

	if of_prbar() = 1 then ProgressBar.position =  ll_current

LOOP
if right(s_textout,1)=' ' then s_textout = righttrim(s_textout)

end subroutine

protected subroutine of_init (readonly string fa_data);s_textin = fa_data
l_textlen = len(s_textin)
c_textin[l_textlen+1] = '' 
c_textin = s_textin /*write string to array of char*/

end subroutine

public function string of_format (readonly string fa_text);/*Main function*/
/*Run other functions*/
this.of_init (fa_text) /*Init data*/
this.of_analysis() /*Anlysis data*/
return s_textout /*return result*/
end function

public function character of_char (long i);if i<0 or i>l_textlen then return ''
return c_textin[i]
end function

on n_asql.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_asql.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

