--old and dirty
declare @datetime datetime = '2022-10-25 23:16:01.001'
select cast(floor(cast(@datetime as float)) as datetime)
go

--more modern, watch out for indexes when in a where clause
declare @datetime datetime = '2022-10-25 23:16:01.001'
select dateadd(dd, datediff(dd, 0, @datetime), 0)
go

--for datetime2
declare @datetime2value datetime2 = '20221025 23:16:01.001'
declare @datetime2epoch datetime2 = '19000101'
select dateadd(dd, datediff(dd, @datetime2epoch, @datetime2value), @datetime2epoch)
go
