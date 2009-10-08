--THIS FILE IS RESERVED FOR STANDARD STUFF.
-- IF YOU NEED TO ADD HERE SOMETHING PLEASE INFORM ME BY EMAIL dlukyanov@ukr.net
--Macros:
--  %SERVER%     current server name
--  %DATABASE%   current database name
--  %DATE006%       current local time in format DD MON YY
--  %USERNAME%   user name (windows login)
--  %SELB%   selection begin //new parameter supported only by "insert stub" command
--  %SELE%   selection end 
--  %PARM:Parameter name%   user will be prompted for this parameter

--<General\Set>--
--<General\Set\ansinull {on | off}>--
set ansinull {on | off}
--<General\Set\ansi_permissions {on | off}>--
set ansi_permissions {on | off}
--<General\Set\arithabort>--
set arithabort [arith_overflow | numeric_truncation] {on | off}
--<General\Set\arithignore [arith_overflow] {on | off}>--
set arithignore [arith_overflow] {on | off}
--<General\Set\chained {on | off}>--
set chained {on | off}
--<General\Set\close on endtran {on | off}>--
set close on endtran {on | off}
--<General\Set\char_convert>--
set char_convert {off | on [ [charset] with {error | no_error}] }
--<General\Set\cis_rpc_handling {on | off}>--
set cis_rpc_handling {on | off}
--<General\Set\clientname <client_name>>--
set clientname <client_name>
--<General\Set\clienthostname <host_name>>--
set clienthostname <host_name>
--<General\Set\clientapplname <application_name>>--
set clientapplname <application_name>
--<General\Set\cursor rows <number> for <cursor_name>>--
set cursor rows <number> for <cursor_name>
--<General\Set\datefirst <number>>--
set datefirst <number>
--<General\Set\dateformat <format>>--
set dateformat <format>
--<General\Set\fipsflagger {on | off}>--
set fipsflagger {on | off}
--<General\Set\flushmessage {on | off}>--
set flushmessage {on | off}
--<General\Set\forceplan {on | off}>--
set forceplan {on | off}
--<General\Set\identity_insert>--
set identity_insert <table_name> {on | off}
--<General\Set\jtc {on | off}>--
set jtc {on | off}
--<General\Set\language <language>>--
set language <language>
--<General\Set\lock { wait [ numsecs ] | nowait } >--
set lock { wait [ numsecs ] | nowait } 
--<General\Set\nocount {on | off}>--
set nocount {on | off}
--<General\Set\noexec {on | off}>--
set noexec {on | off}
--<General\Set\offsets>--
set offsets {select, from, order, compute, table, procedure, statement, param, execute} {on | off}
--<General\Set\parallel_degree <number>>--
set parallel_degree <number>
--<General\Set\plan dump [group_name] {on | off}>--
set plan dump [group_name] {on | off}
--<General\Set\plan load [group_name] {on | off}>--
set plan load [group_name] {on | off}
--<General\Set\plan exists check {on | off}>--
set plan exists check {on | off}
--<General\Set\plan replace {on | off}>--
set plan replace {on | off}
--<General\Set\parseonly {on | off}>--
set parseonly {on | off}
--<General\Set\prefetch [on|off]>--
set prefetch [on|off]
--<General\Set\process_limit_action>--
set process_limit_action {abort | quiet | warning}
--<General\Set\procid {on | off}>--
set procid {on | off}
--<General\Set\proxy <login_name>>--
set proxy <login_name>
--<General\Set\quoted_identifier {on | off}>--
set quoted_identifier {on | off}
--<General\Set\role>--
set role {"sa_role" | "sso_role" | "oper_role" | role_name [with passwd "password"]} {on | off}
--<General\Set\rowcount <number>>--
set rowcount <number>
--<General\Set\self_recursion {on | off}>--
set self_recursion {on | off}
--<General\Set\scan_parallel_degree <number>>--
set scan_parallel_degree <number>
--<General\Set\session authorization <login_name>>--
set session authorization <login_name>
--<General\Set\showplan {on | off}>--
set showplan {on | off}
--<General\Set\sort_resources {on | off}>--
set sort_resources {on | off}
--<General\Set\sort_merge {on | off}>--
set sort_merge {on | off}
--<General\Set\statistics io {on | off}>--
set statistics io {on | off}
--<General\Set\statistics simulate { on | off }>--
set statistics simulate { on | off }
--<General\Set\statistics subquerycache {on | off}>--
set statistics subquerycache {on | off}
--<General\Set\statistics time {on | off}>--
set statistics time {on | off}
--<General\Set\strict_dtm_enforcement {on | off}>--
set strict_dtm_enforcement {on | off}
--<General\Set\string_rtruncation {on | off}>--
set string_rtruncation {on | off}
--<General\Set\table count number>--
set table count number
--<General\Set\textsize {number}>--
set textsize {number}
--<General\Set\transaction isolation level>--
set transaction isolation level { 
	[ read uncommitted | 0 ] | 
	[ read committed | 1 ] | 
	[ repeatable read | 2 ]| 
	[ serializable | 3 ] } 
--<General\Set\transactional_rpc {on | off}>--
set transactional_rpc {on | off}

--<General\Statements\case>--
 case when logical_expr then expr else expr_def end 
--<General\Statements\if>--
 if logical_expr statement 
--<General\Statements\if-begin-end>--
 
if logical_expr begin
	statement
end

--<General\Statements\while>--
 while logical_expr statement 
--<General\Statements\while-begin-end>--
while logical_expr begin
	statement
