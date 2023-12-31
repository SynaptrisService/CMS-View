USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Cancel_Provider_Validation_ROCVsCAL]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create View [dbo].[VW_Cancel_Provider_Validation_ROCVsCAL]
As
with Canceldetails as
(
select [Created On],[Created By],[Clinic Date],[Provider],[Clinic Type],[Clinic Specialty],[Clinic Hours Category],[Location],
case when isnull([Room Number],'')!='' then 'Yes' when isnull([Room Name],'')!='' then 'Yes' else 'No' end as [Room Mandatory],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Originating Process],
concat(convert(varchar,[Clinic Date],112),replace(replace([Provider],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from [Cancel_Provider_Clinic] where [Clinic Date]>=getdate()-3
Union All 
select [Created On],[Created By],[Clinic Date],[Room Only Schedule Provider],''[Clinic Type],''[Clinic Specialty],[Clinic Hours Category],[Location],
case when isnull([Room Number],'')!='' then 'Yes' when isnull([Room Name],'')!='' then 'Yes' else 'No' end as [Room Mandatory],
cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],
[Originating Process],concat(convert(varchar,[Clinic Date],112),replace(replace([Room Only Schedule Provider],',',''),' ',''),
left(cast([Clinic Start Time] as time),5),left(cast([Clinic End Time] as time),5),[Location])[Uniquevalue]
from [Cancel_Room_Only_Schedule] where [Clinic Date]>=getdate()-3

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
from   Room_Assignment_Detail where [Clinic Date]>=getdate()-3 and [Division Name] =(select top 1 [Division Name] from Division_Detail)
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
,case when isnull(b.[clinic date],'')='' and isnull(c.[Clinic Date],'')!='' then c.[Originating Process] 
when isnull(b.[Clinic Date],'')!='' then b.[Originating Process]  
when a.[Room Mandatory]='No' then 'No need to check'
else 'No' end 'calendar display'
from Canceldetails a left join Divisioncalendar b
on a.[Uniquevalue]=b.[Uniquevalue]
and a.[Originating Process]=b.[Originating Process]
left join Roomassignment c on a.[Uniquevalue]=c.[Uniquevalue]
left join Roomoccupancy d on a.[Uniquevalue]=d.[Uniquevalue]
)
select * from Dataset where [Clinic Date] not in (select [Holiday Date] from [ERD_Enterprise_Holiday_List])



GO
