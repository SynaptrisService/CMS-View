USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Irregular_Schedule Interval]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE View  [dbo].[VW_Provider_Irregular_Schedule Interval] 
as 
select distinct  t.[Full Name] as  Provider ,s.[Schedule Interval] as [Schedule Interval] 
,case when t.[Full Name] in (
select distinct Provider [Schedule Type]  from [Provider_Irregular_Schedule_detail] y 
where  y.[Schedule Interval]=s.[Schedule Interval]
union 
select distinct Provider [Schedule Type] from [Provider_Irregular_Schedule] y  where  y.[Schedule Interval]=s.[Schedule Interval] ) 
then 'Update' else 'New' end [Schedule Type],[Employee Login ID]
from Employee_Master t
join (select [Schedule Interval]
from (
select 'Selected Day of Week for Selected Month Frequency' [Schedule Interval] 
union 
select 'Selected Day of Week for Selected Months' [Schedule Interval] 
union 
select 'Custom Dates' [Schedule Interval] 
union
select 'Weekly interval' [Schedule Interval]
 )  x ) s on 1= 1
where [Employee Status] = 'Active' and [Employee Type]= 'Provider'








GO
