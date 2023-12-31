USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Calendar]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Clinic_Calendar]
AS 
WITH Calendar
as
(
Select distinct a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] ,a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
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
and not exists (select '' from Calendar b where a.[Provider]=b.[Provider] 
and b.[Originating Process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress','Clinic Regular Schedule InProgress')
and a.[Clinic Date] >b.[Clinic Date])
union 
select * from Calendar a where 
[originating process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress','Clinic Regular Schedule InProgress',
'Add Provider Clinic','Add Clinic','Add Room Only Schedule','Add As Covering Provider','Cancel Provider Clinic','Cancel MDC Clinic','Cancel MDC Clinic Inprogress','Cancel Provider Clinic Inprogress'
,'Cancel Room Only Schedule','Cancel Room Only Schedule Inprogress','Shorten Provider Clinic','Shorten Provider Clinic Inprogress','Shorten Room Only Clinic','Shorten Room Only Clinic Inprogress',
'Edit Provider Clinic','Edit Provider Clinic Inprogress','Limit Provider Schedule','Limit Provider Schedule Inprogress','Limit Room Only Schedule','Limit Room Only Schedule Inprogress','Limit Clinic Schedule',
'Limit Clinic Schedule Inprogress','Cancel Clinic','Cancel Clinic Inprogress','Shorten Clinic','Shorten Clinic Inprogress','Assign Provider Clinic')
)
Select * from Calendar_Final

/*
WITH [RegualrSchedule] as
(
select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[Clinic Specialty],
PR.Location,PR.[Clinic Duration] ,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],'' [Linked Clinic Name]
from [dbo].Provider_Regular_Schedule_Detail PR
UNION
select PR.[Created On], isnull ([Originating Process],'Clinic Regular Schedule'), PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[Clinic Specialty],
PR.Location,PR.[Clinic Duration] ,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],'' [Linked Clinic Name]
from [dbo].Clinic_Regular_Schedule_Detail PR
UNION
select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[Clinic Specialty],
PR.Location,PR.[Clinic Duration] ,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],'' [Linked Clinic Name]
from [dbo].Provider_Irregular_Schedule_Detail PR
UNION
select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[Clinic Specialty],
PR.Location,PR.[Clinic Duration] ,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],'' [Linked Clinic Name]
from [dbo].Clinic_Irregular_Schedule_Detail PR
UNION
select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[Clinic Specialty],
PR.Location,PR.[Clinic Duration] ,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],'' [Linked Clinic Name]
from [dbo].[Add_Provider_Clinic] PR
UNION
select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[Clinic Specialty],
PR.Location,PR.[Clinic Duration] ,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],'' [Linked Clinic Name]
from [dbo].[Add_Clinic] PR
)
,
[Maxrecord] as 
(
selecT a.*, ROW_NUMBER() over(partition by a.[Kezava Unique ID] order by a.[Created On] desc) RowID from [RegualrSchedule]  a
)
selecT distinct a.*,b.Legends,b.[Color code], (select TOP 1 usr_user_seq_id from [dbo].usr_user u 
where isnull(u.usr_last_name+', '+ u.usr_first_name,'')=a.provider and u.usr_company_seq_id=1 and u.usr_status=1) Userid,
row_number()OVER(PARTITION BY A.[Clinic Date] ORDER BY A.[Clinic Date],A.[Clinic Start Time],A.provider) AS CalendarOrder
from [Maxrecord] a left join [dbo].[ERD_Clinic_Calendar_Panel_Color] b on 1=1 --where a.[Originating Process]=b.[Originating Process]
where RowID=1 and [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 
*/
GO