end
--<Variables\Global>--
--<Variables\Global\@@cis_version>--
@@cis_version /*version of Component Integration Services*/
--<Variables\Global\@@guestuserid>--
@@guestuserid /*The guest user ID. The value is 2.*/
--<Variables\Global\@@invaliduserid>--
@@invaliduserid /*The ID for an invalid user. The value is -1*/
--<Variables\Global\@@max_connections>--
@@max_connections /*Contains the maximum number of simultaneous connections*/
--<Variables\Global\@@mingroupid>--
@@mingroupid /*Lowest group user ID*/
--<Variables\Global\@@minsuid>--
@@minsuid /*Minimum server user ID*/
--<Variables\Global\@@minuserid>--
@@minuserid /*Lowest user ID*/
--<Variables\Global\@@maxgroupid>--
@@maxgroupid /*Highest group user ID*/
--<Variables\Global\@@maxuserid>--
@@maxuserid /*The highest user ID*/
--<Variables\Global\@@probesuid>--
@@probesuid /*The probe user ID*/
--<Variables\Global\@@procid>--
@@procid /*Contains the stored procedure ID of the currently executing procedure. */
--<Variables\Global\@@servername>--
@@servername /*the name of this Adaptive Server*/
--<Variables\Global\@@spid>--
@@spid /*Contains the server process ID number of the current process. */
--<Variables\Global\@@thresh_hysteresis>--
@@thresh_hysteresis /*the decrease in free space required to activate a threshold*/
--<Variables\Global\@@timeticks>--
@@timeticks /*Contains the number of microseconds per tick*/
--<Variables\Global\@@version>--
@@version /*Contains the date of the current release of server.*/
--<Variables\Transactional\@@error>--
@@error /*error status of the most recently executed command*/
--<Variables\Transactional\@@identity>--
@@identity /*last value inserted into an IDENTITY column*/
--<Variables\Transactional\@@nestlevel>--
@@nestlevel /*contains the nesting level of SP or trigger calls*/
--<Variables\Transactional\@@sqlstatus>--
@@sqlstatus /*status information resulting from the last fetch*/
--<Variables\Transactional\@@sqlstatus\0 ok>--
0
--<Variables\Transactional\@@sqlstatus\1 error>--
1
--<Variables\Transactional\@@sqlstatus\2 no more data>--
2
--<Variables\Transactional\@@trancount>--
@@trancount /*contains the nesting level of transactions*/
--<Variables\Transactional\@@transtate>--
@@transtate /*the current state of a transaction*/
--<Variables\Transactional\@@transtate\0 ok, in process>--
0
--<Variables\Transactional\@@transtate\1 ok, succeeded>--
1
--<Variables\Transactional\@@transtate\2 statement aborted>--
2
--<Variables\Transactional\@@transtate\3 transaction aborted>--
3
--<Variables\Session Options\@@isolation>--
@@isolation /*current isolation level*/
--<Variables\Session Options\@@options>--
@@options /*Contains a session's set options*/
--<Variables\Session Options\@@options\4 (0x04) showplan>--
4 
--<Variables\Session Options\@@options\5 (0x05) noexec>--
5 
--<Variables\Session Options\@@options\6 (0x06) arithignore>--
6
--<Variables\Session Options\@@options\8 (0x08) arithabort>--
8 
--<Variables\Session Options\@@options\13 (0x0D) control>--
13 
--<Variables\Session Options\@@options\14 (0x0E) offsets>--
14 
--<Variables\Session Options\@@options\15 (0x0F) statistics io and statistics time>--
15 
--<Variables\Session Options\@@options\16 (0x10) parseonly>--
16 
--<Variables\Session Options\@@options\18 (0x12) procid>--
18 
--<Variables\Session Options\@@options\20 (0x14) rowcount>--
20 
--<Variables\Session Options\@@options\23 (0x17) nocount>--
23 
--<Variables\Session Options\@@rowcount>--
@@rowcount /*the number of rows affected by the last query*/
--<Variables\Session Options\@@textsize>--
@@textsize /*the limit on the number of bytes of text or image data a select returns*/
--<Variables\Session Options\@@tranchained>--
@@tranchained /*0 for unchained or 1 for chained*/
--<Variables\Session Options\@parallel_degree>--
@parallel_degree /*the current maximum parallel degree setting.*/
--<Variables\Session Options\@scan_parallel_degree>--
@scan_parallel_degree /*the current maximum parallel degree setting for nonclustered index scans*/
--<Variables\Language and CharSets\@@char_convert>--
@@char_convert /*0=off 1=on*/
--<Variables\Language and CharSets\@@client_csid>--
@@client_csid /*client's character set ID*/
--<Variables\Language and CharSets\@@client_csname>--
@@client_csname /*client's character set name*/
--<Variables\Language and CharSets\@@langid>--
@@langid /*local language ID*/
--<Variables\Language and CharSets\@@language>--
@@language /*the name of the language*/
--<Variables\Language and CharSets\@@maxcharlen>--
@@maxcharlen /*the maximum length, in bytes, of multibyte characters in the default character set*/
--<Variables\Language and CharSets\@@ncharsize>--
@@ncharsize /*the average length, in bytes, of a national character*/
--<Variables\System activity\@@connections>--
@@connections /*Contains the number of logins or attempted logins. */
--<Variables\System activity\@@cpu_busy>--
@@cpu_busy /*the amount of time, in ticks, that the CPU has spent doing Adaptive Server work since the last time Adaptive Server was started. */
--<Variables\System activity\@@idle>--
@@idle /*Contains the amount of time, in ticks, that Adaptive Server has been idle since it was last started. */
--<Variables\System activity\@@io_busy>--
@@io_busy /*Contains the amount of time, in ticks, that Adaptive Server has spent doing input and output operations. */
--<Variables\System activity\@@packet_errors>--
@@packet_errors /*Contains the number of errors that occurred while Adaptive Server was sending and receiving packets. */
--<Variables\System activity\@@pack_received>--
@@pack_received /*Contains the number of input packets read by Adaptive Server since it was last started. */
--<Variables\System activity\@@pack_sent>--
@@pack_sent /*Contains the number of output packets written by Adaptive Server since it was last started. */
--<Variables\System activity\@@total_errors>--
@@total_errors /*Contains the number of errors that occurred while Adaptive Server was reading or writing. */
--<Variables\System activity\@@total_read>--
@@total_read /*the number of disk reads by Adaptive Server since it was last started. */
--<Variables\System activity\@@total_write>--
@@total_write /*the number of disk writes by Adaptive Server since it was last started. */
--<Variables\Text pointer info\@@textcolid>--
@@textcolid /*Contains the column ID of the column referenced by @@textptr.*/
--<Variables\Text pointer info\@@textdbid>--
@@textdbid /*Contains the database ID of a database containing an object with the column referenced by @@textptr. */
--<Variables\Text pointer info\@@textobjid>--
@@textobjid /*Contains the object ID of an object containing the column referenced by @@textptr. */
--<Variables\Text pointer info\@@textpt>--
@@textpt /*the text pointer of the last inserted or updated text/image column*/
--<Variables\Text pointer info\@@textts>--
@@textts /*the text timestamp of the column referenced by @@textptr. */



