--USER STUBS. YOU CAN MODIFY THIS FILE UP TO YOUR NEEDS.
-- CURRENTLY THIS FILE CONTAINS STUBS FOR MY COMPANY.
--Macros:
--  %SERVER%     current server name
--  %DATABASE%   current database name
--  %DATE006%       current local time in format DD MON YY
--  %USERNAME%   user name (windows login)
--  %PARM:Parameter name%   user will be prompted for this parameter


--<FML>--
--<FML\Proc\Procedure tran>--
use %DATABASE%
go
if exists(select 1
		from sysobjects
		where id=object_id('%PARM:Object name%')
		and type='P')
	drop procedure %PARM:Object name%
go
create proc %PARM:Object name% (
	@param_name datatype [= default] [output] ,
	...
)
as
begin
/**********************************************************
*Procedure Name: 
*Database: %DATABASE%
*Server: %SERVER%
*ASE Isql
*
*Business Function : 
* %PARM:Business function%
*
*Author: %USERNAME%   Date: %DATE006%
*  Comment: creation  
*********************************************************/
	declare @res	int
	declare @err	int
	declare @row	int
	declare @tra	int
	declare @pro	int

	select @pro = @@procid
	
	if (@@trancount = 0)
	begin
		select @tra = 1
		begin tran
	end
		else select @tra = 0

	...statements...
	select @err = @@error, @row = @@rowcount
	if (@err <> 0) begin
		if (@tra = 1) rollback tran
		return @err
	end
	if (@row = 0)  begin
		if (@tra = 1) rollback tran
		return -@pro
	end
	if (@row > 1)  begin
		if (@tra = 1) rollback tran
		return @pro
	end
	
	if (@tra = 1) commit tran
	return 0
end
go
grant exec on %PARM:Object name% to public
go

--<FML\Proc\Procedure NO tran>--
use %DATABASE%
go
if exists(select 1
		from sysobjects
		where id=object_id('%PARM:Object name%')
		and type='P')
	drop procedure %PARM:Object name%
go
create proc %PARM:Object name% (
	@param_name datatype [= default] [output] ,
	...
)
as
begin
/**********************************************************
*Procedure Name: 
*Database: %DATABASE%
*Server: %SERVER%
*ASE Isql
*
*Business Function : 
* %PARM:Business function%
*
*Author: %USERNAME%   Date: %DATE006%
*  Comment: creation  
*********************************************************/
	declare @res	int
	declare @err	int
	declare @row	int
	declare @pro	int

	select @pro = @@procid
	

	...statements...
	select @err = @@error, @row = @@rowcount
	if (@err <> 0) 	return @err
	if (@row = 0) 	return -@pro
	if (@row > 1) 	return @pro
	
	return 0
end
go
grant exec on %PARM:Object name% to public
go

--<FML\Proc\Standard declare>--

declare @res	int
declare @err	int
declare @row	int
declare @tra	int
declare @pro	int

select @pro = @@procid

--<FML\Proc\begin tran>--

if (@@trancount = 0)
begin
	select @tra = 1
	begin tran
end
	else select @tra = 0

--<FML\Proc\error check>--

select @err = @@error, @row = @@rowcount
if (@err <> 0) begin
	if (@tra = 1) rollback tran
	return @err
end
if (@row = 0)  begin
	if (@tra = 1) rollback tran
	return -@pro
end
if (@row > 1)  begin
	if (@tra = 1) rollback tran
	return @pro
end


--<FML\Proc\commit tran>--

if (@tra = 1) commit tran

--<FML\Admin\dump>--
dump database %DATABASE% to 'compress::/sybaseSV/%SERVER%.%DATABASE%.cmp'
go

--<FML\Admin\load>--
use master
go
sp_dboption '%DATABASE%', 'single user', true
go
use %DATABASE%
go
checkpoint
go
use master
go
load database %DATABASE% from 'compress::/sybaseSV/%SERVER%.%DATABASE%.cmp'
go
online database %DATABASE%
go
sp_dboption '%DATABASE%', 'single user', false
go
use %DATABASE%
go
checkpoint
go
