USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Calendar_data_bck20210706]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[VW_Calendar_data_bck20210706]
as
WITH Calendar
as
(
Select distinct a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] [Provider or Room Only Name],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
a.[Clinic Start Time],a.[Clinic End Time],a.[Ranks],a.[Rooms Required],a.[Building],a.[Floor],a.[Wing],a.[Room Name],a.[Kezava Unique ID],a.[Employee Login ID],
a.[Linked Clinic Name],a.[RowID],a.[Legends],a.[Color code],a.[Userid],a.[CalendarOrder],a.[Display in Calendar]
FROM [Clinic_Calendar] a left join VW_Cancel_Clinics b on a.Provider=b.Provider
and a.[Clinic Date]=b.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(b.[Clinic Start Time]as time)
and cast(a.[Clinic End Time]as time)=cast(b.[Clinic End Time]as time)
and a.Location=b.Location and a.[Originating Process] in ('Provider Regular Schedule',
'Provider Regular Schedule InProgress','Provider Room Hold Schedule','Provider Room Hold Schedule InProgress','Room Only Regular Schedule','Room Only Regular Schedule InProgress')
where [Display in Calendar]='Yes' and isnull(b.provider,'')=''
and not exists(select '' from ERD_Enterprise_Holiday_List h where a.[Clinic Date]=h.[Holiday Date])
),
Calendar_Final
as
( 
select * from Calendar a where [originating process] in ('Provider Regular Schedule','Provider Room Hold Schedule','Room Only Regular Schedule','Clinic Regular Schedule')
and not exists (select '' from Calendar b where a.[Provider or Room Only Name]=b.[Provider or Room Only Name] 
and b.[Originating Process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress','Clinic Regular Schedule InProgress')
and a.[Clinic Date] >b.[Clinic Date])
union 

select * from Calendar a where 
[originating process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress','Clinic Regular Schedule InProgress',
'Add Provider Clinic','Add Clinic','Add Room Only Schedule','Add As Covering Provider','Cancel Provider Clinic','Cancel MDC Clinic','Cancel MDC Clinic Inprogress','Cancel Provider Clinic Inprogress'
,'Cancel Room Only Schedule','Cancel Room Only Schedule Inprogress','Shorten Provider Clinic','Shorten Provider Clinic Inprogress','Shorten Room Only Clinic','Shorten Room Only Clinic Inprogress',
'Edit Provider Clinic','Edit Provider Clinic Inprogress','Limit Provider Schedule','Limit Provider Schedule Inprogress','Limit Room Only Schedule','Limit Room Only Schedule Inprogress','Limit Clinic Schedule',
'Limit Clinic Schedule Inprogress','Cancel Clinic','Cancel Clinic Inprogress','Shorten Clinic','Shorten Clinic Inprogress','Assign Provider Clinic')
),
Cancel_Removed
as
(
select * from Calendar_Final a where [originating process] in ('Cancel Provider Clinic Inprogress','Cancel Room Only Schedule Inprogress','Limit Provider Schedule Inprogress','Shorten Provider Clinic Inprogress')
and not exists (select '' from Calendar b where a.[Provider or Room Only Name]=b.[Provider or Room Only Name] 
and b.[Originating Process] in ('Provider Regular Schedule','Provider Room Hold Schedule','Room Only Regular Schedule','Clinic Regular Schedule')
and b.[Created On] > a.[Created On] and a.[Kezava Unique ID] =b.[Kezava Unique ID])

)
Select *,Case when [originating process]='Provider Regular Schedule' then 'Provider Schedule'
when [originating process] ='Provider Regular Schedule InProgress' then 'Provider Schedule' Else [originating process] End as Stage
from Cancel_Removed 

-- Old query
/*
Select distinct a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] [Provider or Room Only Name],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
a.[Clinic Start Time],a.[Clinic End Time],a.[Ranks],a.[Rooms Required],a.[Building],a.[Floor],a.[Wing],a.[Room Name],a.[Kezava Unique ID],a.[Employee Login ID],
a.[Linked Clinic Name],a.[RowID],a.[Legends],a.[Color code],a.[Userid],a.[CalendarOrder],a.[Display in Calendar]
FROM [Clinic_Calendar] a left join VW_Cancel_Clinics b on a.Provider=b.Provider
and a.[Clinic Date]=b.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(b.[Clinic Start Time]as time)
and cast(a.[Clinic End Time]as time)=cast(b.[Clinic End Time]as time)
and a.Location=b.Location and a.[Originating Process] in ('Provider Regular Schedule',
'Provider Regular Schedule InProgress','Provider Room Hold Schedule','Provider Room Hold Schedule InProgress','Room Only Regular Schedule','Room Only Regular Schedule InProgress')
where [Display in Calendar]='Yes' and isnull(b.provider,'')=''
*/






GO