--<General\Cursor>--
 
declare %PARM:Cursor name% cursor for 
%SELB%select_statement%SELE%

open %PARM:Cursor name%
fetch %PARM:Cursor name% into @var,...
while @@sqlstatus=0 begin
	--processing selected row
	fetch %PARM:Cursor name% into @var,...
end
close %PARM:Cursor name%
deallocate cursor %PARM:Cursor name%

--<General\select *>--
 select * from %SELB%
	where 
--<General\select count(*)>--
 select count(*) from %SELB% 
	where 
--<General\select simple>--
select distinct select_list 
	from table_names
	where search_conditions
		and ...
	group by aggregate_free_expressions
	having group_search_conditions
	order by columns

--<General\Select full>--
 
select [all | distinct] select_list 
[into [[database.]owner.]table_name] 
[from [[database.]owner.]{view_name|table_name
    [(index {index_name | table_name } 
        [parallel [degree_of_parallelism]]
        [prefetch size ][lru|mru])]}
    [holdlock | noholdlock] [shared]
 [,[[database.]owner.]{view_name|table_name
    [(index {index_name | table_name } 
        [parallel [degree_of_parallelism]]
        [prefetch size ][lru|mru])]}
     [holdlock | noholdlock] [shared]]... ] 
 
[where search_conditions] 
 
[group by [all] aggregate_free_expression
    [, aggregate_free_expression]... ]
[having search_conditions]
 
[order by 
{[[[database.]owner.]{table_name.|view_name.}]
    column_name | select_list_number | expression}
        [asc | desc]
[,{[[[database.]owner.]{table_name|view_name.}]
    column_name | select_list_number | expression} 
        [asc | desc]]...]
 
[compute row_aggregate(column_name)
        [, row_aggregate(column_name)]...
    [by column_name [, column_name]...]] 
 
[for {read only | update [of column_name_list]}]
 
[at isolation {read uncommitted | read committed |
     serializable}]
 
[for browse]

--<Functions\Aggregate\avg>--
 avg([all | distinct] expression) /*numeric average*/ 
--<Functions\Aggregate\count>--
 count([all | distinct] expression) /*number of (distinct) non-null values*/ 
--<Functions\Aggregate\max>--
 max(expression)  
--<Functions\Aggregate\min>--
 min(expression)  
--<Functions\Aggregate\sum>--
 sum([all | distinct] expression) 
--<Functions\Conversion>--
--<Functions\Conversion\convert>--
 convert (datatype [(length) | (precision[, scale])], expression[, style]) 
--<Functions\Conversion\convert\styles>--
--<Functions\Conversion\convert\styles\mon dd yyyy hh:mi AM/PM>--
 100 /*mon dd yyyy hh:mi AM/PM*/
--<Functions\Conversion\convert\styles\mm/dd/yy>--
 1 /*mm/dd/yy*/ 
--<Functions\Conversion\convert\styles\mm/dd/yyyy>--
 101 /*mm/dd/yyyy*/ 
--<Functions\Conversion\convert\styles\yy.mm.dd>--
 2 /*yy.mm.dd*/ 
--<Functions\Conversion\convert\styles\yyyy.mm.dd>--
 102 /*yyyy.mm.dd*/ 
--<Functions\Conversion\convert\styles\dd/mm/yy>--
 3 /*dd/mm/yy*/ 
--<Functions\Conversion\convert\styles\dd/mm/yyyy>--
 103 /*dd/mm/yyyy*/ 
--<Functions\Conversion\convert\styles\dd.mm.yy>--
 4 /*dd.mm.yy*/ 
--<Functions\Conversion\convert\styles\dd.mm.yyyy>--
 104 /*dd.mm.yyyy*/ 
--<Functions\Conversion\convert\styles\dd-mm-yy>--
 5 /*dd-mm-yy*/ 
--<Functions\Conversion\convert\styles\dd-mm-yyyy>--
 105 /*dd-mm-yyyy*/ 
--<Functions\Conversion\convert\styles\dd mon yy>--
 6 /*dd mon yy*/ 
--<Functions\Conversion\convert\styles\dd mon yyyy>--
 106 /*dd mon yyyy*/ 
--<Functions\Conversion\convert\styles\mon dd, yy>--
 7 /*mon dd, yy*/ 
--<Functions\Conversion\convert\styles\mon dd, yyyy>--
 107/*mon dd, yyyy*/ 
--<Functions\Conversion\convert\styles\hh:mm:ss>--
 8 /*hh:mm:ss*/ 
--<Functions\Conversion\convert\styles\mon dd yyyy hh:mi:ss:mmm AM/PM>--
 109 /*mon dd yyyy hh:mi:ss:mmm AM/PM*/ 
--<Functions\Conversion\convert\styles\mm-dd-yy>--
 10 /*mm-dd-yy*/ 
--<Functions\Conversion\convert\styles\mm-dd-yyyy>--
 110 /*mm-dd-yyyy*/ 
--<Functions\Conversion\convert\styles\yy/mm/dd>--
 11 /*yy/mm/dd*/ 
--<Functions\Conversion\convert\styles\yyyy/mm/dd>--
 111 /*yyyy/mm/dd*/ 
--<Functions\Conversion\convert\styles\yymmdd>--
 12 /*yymmdd*/ 
--<Functions\Conversion\convert\styles\yyyymmdd>--
 112 /*yyyymmdd*/ 
--<Functions\Conversion\hextoint>--
 hextoint (hexadecimal_string) 
--<Functions\Conversion\inttohex>--
 inttohex (integer_expression) 
--<Functions\Date>--
--<Functions\Date\dateadd>--
 dateadd(datepart, integer, date) 
