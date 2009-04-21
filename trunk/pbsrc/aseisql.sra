HA$PBExportHeader$aseisql.sra
$PBExportComments$Generated Application Object
forward
global type aseisql from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_config_ase cfg
n_history history
n_sqlmenu gn_sqlmenu
n_unicode gn_unicode

end variables

global type aseisql from application
string appname = "aseisql"
string displayname = "ASE isql"
end type
global aseisql aseisql

type prototypes

end prototypes

type variables

end variables

on aseisql.create
appname="aseisql"
message=create message
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on aseisql.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gn_unicode=create n_unicode
cfg=create n_config_ase
cfg.of_options(false) //load options
history=create n_history
gn_sqlmenu=create n_sqlmenu
randomize(0)

open(w_main)

end event

event close;//history.of_store()
destroy gn_sqlmenu
destroy history
destroy cfg
destroy gn_unicode

disconnect;

end event

event systemerror;string ls_msg

ls_msg+='System error #'+string(error.number)+' has been occured:~r~n~r~n'
ls_msg+=error.text+'~r~n~r~n'
ls_msg+='Object: '
if error.object=error.windowMenu then
        ls_msg+=error.object
else
        ls_msg+=error.windowMenu+'.'+error.object
end if
ls_msg+='~r~n'
ls_msg+='Script: '+error.ObjectEvent+'~r~n'
ls_msg+='Line: '+String(error.line)+'~r~n'
ls_msg+='~r~n'
ls_msg+='Do you want to continue?'

if MessageBox(displayname,ls_msg,StopSign!,YesNo!,2)=2 then Halt close

end event

