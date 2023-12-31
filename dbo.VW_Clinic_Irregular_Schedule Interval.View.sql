USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Irregular_Schedule Interval]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE View [dbo].[VW_Clinic_Irregular_Schedule Interval] as 

select distinct [Clinic Type], [Clinic Specialty] , s.[Schedule Interval] as [Schedule Interval]
,case when CONCAT(t.[Clinic Type],t.[Clinic Specialty]) in (select CONCAT([Clinic Type],[Clinic Specialty]) [Schedule Type] from [Clinic_Irregular_Schedule_Detail] c
where  c.[Schedule Interval]=s.[Schedule Interval]
union 
select CONCAT([Clinic Type],[Clinic Specialty]) [Schedule Type] from [Clinic_Irregular_Schedule]  c where  c.[Schedule Interval]=s.[Schedule Interval]) 
then 'Update' else 'New' end [Schedule Type] 
from Clinic_Specialty t
join (
select [Schedule Interval]  from (
select 'Selected Day of Week for Selected Month Frequency' [Schedule Interval] 
union 
select 'Selected Day of Week for Selected Months' [Schedule Interval] 
union 
select 'Custom Dates' [Schedule Interval] 
union
select 'Weekly interval' [Schedule Interval]
 ) x ) s on 1= 1

GO