--<Functions\Date\datediff>--
 datediff(datepart, date1, date2) 
--<Functions\Date\datename>--
 datename (datepart, date) 
--<Functions\Date\datepart>--
 datepart(datepart, date) 
--<Functions\Date\getdate>--
 getdate() 
--<Functions\Date\dateparts\year>--
 year 
--<Functions\Date\dateparts\quarter>--
 quarter 
--<Functions\Date\dateparts\month>--
 month 
--<Functions\Date\dateparts\week>--
 week 
--<Functions\Date\dateparts\day>--
 day 
--<Functions\Date\dateparts\dayofyear>--
 dayofyear 
--<Functions\Date\dateparts\weekday>--
 weekday 
--<Functions\Date\dateparts\hour>--
 hour 
--<Functions\Date\dateparts\minute>--
 minute 
--<Functions\Date\dateparts\second>--
 second 
--<Functions\Date\dateparts\millisecond>--
 millisecond 
--<Functions\Mathematical>--
--<Functions\Mathematical\abs>--
 abs(numeric_expression) 
--<Functions\Mathematical\acos>--
 acos(cosine_of_the_angle) 
--<Functions\Mathematical\asin>--
 asin(sine_of_the_angle) 
--<Functions\Mathematical\atan>--
 atan(tangent_of_the_angle) 
--<Functions\Mathematical\atn2>--
 atn2(sine, cosine) /*Returns the angle (in radians) whose sine and cosine are specified*/ 
--<Functions\Mathematical\ceiling>--
 ceiling(value) /*smallest integer greater than or equal to the specified value*/ 
--<Functions\Mathematical\cos>--
 cos(rad_angle) /*cosine*/ 
--<Functions\Mathematical\cot>--
 cot(rad_angle) /*cotangent*/ 
--<Functions\Mathematical\degrees>--
 degrees(rad_angle) /*Returns the angle in degrees*/ 
--<Functions\Mathematical\exp>--
 exp(approx_numeric) 
--<Functions\Mathematical\floor>--
 floor(numeric) /*largest integer that is less than or equal to the specified value*/ 
--<Functions\Mathematical\log>--
 log(approx_numeric) /*natural logarithm*/ 
--<Functions\Mathematical\log10>--
 log10(approx_numeric) /*base 10 logarithm*/ 
--<Functions\Mathematical\pi>--
 pi() /*3.1415926535897936*/ 
--<Functions\Mathematical\power>--
 power(value, power) 
--<Functions\Mathematical\radians>--
 radians(numeric) 
--<Functions\Mathematical\rand>--
 rand([integer]) /*random value between 0 and 1*/ 
--<Functions\Mathematical\round>--
 round(number, decimal_places) 
--<Functions\Mathematical\sign>--
 sign(numeric) /*+1 for positive, 0, or -1 for negative*/ 
--<Functions\Mathematical\sin>--
 sin(rad_angle) 
--<Functions\Mathematical\sqrt>--
 sqrt(approx_numeric) /*square root*/ 
--<Functions\Mathematical\tan>--
 tan(rad_angle) 
--<Functions\String\ascii>--
 ascii(char_expr) 
--<Functions\String\char>--
 char(integer_expr) 
--<Functions\String\charindex>--
 charindex(expressionWhat, expressionWhere) 
--<Functions\String\char_length>--
 char_length(char_expr) 
--<Functions\String\difference>--
 difference(char_expr1, char_expr2) /*difference between two soundex values*/ 
--<Functions\String\lower>--
 lower(char_expr) 
--<Functions\String\ltrim>--
 ltrim(char_expr) 
--<Functions\String\patindex>--
 patindex("%pattern%", char_expr_where [, using {bytes | chars} ] ) /*position of the first occurrence of a pattern*/ 
--<Functions\String\replicate>--
 replicate (char_expr, N ) /*repeats char_expr N times*/ 
--<Functions\String\reverse>--
 reverse(char_bin_expression) 
--<Functions\String\right>--
 right(expression, integer_expr) 
--<Functions\String\rtrim>--
 rtrim(char_expr) 
--<Functions\String\soundex>--
 soundex(char_expr) /*4-character code representing the way an expression sounds*/ 
--<Functions\String\space>--
 space(integer_expr) /*string consisting of the specified number of single-byte spaces*/ 
--<Functions\String\str>--
 str(approx_numeric [, length [, decimal] ]) /*character equivalent of the specified number*/ 
--<Functions\String\stuff>--
 stuff( char_replace_where, replace_start, replace_length, char_replace_by ) 
--<Functions\String\substring>--
 substring(expression, start, length) 
--<Functions\String\to_unichar>--
 to_unichar(integer_expr) /*converts unichar code to unichar*/
--<Functions\String\uhighsurr>--
 uhighsurr(uchar_expr,start) /*Returns 1 if the Unicode value at position start  is the high half of a surrogate pair (which should appear first in the pair). Returns 0 otherwise.*/ 
--<Functions\String\ulowsurr>--
 ulowsurr(uchar_expr,start) /*Returns 1 if the Unicode value at position start  is the low half of a surrogate pair (which should appear second in the pair). Returns 0 otherwise.*/ 
--<Functions\String\upper>--
 upper(char_expr) 
--<Functions\String\uscalar>--
 uscalar(uchar_expr) /*Returns the Unicode scalar value for the first Unicode character in an expression.*/ 


--<Functions\System\col_length>--
 col_length(object_name, column_name) 
--<Functions\System\col_name>--
 col_name(object_id, column_id[, database_id]) 
--<Functions\System\curunreservedpgs>--
 curunreservedpgs(dbid, lstart, unreservedpgs) /*number of free pages in the specified disk piece*/ 
--<Functions\System\data_pgs>--
 data_pgs(object_id, {data_oam_pg_id | index_oam_pg_id}) /*number of pages used by the specified table or index*/ 
--<Functions\System\datalength>--
 datalength(expression) /*length in bytes*/ 
--<Functions\System\db_id>--
 db_id(database_name) 
--<Functions\System\db_name>--
 db_name( [database_id] ) 
--<Functions\System\host_id>--
 host_id() /*host process ID of the client process*/ 
