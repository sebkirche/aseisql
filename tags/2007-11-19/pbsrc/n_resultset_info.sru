HA$PBExportHeader$n_resultset_info.sru
forward
global type n_resultset_info from nonvisualobject
end type
end forward

global type n_resultset_info from nonvisualobject
end type
global n_resultset_info n_resultset_info

type variables
t_column_info it_col[]
long il_colcount //number of columns in the resultset
long il_rowcount //number of rows in the resultset

//information used for multi resultsets
long il_linehdr //the first line in the text for the header
long il_linerow //the first line in the text for the row of this resultset

string is_name

end variables
on n_resultset_info.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_resultset_info.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

