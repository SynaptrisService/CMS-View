USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_MDC_Get_Clinic_Detail_Bkp]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VW_MDC_Get_Clinic_Detail_Bkp] 
as 
WITH [RegualrSchedule] as
(
select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[MDC Clinic Specialty],PR.Location,
 dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,Suite
,[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Required][Workspaces Occupied]
from [dbo].MDC_Regular_Schedule_Detail PR 

UNION ALL

select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[MDC Clinic Specialty],
PR.Location,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,Suite,
[Room Name] [Room Name],[Kezava Unique ID],[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Required][Workspaces Occupied]
from MDC_Irregular_Schedule_Detail PR


UNION ALL

select PR.[Created On], pr.[Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],b.[MDC Clinic Specialty],PR.Location,
 dateadd(MINUTE,datepart(MINUTE,pr.[Clinic Start Time]),(dateadd(hour,datepart(hour,PR.[Clinic Start Time]),PR.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,PR.[Clinic end Time]),(dateadd(hour,datepart(hour,PR.[Clinic End Time]),PR.[Clinic Date])))[Clinic End Time],0 Ranks,PR.[Rooms Required] ,PR.Building
,PR.Floor,PR.wing,PR.Suite,PR.[Room Name] [Room Name],PR.[Kezava Unique ID],PR.[Employee Login ID],PR.[Division Name],b.[Division Notification],b.[Clinic Template],b.[Provider] AS [MDC Provider Name]
,PR.[Clinic Duration],PR.[Clinic Hours Category],PR.[No of Participants],PR.[Workspaces Required][Workspaces Occupied]
from [dbo].Provider_Regular_Schedule_Detail PR 

INNER join MDC_Regular_Schedule b on  b.[Clinic Type]=pr.[Clinic Type] and b.[MDC Clinic Specialty]=pr.[Clinic Specialty] 
and b.Location=pr.Location and pr.[Work Days]=b.[Work Days] where pr.[Clinic Date] BETWEEN b.[Schedule Start Date] and b.[Schedule End Date] and isnull(PR.[MDC Clinic],'') ='Yes'
and isnull(b.Provider,'')!=''

UNION ALL

select PR.[Created On], pr.[Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],b.[MDC Clinic Specialty],PR.Location,
 dateadd(MINUTE,datepart(MINUTE,pr.[Clinic Start Time]),(dateadd(hour,datepart(hour,PR.[Clinic Start Time]),PR.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,PR.[Clinic end Time]),(dateadd(hour,datepart(hour,PR.[Clinic End Time]),PR.[Clinic Date])))[Clinic End Time],0 Ranks,PR.[Rooms Required] ,PR.Building
,PR.Floor,PR.wing,PR.Suite,PR.[Room Name] [Room Name],PR.[Kezava Unique ID],PR.[Employee Login ID],PR.[Division Name],b.[Division Notification],b.[Clinic Template],b.[Provider] AS [MDC Provider Name]
,PR.[Clinic Duration],PR.[Clinic Hours Category],PR.[No of Participants],PR.[Workspaces Required][Workspaces Occupied]
from [dbo].Clinic_Regular_Schedule_Detail PR INNER join MDC_Regular_Schedule b on b.[Clinic Type]=pr.[Clinic Type] and b.[MDC Clinic Specialty]=pr.[Clinic Specialty] 
and b.Location=pr.Location and pr.[Work Days]=b.[Work Days] where pr.[Clinic Date] BETWEEN b.[Schedule Start Date] and b.[Schedule End Date] and isnull(PR.[MDC Clinic],'') ='Yes'
and isnull(b.Provider,'')=''

UNION ALL

select PR.[Created On], pr.[Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],b.[MDC Clinic Specialty],PR.Location,
 dateadd(MINUTE,datepart(MINUTE,pr.[Clinic Start Time]),(dateadd(hour,datepart(hour,PR.[Clinic Start Time]),PR.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,PR.[Clinic end Time]),(dateadd(hour,datepart(hour,PR.[Clinic End Time]),PR.[Clinic Date])))[Clinic End Time],0 Ranks,PR.[Rooms Required] ,PR.Building
,PR.Floor,PR.wing,PR.Suite,PR.[Room Name] [Room Name],PR.[Kezava Unique ID],PR.[Employee Login ID],PR.[Division Name],b.[Division Notification],b.[Clinic Template],b.[Provider] AS [MDC Provider Name]
,PR.[Clinic Duration],PR.[Clinic Hours Category],PR.[No of Participants],PR.[Workspaces Required][Workspaces Occupied]
from [dbo].Clinic_Irregular_Schedule_Detail PR INNER join MDC_Irregular_Schedule b on b.[Clinic Type]=pr.[Clinic Type] and b.[MDC Clinic Specialty]=pr.[Clinic Specialty] 
and b.Location=pr.Location  where pr.[Clinic Date] BETWEEN b.[Schedule Start Date] and b.[Schedule End Date] and isnull(PR.[MDC Clinic],'') ='Yes' and isnull(b.Provider,'')=''

UNION ALL

select PR.[Created On], pr.[Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],b.[MDC Clinic Specialty],PR.Location,
 dateadd(MINUTE,datepart(MINUTE,pr.[Clinic Start Time]),(dateadd(hour,datepart(hour,PR.[Clinic Start Time]),PR.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,PR.[Clinic end Time]),(dateadd(hour,datepart(hour,PR.[Clinic End Time]),PR.[Clinic Date])))[Clinic End Time],0 Ranks,PR.[Rooms Required] ,PR.Building
,PR.Floor,PR.wing,PR.Suite,PR.[Room Name] [Room Name],PR.[Kezava Unique ID],PR.[Employee Login ID],PR.[Division Name],b.[Division Notification],b.[Clinic Template],b.[Provider] AS [MDC Provider Name]
,PR.[Clinic Duration],PR.[Clinic Hours Category],PR.[No of Participants],PR.[Workspaces Required][Workspaces Occupied]
from [dbo].Provider_Irregular_Schedule_Detail PR INNER join MDC_Irregular_Schedule b on  b.[Clinic Type]=pr.[Clinic Type] and b.[MDC Clinic Specialty]=pr.[Clinic Specialty] 
and b.Location=pr.Location  where pr.[Clinic Date] BETWEEN b.[Schedule Start Date] and b.[Schedule End Date] and isnull(PR.[MDC Clinic],'') ='Yes'
and isnull(b.Provider,'')!=''

UNION ALL 

select  LPH.[Created On], [Originating Process], LPH.[Clinic Date] , LPH.Provider provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],LPH.Location,
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic Start Time]),(dateadd(hour,datepart(hour,LPH.[Clinic Start Time]),LPH.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic end Time]),(dateadd(hour,datepart(hour,LPH.[Clinic End Time]),LPH.[Clinic Date]))) [Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Suite,
Floor,wing ,LPH.[Room Name] [Room Name],LPH.[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Cancel_MDC_Clinic] LPH

UNION ALL 
select LPH.[Created On],  concat([Originating Process],' In Progress')[Originating Process], LPH.[Clinic Date] , [MDC Provider Name]as  provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],
LPH.Location, dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Floor,wing,Suite,
LPH.[Room Name] [Room Name],LPH.[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Kezava_DM_V3_Neurology].[dbo].[2_54_Cancel MDC Clinic] LPH
UNION ALL 

select  LPH.[Created On], [Originating Process], LPH.[Clinic Date] , LPH.Provider provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],LPH.Location,
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic Start Time]),(dateadd(hour,datepart(hour,LPH.[Clinic Start Time]),LPH.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic end Time]),(dateadd(hour,datepart(hour,LPH.[Clinic End Time]),LPH.[Clinic Date]))) [Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Suite,
Floor,wing ,LPH.[Room Name] [Room Name],LPH.[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Shorten_MDC_Clinic_Detail] LPH

UNION ALL 

select LPH.[Created On],  concat([Originating Process],' In Progress')[Originating Process], LPH.[Clinic Date] , [MDC Provider Name]as  provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],
LPH.Location, dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Floor,wing,Suite,
LPH.[Room Name] [Room Name],LPH.[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Kezava_DM_V3_Neurology].[dbo].[2_60_Shorten MDC Clinic] LPH
),
[Maxrecord]
as 
(
/* In Progress Records Only and Rank Order [Kava Unique ID]*/
selecT *, DENSE_RANK() over(partition by [Kezava Unique ID] order by a.[Kezava Unique ID] desc) RowID from [RegualrSchedule] a where 
[Originating Process] in ('Cancel MDC Clinic In Progress')

UNION
/* Except (Cancel Provider Hours) Confimed records !=In Progress all Records and Rank Order [Created On]*/
selecT a.*, DENSE_RANK() over(partition by a.[Kezava Unique ID] order by a.[Created On] desc) RowID from [RegualrSchedule] a  where [Originating Process] in ('Cancel MDC Clinic')
and not EXISTS (select '' from [RegualrSchedule] b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') 
and b.[Originating Process] in ('Cancel MDC Clinic In Progress') and b.[Created On] > a.[Created On])

UNION

/* Cancel Provider Hours Confimed records != All Confirmed Records,In Progress Records  and Rank Order [Kezava Unique ID]*/
selecT *, DENSE_RANK() over(partition by [Kezava Unique ID] order by a.[Kezava Unique ID] desc) RowID from [RegualrSchedule] a where [Originating Process] in ('MDC Shorten Hours')
and not exists (select '' from [RegualrSchedule] b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') and b.[Originating Process] in ('Cancel MDC Clinic','Cancel MDC Clinic In Progress')
and a.[Clinic Start Time]=b.[Clinic Start Time] and a.[Clinic End Time]=b.[Clinic End Time] and b.[Created On]>a.[Created On] )

UNION

/* Except Confrimed Records and In Progress Records*/
selecT a.*, ROW_NUMBER() over(partition by a.[Kezava Unique ID] order by a.[Created On] desc) RowID from [RegualrSchedule]  a
where not EXISTS (select '' from [RegualrSchedule] b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') 
and [Originating Process] in ('Cancel MDC Clinic','Cancel MDC Clinic In Progress','MDC Shorten Hours','MDC Shorten Hours In Progress'))

)
selecT Distinct a.[Originating Process] as[Source Originating Process],a.[Clinic Date]
,abs(datediff(dd,getdate(),a.[Clinic Date]))/7 [Request Notice Period In Weeks]
,'Advance Notice - '+ Convert(VARCHAR(20),abs(datediff(dd,getdate(),a.[Clinic Date]))/7 )+
case when (abs(datediff(dd,getdate(),a.[Clinic Date]))/7) <=1 then ' Week' else ' Weeks' end   +', '+
Convert(VARCHAR(20),abs(datediff(dd,getdate(),a.[Clinic Date]) )%7) + case when (abs(datediff(dd,getdate(),a.[Clinic Date]) )%7)<=1 then' Day' else' Days' end [Advance Notice Period],
a.[Clinic Start Time],a.[Clinic End Time], RIGHT(Convert(VARCHAR(20), a.[Clinic Start Time],100),7) + ' To ' + RIGHT(Convert(VARCHAR(20), a.[Clinic End Time],100),7) as [Scheduled Clinic Time],
a.[Location],a.[Clinic Type], isnull(A.[Provider],'') as [Provider],a.[MDC Clinic Specialty],isnull(a.[Building],'')[Building],isnull(a.[Floor],'') as [Floor],isnull(a.[Wing],'')[Wing],isnull(a.[Suite],'')[Suite],
isnull(a.[Room Name],'') as [Room Name],A.[Kezava Unique ID],[Division Name],[Division Notification],
STUFF((select distinct ';' + B.[Division Name] from [Maxrecord] B WHERE A.[MDC Clinic Specialty]=B.[MDC Clinic Specialty] AND A.[Clinic Date]=B.[Clinic Date] FOR XML PATH('')),1,1,'') AS [Reference Division Name],
isnull([MDC Provider Name],'') AS [MDC Provider Name],[Clinic Template]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Maxrecord] a where a.[clinic date] not in (select [Holiday Date] from [V3_ERD].[dbo].[Enterprise_Holiday_List]) 
and a.[Originating Process] Not in ('Cancel MDC Clinic','Cancel MDC Clinic In Progress','MDC Shorten Hours In Progress') 





GO
