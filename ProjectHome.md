# ASEISQL : Sybase ASE isql : SQL Advantage replacement #
### Why? ###
As for me, the SQL Advantage is not handy. So I decide to create my own **ASEIsql**.

### Features ###
  * Unicode support (UTF8)
  * Marker management.
  * Folding: expand/collapse BEGIN-END sections.
  * SQL object context menu (like "Open procedure" if proc name is selected).
  * Trigger support
  * SQL Functions support (ASE 15)
  * Now Sybase debugger (sqldbgr) integrated


### Screenshot ###
![http://aseisql.googlecode.com/files/aseisql.gif](http://aseisql.googlecode.com/files/aseisql.gif)

### Known Issues ###
  * ASE ISQL will not connect to a Sybase database using the Sybase 15 client.
    * **Workaround:** In the Sybase 15 release, Sybase renamed libct.dll and libcs.dll to libsybct.dll and libsybcs.dll, respectively. Sybase has provided a batch command that will rename the files to pre-15 names. It's located in `c:\sybase_client_install_folder\locs-15_0\scripts` and the file name is `copylibs.bat`

### Whats New: ###
| **date** | **description** |
|:---------|:----------------|
| 2009-04-15 | ASEISQL going to be open-source! |