--<Functions\System\host_name>--
 host_name() /*current client computer name*/ 
--<Functions\System\index_col>--
 index_col (object_name, index_id, key_# [, user_id]) /*name of the indexed column*/ 
--<Functions\System\isnull>--
 isnull(test_expression, replace_null_expression) 
--<Functions\System\lct_admin>--
 lct_admin({{"lastchance" | "logfull" | "unsuspend"}, database_id | "reserve", log_pages}) /*Manages the last-chance threshold*/ 
--<Functions\System\mut_excl_roles>--
 mut_excl_roles (role1, role2 [membership | activation]) /*Returns information about the mutual exclusivity between two roles*/ 
--<Functions\System\object_id>--
 object_id(object_name) 
--<Functions\System\object_name>--
 object_name( object_id[, database_id] ) 
--<Functions\System\proc_role>--
 proc_role ("role_name") /*Returns information about whether the user has been granted the specified role*/ 
--<Functions\System\ptn_data_pgs>--
 ptn_data_pgs(object_id, partition_id) /*Returns the number of data pages used by a partition*/ 
--<Functions\System\reserved_pgs>--
 reserved_pgs(object_id, {doampg|ioampg}) /*Returns the number of pages allocated to the specified table or index*/ 
--<Functions\System\role_contain>--
 role_contain("role1", "role2") /*Returns 1 if role2 contains role1*/ 
--<Functions\System\role_id>--
 role_id("role_name") 
--<Functions\System\role_name>--
 role_name(role_id) 
--<Functions\System\rowcnt>--
 rowcnt(sysindexes.doampg) 
--<Functions\System\show_role>--
 show_role() /*Shows the login's currently active system-defined roles*/ 
--<Functions\System\suser_id>--
 suser_id([server_user_name]) /*Returns the server user's ID number from the syslogins table.*/  
--<Functions\System\suser_name>--
 suser_name([server_user_id]) /*name of the current server user*/ 
--<Functions\System\tsequal>--
 tsequal(browsed_row_timestamp, stored_row_timestamp) 
--<Functions\System\used_pgs>--
 used_pgs(object_id, doampg, ioampg) /*Returns the number of pages used by the specified table and its clustered index, or the number of pages in a nonclustered index.*/ 
--<Functions\System\user>--
 user /*name of the current user*/ 
--<Functions\System\user_id>--
 user_id([user_name]) 
--<Functions\System\user_name>--
 user_name([user_id]) 
--<Functions\System\valid_name>--
 valid_name(character_expression) /*Returns 0 if the specified string is not a valid identifier or a number other than 0 if the string is a valid identifier.*/ 
--<Functions\System\valid_user>--
 valid_user(server_user_id) /*Returns 1 if the specified ID is a valid user or alias in at least one database on this Adaptive Server.*/ 
--<Advanced\Find text in proc>--
--BAD QUERY: NEED TO BE REVIEWED.

--specify here string you want to search including metasymbols for LIKE operator
-- %	Any string of 0 or more characters 
-- _	Any single character 
-- [ ]	Any single character within the specified range ([a-f]) or set ([abcdef])
-- [^]	Any single character not within the specified range ([^a-f]) or set ([^abcdef])
-- char(10) = '\n' ; char(13) = '\r' ; char(9) = tabulation
-- the next example looks for text "select" separated with any space characters SPACE, TAB or CRLF
--select @text        = "%["+char(9)+char(10)+char(13)+" ]select["+char(9)+char(10)+char(13)+" ]%"
declare @text varchar(100)
select @text        = "%%PARM:Find what%%"

select distinct o.name object
from sysobjects o,
	syscomments c
where o.id=c.id
and o.type='P'
and (c.text like @text
or	exists(
	select 1 from syscomments c2 
		where c.id=c2.id 
		and c.colid+1=c2.colid 
		and right(c.text,100)+ substring(c2.text, 1, 100) like @text 
	)
)
order by 1


--<Admin\Add login>--
exec sp_addlogin "new_login", "password", ["default_db" [, "language" [, "full_name"]]]
--<Admin\Add role>--
grant role ROLE_NAME to @login
exec sp_modifylogin @login, "add default role", 'ROLE_NAME' 

--<Admin\Add admin login>--
declare @login varchar(30)
select @login="%PARM:Login%"

--remember the current password limit
declare @value int
select @value=value from master.dbo.sysconfigures where name="minimum password length"
--reset the password limit to zero
exec sp_configure "minimum password length", 0
reconfigure
--add login without password
exec sp_addlogin @login, null

--restore saved password limit
exec sp_configure "minimum password length", @value
reconfigure

--apply roles for the new login
grant role dtm_tm_role to @login
exec sp_modifylogin @login, "add default role", 'dtm_tm_role' 

grant role ha_role to @login
exec sp_modifylogin @login, "add default role", 'ha_role' 

grant role navigator_role to @login
exec sp_modifylogin @login, "add default role", 'navigator_role' 

grant role oper_role to @login
exec sp_modifylogin @login, "add default role", 'oper_role' 

grant role replication_role to @login
exec sp_modifylogin @login, "add default role", 'replication_role' 

grant role sa_role to @login
exec sp_modifylogin @login, "add default role", 'sa_role' 

grant role sso_role to @login
exec sp_modifylogin @login, "add default role", 'sso_role' 

grant role sybase_ts_role to @login
exec sp_modifylogin @login, "add default role", 'sybase_ts_role' 



--<Admin\Reset password>--
--remember the current password limit
declare @value int
select @value=value from master.dbo.sysconfigures where name="minimum password length"
--reset the password limit to zero
exec sp_configure "minimum password length", 0
reconfigure
--RESET THE PASSWORD:
exec sp_password "CURRENT_LOGIN_PASSWORD", null, "DESTILATION_LOGIN"
--restore saved password limit
exec sp_configure "minimum password length", @value
reconfigure

--<Menu\View Data>--
--EX: U, S, V
select * from %PARM:Object name% for browse
--<Menu\View Data top 100>--
--EX: U, S, V
set rowcount 100
select * from %PARM:Object name% for browse
set rowcount 0
--<Menu\Table DDL>--
--EX: U, S
--the previous row means: execute for object types U and S
set nocount on
go
create table #tmp(
	id_obj		int not null, 
	id_part		int not null, 
	id_order	int not null, 
	txt			varchar(255),
	primary key (id_obj,id_part,id_order)
)
go
declare ccolumn cursor for	
select	sysobjects.id id,
		sysobjects.name tabname, 
		syscolumns.name colname,
		systypes.name coltype,
		syscolumns.length collength,
		syscolumns.status&8 as is_null,
		syscolumns.status&128 as is_identity,
		syscolumns.cdefault,
		syscomments.text defval,
		syscolumns.prec prec,
		syscolumns.scale scale,
		syscolumns.colid colid
