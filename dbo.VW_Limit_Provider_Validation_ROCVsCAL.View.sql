USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Limit_Provider_Validation_ROCVsCAL]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE View [dbo].[VW_Limit_Provider_Validation_ROCVsCAL]
As
with Limitdetails as
(
select [Created On],[Created By],[Clinic Date],[Provider],[Clinic Hours Category],[Location],
case when isnull([Room Number],'')!='' then 'Yes' when isnull([Room Name],'')!='' then 'Yes' else 'No' end as [Room Mandatory],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Originating Process],
concat(convert(varchar,[Clinic Date],112),replace(replace([Provider],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from [Limit_Provider_Schedule] where [Clinic Date]>=getdate()-3
Union All 
select [Created On],[Created By],[Clinic Date],[Room Only Schedule Provider],[Clinic Hours Category],[Location],
case when isnull([Room Number],'')!='' then 'Yes' when isnull([Room Name],'')!='' then 'Yes' else 'No' end as [Room Mandatory],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Room Only Schedule Provider],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from [Limit_Room_Only_Schedule] where [Clinic Date]>=getdate()-3
),
Canceldata as 
(
select a.[Created On],[Created By],a.[Clinic Date],a.[Provider],a.[Clinic Hours Category],a.[Location],
cast(a.[Clinic Start Time] as time)[Clinic Start Time],cast(a.[Clinic End Time] as time)[Clinic End Time],
[Originating Process],
concat(convert(varchar,a.[Clinic Date],112),replace(replace(a.[Provider],',',''),' ',''),
left(cast(a.[Clinic Start Time] as time),5),left(cast(a.[Clinic End Time] as time),5),a.[Location])[Uniquevalue]
from Cancel_Provider_Clinic a inner join (select max([Created On])[Created On],[Clinic Date],[Provider],[Clinic Hours Category],[Location],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time]
from Cancel_Provider_Clinic
where [Clinic Date]>=getdate()-3 
group by [Clinic Date],[Provider],[Clinic Hours Category],[Location],
cast([Clinic Start Time] as time),cast([Clinic End Time] as time))b
on a.[Created On]=b.[Created On] and concat(convert(varchar,a.[Clinic Date],112),replace(replace(a.[Provider],',',''),' ',''),
left(cast(a.[Clinic Start Time] as time),5),left(cast(a.[Clinic End Time] as time),5),a.[Location])=concat(convert(varchar,b.[Clinic Date],112),replace(replace(b.[Provider],',',''),' ',''),
left(cast(b.[Clinic Start Time] as time),5),left(cast(b.[Clinic End Time] as time),5),b.[Location])
where b.[Clinic Date]>=getdate()-3 and a.[Clinic Date]>=getdate()-3
Union All
select a.[Created On],[Created By],a.[Clinic Date],a.[Room Only Schedule Provider],a.[Clinic Hours Category],a.[Location],
cast(a.[Clinic Start Time] as time)[Clinic Start Time],cast(a.[Clinic End Time] as time)[Clinic End Time],
[Originating Process],
concat(convert(varchar,a.[Clinic Date],112),replace(replace(a.[Room Only Schedule Provider],',',''),' ',''),
left(cast(a.[Clinic Start Time] as time),5),left(cast(a.[Clinic End Time] as time),5),a.[Location])[Uniquevalue]
from Cancel_Room_Only_Schedule a inner join (select max([Created On])[Created On],[Clinic Date],[Room Only Schedule Provider],[Clinic Hours Category],[Location],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time]
from Cancel_Room_Only_Schedule
where [Clinic Date]>=getdate()-3 
group by [Clinic Date],[Room Only Schedule Provider],[Clinic Hours Category],[Location],
cast([Clinic Start Time] as time),cast([Clinic End Time] as time))b
on a.[Created On]=b.[Created On] and concat(convert(varchar,a.[Clinic Date],112),replace(replace(a.[Room Only Schedule Provider],',',''),' ',''),
left(cast(a.[Clinic Start Time] as time),5),left(cast(a.[Clinic End Time] as time),5),a.[Location])=concat(convert(varchar,b.[Clinic Date],112),replace(replace(b.[Room Only Schedule Provider],',',''),' ',''),
left(cast(b.[Clinic Start Time] as time),5),left(cast(b.[Clinic End Time] as time),5),b.[Location])
where b.[Clinic Date]>=getdate()-3 and a.[Clinic Date]>=getdate()-3
),
Divisioncalendar as 
(
select [Created On],[Provider or Room Only Name][Provider],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Location],[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Provider or Room Only Name],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue] from VW_Calendar_data where [Clinic Date]>=getdate()-3
),
Roomassignment as 
(
select distinct [Created On],[Provider],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Location],[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Provider],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from Room_Assignment_Detail where [Clinic Date]>=getdate()-3 and [Division Name] =(select top 1 [Division Name] from Division_Detail)
),
Roomoccupancy as 
(
select distinct [Created On],[Provider],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Location],[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Provider],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from Room_Occupancy_Details where [Clinic Date]>=getdate()-3 and [Division Name] =(select top 1 [Division Name] from Division_Detail)
and [Room Status]='Occupied'
),
Dataset as
(
select distinct a.*,(select top 1 [Division Name] from [Division_Detail])[Division Name],case when isnull(b.[Clinic Date],'')='' then 'No' else 'Yes' end 'DivisionCalendar'
,case when isnull(c.[Clinic Date],'')='' then 'No' else 'Yes' end 'RAD'
,case when isnull(d.[clinic date],'')='' then 'No' else 'Yes' end 'ROC'
,case when isnull(b.[Clinic Date],'')='' and e.[Originating Process] in('Cancel Provider Clinic','Cancel Room Only Schedule')
and e.[Created On]>a.[Created On] then 'Yes' else 'No' end as [Cancel]
from Limitdetails a left join Divisioncalendar b
on a.[Uniquevalue]=b.[Uniquevalue]
and a.[Originating Process]=b.[Originating Process]
left join Roomassignment c on a.[Uniquevalue]=c.[Uniquevalue]
and a.[Originating Process]=c.[Originating Process]
left join Roomoccupancy d on a.[Uniquevalue]=d.[Uniquevalue]
and a.[Originating Process]=d.[Originating Process]
left join Canceldata e on a.[Uniquevalue]=e.[Uniquevalue]
and e.[Originating Process] in('Cancel Provider Clinic','Cancel Room Only Schedule')
)
select * from Dataset where [Clinic Date] not in (select [Holiday Date] from [ERD_Enterprise_Holiday_List])
GO
