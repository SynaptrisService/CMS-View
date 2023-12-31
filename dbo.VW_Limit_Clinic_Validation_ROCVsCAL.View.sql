USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Limit_Clinic_Validation_ROCVsCAL]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE View [dbo].[VW_Limit_Clinic_Validation_ROCVsCAL]
As
with Limitdetails as
(
select [Created On],[Created By],[Clinic Date],[Clinic Type],[Clinic Specialty],[Clinic Hours Category],[Location],
case when isnull([Room Number],'')!='' then 'Yes' when isnull([Room Name],'')!='' then 'Yes' else 'No' end as [Room Mandatory],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Originating Process],
concat(convert(varchar,[Clinic Date],112),replace(replace([Clinic Type],',',''),' ',''),replace(replace([Clinic Specialty],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from [Limit_Clinic_Schedule] where [Clinic Date]>=getdate()-3
),
Canceldata as 
(
select a.[Created On],[Created By],a.[Clinic Date],a.[Clinic Type],a.[Clinic Specialty],a.[Clinic Hours Category],a.[Location],
cast(a.[Clinic Start Time] as time)[Clinic Start Time],cast(a.[Clinic End Time] as time)[Clinic End Time],
[Originating Process],
concat(convert(varchar,a.[Clinic Date],112),replace(replace(a.[Clinic Type],',',''),' ',''),replace(replace(a.[Clinic Specialty],',',''),' ',''),
left(cast(a.[Clinic Start Time] as time),5),left(cast(a.[Clinic End Time] as time),5),a.[Location])[Uniquevalue]
from Cancel_Clinic a inner join (select max([Created On])[Created On],[Clinic Date],[Clinic Type],[Clinic Specialty],[Clinic Hours Category],[Location],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time]
from Cancel_Clinic
where [Clinic Date]>=getdate()-3 
group by [Clinic Date],[Clinic Type],[Clinic Specialty],[Clinic Hours Category],[Location],
cast([Clinic Start Time] as time),cast([Clinic End Time] as time))b
on a.[Created On]=b.[Created On] and concat(convert(varchar,a.[Clinic Date],112),replace(replace(a.[Clinic Type],',',''),' ',''),replace(replace(a.[Clinic Specialty],',',''),' ',''),
left(cast(a.[Clinic Start Time] as time),5),left(cast(a.[Clinic End Time] as time),5),a.[Location])=concat(convert(varchar,b.[Clinic Date],112),replace(replace(b.[Clinic Type],',',''),' ',''),replace(replace(b.[Clinic Specialty],',',''),' ',''),
left(cast(b.[Clinic Start Time] as time),5),left(cast(b.[Clinic End Time] as time),5),b.[Location])
where b.[Clinic Date]>=getdate()-3 and a.[Clinic Date]>=getdate()-3
),
Divisioncalendar as 
(
select [Created On],[Clinic Type],[Clinic Specialty],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Location],[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Clinic Type],',',''),' ',''),replace(replace([Clinic Specialty],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue] from VW_Calendar_data where [Clinic Date]>=getdate()-3
and isnull([Provider or Room Only Name],'')=''
),
Roomassignment as 
(
select distinct [Created On],[Clinic Type],[Clinic Specialty],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Location],[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Clinic Type],',',''),' ',''),replace(replace([Clinic Specialty],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from   Room_Assignment_Detail where [Clinic Date]>=getdate()-3 and [Division Name] =(select top 1 [Division Name] from Division_Detail)
),
Roomoccupancy as 
(
select distinct [Created On],[Clinic Type],[Clinic Specialty],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Location],[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Clinic Type],',',''),' ',''),replace(replace([Clinic Specialty],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from Room_Occupancy_Details where [Clinic Date]>=getdate()-3 and [Division Name] =(select top 1 [Division Name] from Division_Detail)
and [Room Status]='Occupied'
),
Dataset as
(
select distinct a.*,(select top 1 [Division Name] from [Division_Detail])[Division Name],case when isnull(b.[Clinic Date],'')='' then 'No' else 'Yes' end 'DivisionCalendar'
,case when isnull(c.[Clinic Date],'')='' then 'No' else 'Yes' end 'RAD'
,case when isnull(d.[clinic date],'')='' then 'No' else 'Yes' end 'ROC'
,case when isnull(b.[Clinic Date],'')='' and e.[Originating Process] in('Cancel Clinic')
and e.[Created On]>a.[Created On] then 'Yes' else 'No' end as [Cancel]
from Limitdetails a left join Divisioncalendar b
on a.[Uniquevalue]=b.[Uniquevalue]
and a.[Originating Process]=b.[Originating Process]
left join Roomassignment c on a.[Uniquevalue]=c.[Uniquevalue]
and a.[Originating Process]=c.[Originating Process]
left join Roomoccupancy d on a.[Uniquevalue]=d.[Uniquevalue]
and a.[Originating Process]=d.[Originating Process]
left join Canceldata e on a.[Uniquevalue]=e.[Uniquevalue]
and e.[Originating Process] in('Cancel Clinic')
)
select * from Dataset where [Clinic Date] not in (select [Holiday Date] from [ERD_Enterprise_Holiday_List])
GO