from	sysobjects, syscolumns, systypes, syscomments
where	sysobjects.id=object_id('%PARM:Object name%') and  
		syscolumns.id = sysobjects.id and
		systypes.usertype = syscolumns.usertype and
		syscolumns.cdefault *= syscomments.id and
		upper(syscomments.text) like 'DEFAULT %'
order by tabname,syscolumns.colid
go
declare		cindex cursor for
select 		id,
			name,
			keycnt,
			indid,
			status,
			status2
from   		sysindexes
where	  	indid > 0
and			id=object_id('%PARM:Object name%')
and 		status2 & 2 = 2
go
declare 	indexes cursor for
select 		si.status,
			si.indid,
			so.name
from 		sysindexes si, 
			sysobjects so
where 		so.id = object_id('%PARM:Object name%')
and 		si.id = so.id
and 		si.indid > 0
and 		si.indid < 255
and 		si.status2 & 2 != 2
go
declare cprotect cursor for 
select case when p.protecttype<2 then 'grant' else 'revoke' end + ' '+
	case when p.action=151 then 'references'
					 when p.action=193 then 'select'
					 when p.action=195 then 'insert'
					 when p.action=196 then 'delete'
					 when p.action=197 then 'update'
					 when p.action=224 then 'execute'
				end + ' on %PARM:Object name%' as prefix,
	case when p.protecttype<2 then 'to' else 'from' end +' '+user_name(uid)+
		case when p.protecttype=0 then ' with grant option ' else ' ' end +
		'/*'+user_name(grantor)+'*/' suffix, 
	isnull(columns, 0x01 ) columns
	from sysprotects p
	where id=object_id('%PARM:Object name%')
	and p.action in (151,193,195,196,197,224)
	and p.protecttype in (0,1,2)
go 

declare @max_id_part int
declare @max_id_order int
insert into #tmp
select obj.id, 1, 0, 'create table ' + user_name(obj.uid) +'.'+ obj.name + '(' 
from sysobjects obj
where obj.id=object_id('%PARM:Object name%')
order by obj.name

declare @prefix varchar(100)
declare @suffix varchar(100)
declare @columns binary(32)

declare @txt varchar(255)
declare @tabname varchar(255), @colname varchar(255), @coltype varchar(255), @default varchar(255)
declare @id int, @collength int, @isnull int, @isidentity int, @prec int, @scale int, @colid int
declare @cdefault int
open ccolumn
fetch ccolumn into @id, @tabname, @colname, @coltype, @collength, @isnull, @isidentity, @cdefault, @default, @prec, @scale, @colid
while (@@sqlstatus = 0) begin
	select @txt = '   '
	select @txt = @txt + @colname + '   ' + @coltype
	if (@coltype = 'char' or @coltype = 'varchar') select @txt = @txt + '('+convert(varchar(10),@collength)+')'
	if (@coltype like 'uni%char') select @txt = @txt + '('+convert(varchar(10),@collength/2)+')'
	if (@coltype in ('numeric','decimal')) select @txt = @txt + '('+convert(varchar(10),@prec)+','+convert(varchar(10),@scale)+')'
	if @default! = null select @txt = @txt + '  ' + @default
	if @default is null and @cdefault>0 begin
		select @default=u.name+'.'+o.name from sysobjects o,sysusers u where o.id=@cdefault and o.uid=u.uid
		insert into #tmp  values (@id, 6, @colid, 'exec sp_bindefault '''+@default+''', '''+@tabname+'.'+@colname+''''+char(10)+'go'+char(10) )
	end
	if @isidentity != 0 select @txt = @txt + '  identity'
		else if @isnull != 0 select @txt = @txt + '  null'
			else select @txt = @txt + '  not null'
	--select @txt = @txt + char(10)
	insert into #tmp  values (@id, 2, @colid, @txt)
	fetch ccolumn into @id, @tabname, @colname, @coltype, @collength, @isnull, @isidentity, @cdefault, @default, @prec, @scale, @colid
end
close ccolumn
deallocate cursor ccolumn
declare @indname varchar(255),  @index varchar(255), @index0 varchar(255), @objname varchar(255)
declare @cnt numeric, @indid numeric, @status int, @status2 int, @i int
open cindex
fetch cindex into @id, @indname, @cnt, @indid, @status, @status2
while (@@sqlstatus = 0) begin
	select @txt = '   constraint ' + @indname
	if (@status & 2048 = 2048) select @txt = @txt + ' primary key'
	else select @txt = @txt + ' unique'
	select @index = '', @i = 1
	select @objname = user_name(uid)+'.'+name from sysobjects where id = @id
	while @i <= @cnt
	begin
		select @index0=index_col(@objname, @indid, @i)
		if @index0 is not null begin
			if @i > 1 select @index = @index + ', '
			select @index = @index + @index0
		end
		select @i = @i + 1
	end
	if @indid = 1 select @txt = @txt + ' clustered'
	if @indid > 1
	begin
		if ( (@status & 16 = 16) or (@status2 & 512 = 512) ) select @txt = @txt + ' clustered'
		else select @txt = @txt + ' nonclustered'
	end
	select @txt =  @txt + ' ('+@index+' )'
	insert into #tmp  values (@id, 3, @indid, @txt)
	fetch cindex into @id, @indname, @cnt, @indid, @status, @status2
