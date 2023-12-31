USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Get_Room_Only_Cancel_Details]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_Get_Room_Only_Cancel_Details] 
as
With [Room_Only_Cancel] 
as
(
	select * from 
	(
	select 'Room only Regular' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Room Only Schedule Provider],Building,
	[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],[Kezava Unique ID],[Division Name],isnull([Schedule Notification],'No') [Schedule Notification]
	,[Mode of Delivery],[DEP Name]  from [dbo].[Room_Only_Regular_Schedule_Detail] 
	where [Clinic Date] not in(select [Holiday Date] from [ERD_Enterprise_Holiday_List])
	union
	select 'Add Room Only Schedule' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Room Only Schedule Provider],Building,
	[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],[Kezava Unique ID],[Division Name],isnull([Schedule Notification],'No') [Schedule Notification]
	,[Mode of Delivery],[DEP Name]  from [dbo].[Add_Room_Only_Schedule] 
	union
	select 'Shorten Room Only Schedule' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Room Only Schedule Provider],Building,
	[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied],[Kezava Unique ID],[Division Name],isnull([Schedule Notification],'No') [Schedule Notification]
	,[Mode of Delivery],[DEP Name]  from [dbo].[Shorten_Room_Only_Schedule_Detail] a
	where not exists (select '' from Shorten_Room_Only_Schedule b where a.[Kezava Unique ID]=b.[Kezava Unique ID] 
	and a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.[Clinic Start Time]=b.[Clinic Start Time] and a.[Clinic End Time]=b.[Clinic End Time]	)
	) Z
),
Dataset as 
(
	select [Created On],[Room Only Schedule Provider],Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied],[Clinic Date],[Clinic Start Time],
	[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Kezava Unique ID] ,[Division Name],[Schedule Notification],[Mode of Delivery],[DEP Name] 
	from [Room_Only_Cancel] a
	where not exists
	(
	select '' from (
	select Distinct [Kezava Unique ID],[Created On] from [Cancel_Room_Only_Schedule] 
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_57_Cancel Room Only Schedule] 
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_64_Limit Room Only Schedule] 
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_63_Shorten Room Only Schedule] 
	)b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') and b.[Created On] > a.[Created On]
	)
)
,
FinalDataset as
(
select distinct a.* from Dataset a inner join (select max([Created On])[Created On],[Kezava Unique ID] 
from Dataset group by [Kezava Unique ID])b on a.[Created On]=b.[Created On] 
and a.[Kezava Unique ID]=b.[Kezava Unique ID]
)
select [Clinic Date]
      ,[Request Notice Period In Weeks]
      ,replace(replace(replace([Advance Notice Period],'0 Week,',''),', 0 Day',''),'0 Day',' 0') [Advance Notice Period]
      ,[Clinic Start Time]
      ,[Clinic End Time]
      ,[Scheduled Clinic Time]
      ,[Clinic Duration]
      ,[Clinic Hours Category]
      ,[Location]
      ,[Room Only Schedule Provider]
      ,[Building]
      ,[Floor]
      ,[Wing]
      ,[Suite]
      ,[Room Name]
	  ,[Room Number]
      ,[No of Participants]
      ,[Workspaces Occupied]
      ,[Multi Specialty Clinic]
      ,[Kezava Unique ID]
      ,[Division Name]
	  ,[Schedule Notification]
	  ,[Mode of Delivery],[DEP Name] 
	   from (
select distinct [Clinic Date],abs(datediff(dd,getdate(),[Clinic Date]))/7 [Request Notice Period In Weeks]
,'Advance Notice - '+ Convert(VARCHAR(20),abs(datediff(dd,getdate(),[Clinic Date]))/7 )+
case when (abs(datediff(dd,getdate(),[Clinic Date]))/7) <=1 then ' Week' else ' Weeks' end   +', '+
Convert(VARCHAR(20),abs(datediff(dd,getdate(),[Clinic Date]) )%7) + case when (abs(datediff(dd,getdate(),[Clinic Date]) )%7)<=1 then' Day' else' Days' end [Advance Notice Period]
,replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')[Clinic Start Time],
replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')[Clinic End Time],
ltrim((replace(replace(right(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')+ ' To ' +replace(replace(right(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')))[Scheduled Clinic Time],
[Clinic Duration],[Clinic Hours Category],[Location],[Room Only Schedule Provider],[Building],[Floor],[Wing],Suite,[Room Name],[Room Number],
[No of Participants],[Workspaces Occupied],''[Multi Specialty Clinic],[Kezava Unique ID],[Division Name],[Schedule Notification],[Mode of Delivery],[DEP Name] 
from FinalDataset
)a

GO
