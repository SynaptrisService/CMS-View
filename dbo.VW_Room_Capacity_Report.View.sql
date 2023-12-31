USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Capacity_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_Room_Capacity_Report] as
With RODData as (select *,case when ([Room Status]='Unoccupied' and Hours<=1.59) then 'Dead' 
when ([Room Status]='Unoccupied' and Hours>1.59) then 'Open' else 'Booked' end CapacityType from (
select distinct [Work Days],cast([Clinic Date] as date) [Clinic Date],[Room Name],[Room Number],left(cast(cast([Clinic Start Time] as time) as varchar),5) [Clinic Start Time],
left(cast(cast([Clinic End Time] as time) as varchar),5) [Clinic End Time]
, cast(Concat(replace(FLOOR((DATEDIFF(SECOND,  cast([Clinic End Time] as time),cast([Clinic Start Time] as time))) % (3600 * 24) / 3600),'-','') ,'.',
    replace(FLOOR(((DATEDIFF(SECOND,  cast([Clinic End Time] as time),cast([Clinic Start Time] as time))) % 3600) / 60),'-','')) as Float) Hours
,case when [Room Status]='onHold' then 'Occupied' else [Room Status] end [Room Status],[Location],Building,Floor,Suite,[Division Name],Provider,[Clinic Specialty],
case when [Room Status]='Unoccupied' then '' else [Originating Process] end
[Originating Process],[Clinic Hours Category] from Room_Occupancy_Details
where [Clinic Date] >'2021-05-31'
and datename(weekday,[Clinic Date]) not in ('Saturday','Sunday') 
and [Clinic Date] not in (select [Holiday Date] from ERD_Enterprise_Holiday_List)
and isnull([Clinic Start Time],'')!='' and isnull([Clinic End Time],'')!=''
and  isnull([Clinic Start Time],'')!= isnull([Clinic End Time],''))z),

RSD as (select [Work Days],cast(date as date) [Clinic Date],[Room Name],[Room Number],cast('07:00' as varchar) [Clinic Start Time],cast('21:00' as varchar) [Clinic End Time] 
,'14.0' Hours ,'Unoccupied' [Room Status],[Location],Building,Floor,Suite,''[Division Name],''Provider,''[Clinic Specialty],
'' [Originating Process],'All Day' [Clinic Hours Category],'Open' CapacityType
from Room_Schedule_Detail a
where  date >'2021-05-31'and datename(weekday,date) not in ('Saturday','Sunday') 
and date not in (select [Holiday Date] from ERD_Enterprise_Holiday_List))
select 
[Work Days]      ,[Clinic Date]      ,[Room Name]      ,[Room Number]      ,[Clinic Start Time]      ,[Clinic End Time]      ,
cast(left(replace(replace(replace(REPLACE([Hours],'.5','.75'),'.3','.5'),'.15','.25'),'.1','.25'),5) as float) [Hours]     ,[Room Status]
      ,[Location]      ,[Building]      ,[Floor]      ,[Suite]      ,[Division Name]      ,[Provider]      ,[Clinic Specialty]      ,[Originating Process]
      ,[Clinic Hours Category]      ,[CapacityType]  ,    
convert(varchar(7), [CLinic Date], 126) MonthYear from 
(select * from RODData
union
select * from RSD a
where [CLinic Date] not in (select [CLinic Date] from RODData b where a.[Room Number]=b.[Room Number]))x
where [Clinic date] between (select [Start Date] from VW_Financial_Year) and (select [End Date] from VW_Financial_Year)
GO