end
close cindex
deallocate cursor cindex
insert into #tmp
select obj.id, 4, 0, ')'
from sysobjects obj
where obj.id=object_id('%PARM:Object name%')
select @max_id_part=max(id_part) from #tmp where id_part in (2,3)
select @max_id_order=max(id_order) from #tmp where id_part=@max_id_part
update #tmp set txt=txt+',' 
	where id_part in (2,3) 
	and not(id_part=@max_id_part and id_order=@max_id_order)
/*lock*/
insert into #tmp
select id,5,1,'alter table %PARM:Object name% lock allpages'+char(10)+'go'+char(10)
	from sysobjects where id=object_id('%PARM:Object name%') and sysstat2&8192=8192
insert into #tmp
select id,5,1,'alter table %PARM:Object name% lock datapages'+char(10)+'go'+char(10)
	from sysobjects where id=object_id('%PARM:Object name%') and sysstat2&16384=16384
insert into #tmp
select id,5,1,'alter table %PARM:Object name% lock datarows'+char(10)+'go'+char(10)
	from sysobjects where id=object_id('%PARM:Object name%') and sysstat2&32768=32768
/*protect*/

select @i=0

open cprotect
fetch cprotect into @prefix, @suffix, @columns

while @@sqlstatus=0 begin
	--processing selected row
	if @columns = 0x01 or @columns = 0x00 begin
		insert into #tmp
			select object_id('%PARM:Object name%'),6,@i,@prefix
		select @i=@i+1
		insert into #tmp
			select object_id('%PARM:Object name%'),6,@i,'   '+@suffix
	end else begin
		insert into #tmp
			select object_id('%PARM:Object name%'),6,@i,@prefix+' ('
		insert into #tmp
			select  object_id('%PARM:Object name%'),6,@i+colid,'      '+c.name+','
			from syscolumns c
			where c.id=object_id('%PARM:Object name%') 
			and convert(tinyint,substring(@columns,c.colid/8 +1,1 ) ) & power(2,c.colid%8)<>0
			order by c.colid
		
		select @i=max(id_order)+1 from #tmp where id_obj=object_id('%PARM:Object name%') and id_part=6
		--remove comma
		update #tmp set txt=substring(txt,1,char_length(txt)-1) 
			where id_obj=object_id('%PARM:Object name%') and id_part=6 and id_order=@i-1
		--add suffix
		insert into #tmp
			select object_id('%PARM:Object name%'),6,@i,'   ) '+@suffix
	end
	
	select @i=max(id_order)+1 from #tmp where id_obj=object_id('%PARM:Object name%') and id_part=6
	fetch cprotect into @prefix, @suffix, @columns
end
close cprotect
deallocate cursor cprotect


/*fkeys*/
insert into #tmp
select ref.tableid,4+fkobj.id,0,'alter table %PARM:Object name%'
	from sysreferences ref,sysobjects fkobj
	where fkobj.id =ref.constrid
	and fkobj.type='RI'
	and ref.tableid=object_id('%PARM:Object name%')
	and ref.pmrydbname is null
insert into #tmp
select ref.tableid,4+fkobj.id,1,
	'    add constraint '+fkobj.name+' foreign key ( '+ col_name(ref.tableid,ref.fokey1)+
	case when ref.fokey2 >0 then ',' else null end + col_name(ref.tableid,ref.fokey2 )+
	case when ref.fokey3 >0 then ',' else null end + col_name(ref.tableid,ref.fokey3 )+
	case when ref.fokey4 >0 then ',' else null end + col_name(ref.tableid,ref.fokey4 )+
	case when ref.fokey5 >0 then ',' else null end + col_name(ref.tableid,ref.fokey5 )+
	case when ref.fokey6 >0 then ',' else null end + col_name(ref.tableid,ref.fokey6 )+
	case when ref.fokey7 >0 then ',' else null end + col_name(ref.tableid,ref.fokey7 )+
	case when ref.fokey8 >0 then ',' else null end + col_name(ref.tableid,ref.fokey8 )+
	case when ref.fokey9 >0 then ',' else null end + col_name(ref.tableid,ref.fokey9 )+
	case when ref.fokey10>0 then ',' else null end + col_name(ref.tableid,ref.fokey10)+
	case when ref.fokey11>0 then ',' else null end + col_name(ref.tableid,ref.fokey11)+
	case when ref.fokey12>0 then ',' else null end + col_name(ref.tableid,ref.fokey12)+
	case when ref.fokey13>0 then ',' else null end + col_name(ref.tableid,ref.fokey13)+
	case when ref.fokey14>0 then ',' else null end + col_name(ref.tableid,ref.fokey14)+
	case when ref.fokey15>0 then ',' else null end + col_name(ref.tableid,ref.fokey15)+
	case when ref.fokey16>0 then ',' else null end + col_name(ref.tableid,ref.fokey16)+
	' )'
	from sysreferences ref,sysobjects fkobj
	where fkobj.id =ref.constrid
	and fkobj.type='RI'
	and ref.tableid=object_id('%PARM:Object name%')
	and ref.pmrydbname is null
insert into #tmp
select ref.tableid,4+fkobj.id,2,
	'    references '+user_name(reftab.uid)+'.'+reftab.name+' ( '+  col_name(ref.reftabid,ref.refkey1)+
	case when ref.refkey2 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey2 )+
	case when ref.refkey3 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey3 )+
	case when ref.refkey4 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey4 )+
	case when ref.refkey5 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey5 )+
	case when ref.refkey6 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey6 )+
	case when ref.refkey7 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey7 )+
	case when ref.refkey8 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey8 )+
	case when ref.refkey9 >0 then ',' else null end + col_name(ref.reftabid,ref.refkey9 )+
	case when ref.refkey10>0 then ',' else null end + col_name(ref.reftabid,ref.refkey10)+
	case when ref.refkey11>0 then ',' else null end + col_name(ref.reftabid,ref.refkey11)+
	case when ref.refkey12>0 then ',' else null end + col_name(ref.reftabid,ref.refkey12)+
	case when ref.refkey13>0 then ',' else null end + col_name(ref.reftabid,ref.refkey13)+
	case when ref.refkey14>0 then ',' else null end + col_name(ref.reftabid,ref.refkey14)+
	case when ref.refkey15>0 then ',' else null end + col_name(ref.reftabid,ref.refkey15)+
	case when ref.refkey16>0 then ',' else null end + col_name(ref.reftabid,ref.refkey16)+
	' )'
	from sysreferences ref,sysobjects fkobj,sysobjects reftab
	where fkobj.id =ref.constrid
	and reftab.id=ref.reftabid
	and fkobj.type='RI'
	and ref.tableid=object_id('%PARM:Object name%')
	and ref.pmrydbname is null

