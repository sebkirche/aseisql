;

Name "ASE ISQL"

OutFile "AseIsqlSetup.exe"

SetCompressor lzma
Icon "install.ico"

; The default installation directory
InstallDir $PROGRAMFILES\AseIsql

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "SOFTWARE\FM2i\AseIsql" ""

; Pages

Page components

Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles



Section "ASE ISQL"
	SectionIn RO
	SetShellVarContext all
	SetOutPath $INSTDIR
	
	SetOverwrite on
	File "..\..\exe\*.dll"
	File "..\..\exe\*.exe"
	File "..\..\exe\*.hlp"
	File "..\..\exe\*.pbd"
	File "..\..\exe\stubs.sql"
	SetOverwrite off
	File "..\..\exe\ustubs.sql"
	SetOverwrite on
	
	CreateShortCut "$SMPROGRAMS\Sybase\ASE ISQL.lnk" "$INSTDIR\aseisql.exe"
	
	
	WriteRegStr HKCR ".sql" "" "SQL_auto_file"
	WriteRegStr HKCR ".pro" "" "PRO_auto_file"
	WriteRegStr HKCR "SQL_auto_file\shell\open\command" "" '"$INSTDIR\aseisql.exe" "%1"'
	WriteRegStr HKCR "PRO_auto_file\shell\open\command" "" '"$INSTDIR\aseisql.exe" "%1"'
	
	WriteRegStr HKCR ".sws" "" "SWS_auto_file"
	WriteRegStr HKCR ".sws" "InfoTip" "ASE Isql workspace"
	WriteRegStr HKCR "SWS_auto_file\shell\open\command" "" '"$PROGRAMFILES\aseisql\aseisql.exe" "%1"'

	WriteRegStr HKCU "Software\Classes\Applications\aseisql.exe\shell\open\command" "" '"$INSTDIR\aseisql.exe" "%1"'

	; Write the installation path into the registry
	WriteRegStr HKLM "Software\FM2i\AseIsql" "" "$INSTDIR"

	;Create uninstaller
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ASE ISQL" "DisplayName" "ASE ISQL"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ASE ISQL" "UninstallString" '"$INSTDIR\Uninstall.exe"'
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ASE ISQL" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ASE ISQL" "NoRepair" 1
	WriteUninstaller "$INSTDIR\Uninstall.exe"
		
SectionEnd ; end the section

Section "Desktop shortcut"
	SetShellVarContext all
	CreateShortCut "$DESKTOP\ASE ISQL.lnk" "$INSTDIR\aseisql.exe"
SectionEnd

Section "Quick Launch shortcut"
	SetShellVarContext all
	CreateShortCut "$QUICKLAUNCH\ASE ISQL.lnk" "$INSTDIR\aseisql.exe"
SectionEnd

Section "Overwrite ustubs.sql" CopyUstubs
	SetShellVarContext all
	CopyFiles /FILESONLY "$EXEDIR\ustubs.sql" "$INSTDIR\ustubs.sql"
SectionEnd

Function .onInit
	IfFileExists $EXEDIR\ustubs.sql +2 0
	SectionSetFlags ${CopyUstubs} 16

FunctionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
	SetShellVarContext all
	; Remove registry keys
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ASE ISQL"

	DeleteRegKey HKLM "SOFTWARE\FM2i\aseisql"
	DeleteRegKey HKCU "SOFTWARE\FM2i\aseisql"
	DeleteRegKey HKCU "Software\Classes\Applications\aseisql.exe\shell\open\command"
	WriteRegStr HKCR "SQL_auto_file\shell\open\command" "" '"notepad.exe" "%1"'
	WriteRegStr HKCR "PRO_auto_file\shell\open\command" "" '"notepad.exe" "%1"'
	
	; Remove files and uninstaller
	RMDir /r $INSTDIR
	Delete "$DESKTOP\ASE ISQL.lnk"
	Delete "$QUICKLAUNCH\ASE ISQL.lnk"
	Delete "$SMPROGRAMS\Sybase\ASE ISQL.lnk"

SectionEnd
