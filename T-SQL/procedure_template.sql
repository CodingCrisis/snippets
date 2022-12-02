GO
if not exists (select * from sys.objects where object_id = object_id(N'[dbo].[ProcedureName]') and type in (N'P', N'PC')) exec('create procedure [dbo].[ProcedureName] as return 1')
GO

/*
<ProcHeader>
  <Description>
      Short description of procedures purpose
  </Description>
  <History>
  	<h>2022-12-03 - Coding Crisis, created as template</h>
  </History>
  <Parameters>
    <p n="@ExampleParam">Input parameter description</p>
  </Parameters>
  <RetCode>
    0 - success
    Negative - failure
  </RetCode>
  <ReturnedRecordset>none</ReturnedRecordset>
</ProcHeader>
*/
alter procedure [dbo].[ProcedureName]
	 @ExampleParam int
	 --suggested standard return parameters
	,@RetCode int = null output
	,@RetMsg varchar(max) = null output
as
begin
	set nocount on;

	declare
		@openedTran bit
		,@errorSeverity int
		,@errorState int
		,@errorNumber int

	begin try
		if @@TRANCOUNT > 0
		begin
			set @openedTran = 1
		end
		else begin
			set @openedTran = 0
			begin tran
		end

		--put proc body here

		if @openedTran = 0 and XACT_STATE() = 1
			commit tran
	end try
	begin catch
	    if @openedTran = 0 and XACT_STATE() != 0
			rollback tran

		select
			 @errorSeverity = ERROR_SEVERITY()
			,@errorState = ERROR_STATE()
			,@errorNumber = ERROR_NUMBER()

		set @RetMsg = 'SQL ERROR in procedure: [' + coalesce(ERROR_PROCEDURE(), '<<null>>')
			+'] Message: [' + coalesce(ERROR_MESSAGE(),'<<null>>')
			+'] Severity: [' + coalesce(convert(varchar(10), @errorSeverity), '<<null>>')
			+'] State: [' + coalesce(convert(varchar(10), @errorState), '<<null>>')
			+'] Line: [' + coalesce(convert(varchar(10), ERROR_LINE()), '<<null>>')
			+'] Number: [' + coalesce(convert(varchar(10), ERROR_NUMBER()), '<<null>>')
			+'].'
		set @RetCode = -@errorNumber

		raiserror(@RetMsg, @errorSeverity, @errorState)
		return @RetCode
	end catch

	select @RetCode = 0, @RetMsg = 'Ok'
	return @RetCode
end