select @cdefault = max(id_part)+1 from #tmp
open indexes
fetch indexes into @status,@indid,@tabname
while @@sqlstatus = 0  begin


	select @txt = ''
	select @i =1 
	while @i <= 31
	begin
		select @txt = @txt + index_col('%PARM:Object name%', @indid, @i)+ ' ' + index_colorder('%PARM:Object name%', @indid, @i)
		if (index_col('%PARM:Object name%', @indid, @i+1) is null) break
		if @i >= 1 select @txt = @txt + ","
		select @i = @i + 1
	end
	
	select @txt=' (' +isnull(@txt,'') +')'

	insert into #tmp
	select 
		so.id,@cdefault,1,
		'create' +	case si.status & 2 when 2 then ' unique ' else ' ' end +
		case (si.status & 16) + (si.status2 & 512) when 0 then 'nonclustered' else 'clustered' end +
		' index ' +	si.name + ' on ' + su.name + '.'+so.name +@txt
	from sysindexes si, sysobjects so, sysusers su
	where 
		so.id = object_id('%PARM:Object name%')
		and so.type = 'U'
		and so.uid = su.uid 
		and si.indid = @indid
		and si.id = so.id
		and si.indid > 0
		and si.indid < 255
		and si.status2 & 2 != 2

	if @status & 1 = 1 select @default = 'ignore_dup_key'
	if @status & 4 = 4 select @default = 'ignore_dup_row'
	if @status & 64 = 64  select @default = 'allow_dup_row'
	
	if isNull(@default,'')!=''
		insert into #tmp
			select object_id(@tabname),@cdefault,3,char(9)+"with " + @default

	select @cdefault = @cdefault + 1
	fetch indexes into @status,@indid,@tabname
end
close indexes
deallocate cursor indexes

select txt from #tmp order by  id_obj, id_part, id_order
drop table #tmp
go
set nocount off
go
--<Menu\Referenced By>--
--EX: U, S
select oref.name from sysreferences r,sysobjects oref
 where r.reftabid=object_id('%PARM:Object name%')
 and oref.id=r.tableid
--<Menu\sp_depends>--
--EX: U,S,V,P,TR
exec sp_depends '%PARM:Object name%'
--<Menu\Procedure header>--
use %PARM:Database%
go
if exists(select 1
		from sysobjects
		where id=object_id('%PARM:Object name%')
		and type='P')
	drop procedure %PARM:Object name%
go

--<Menu\View header>--
use %PARM:Database%
go
if exists(select 1
		from sysobjects
		where id=object_id('%PARM:Object name%')
		and type='V')
	drop view %PARM:Object name%
go

--<Menu\Object rights>--
--EX: S,U,V,P
select case when p.protecttype<2 then 'grant' else 'revoke' end + 
		' ' + case
		when action = 224 then 'execute'
		when action = 193 then 'select'
		when action = 195 then 'insert'
		when action = 196 then 'delete'
		when action = 197 then 'update'
		end + ' on %PARM:Object name% ' +
		case when p.protecttype<2 then 'to' else 'from' end +' '+user_name(uid)+
		case when p.protecttype=0 then ' with grant option ' else ' ' end +
		'/*'+user_name(grantor)+'*/' + char(13) + char(10) command
	from sysprotects p
	where p.action in (193,195,196,197,224)
	and p.protecttype in (0,1,2)
	and id=object_id('%PARM:Object name%')
--<Menu\Type info>--
--EX: TYPE
select a.name, 
	(select name from systypes b where b.usertype=(
			select min(c.usertype) from systypes c where c.hierarchy=a.hierarchy)
	) base_type, 
	a.length byte_length, 
	a.prec,
	a.scale,
	a.ident,
	a.allownulls
from systypes a
where a.name='%PARM:Object name%'
--<Menu\Kill Process>--
--EX: PROCESS
--CONFIRM: Do you want to kill process #%PARM:spid% ?  
if object_id('sybsystemprocs..sp_kill') is not null
	/*code special for FM*/
	execute sp_kill %PARM:spid%
else 
	kill %PARM:spid%
--<Menu\Current Query>--
--EX: PROCESS
if object_id('sybsystemprocs..sp_sqltext') is not null begin
	/*code special for FM*/
	execute sp_sqltext %PARM:spid%
end else begin
	dbcc traceon (3604) --redirect dbcc output to the client session
	dbcc sqltext (%PARM:spid%)
end
--<Menu\Query Plan>--
--EX: PROCESS
if object_id('sybsystemprocs..sp_showp') is not null
	/*code special for FM*/
	execute sp_showp %PARM:spid%
else 
	execute sp_showplan %PARM:spid%,null,null,null
--<Menu\Column information>--
--EX: U
if object_id('sybsystemprocs..col') is not null or object_id('col') is not null  begin
	/*code special for FM*/
	exec col '%PARM:Object name%'
end else begin
	select
		"#"      = colid,
		column   = c.name,
		type     = t.name,
		byte_len = c.length,
		isnull   = convert (smallint , convert(bit, c.status&8))
	from   
	syscolumns c,systypes t   
	where   
		c.id = object_id('%PARM:Object name%')   
		and c.usertype *= t.usertype   
	order by 1
end
--<Menu\View Processes>--
select spid, blk_spid=blocked, status, login=convert(char(12), suser_name(suid)), hostname, 
	appname=CASE WHEN program_name like "<astc>%" THEN "<astc>" ELSE convert(char(15),program_name) END,
	dbname=convert(char(15), db_name(dbid)), cmd=lower(cmd), cpu, mem=memusage, io=physical_io
from master..sysprocesses
