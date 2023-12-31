USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Get_Convert_Provider_Clinic]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VW_Get_Convert_Provider_Clinic]
as

With [Cancel_Clinic] 
as
(
	select * from (select 'Regular' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[Dep Name] from [dbo].[Provider_Regular_Schedule_Detail] 
	union
	select 'Limit Additional' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],''[Room Number],[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[Dep Name]  from [dbo].[Limit_Provider_Schedule] 
	union
	select 'Add' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],''[Workspaces Occupied],
	[Employee Login ID]
	,replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'') +isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')+isnull(convert(varchar(8),CONVERT(date, [Clinic Date], 103) , 112),''),',',''),' ','') [Kezava Unique ID]
	,[Mode of Delivery],[Dep Name]  from [dbo].[Add_Provider_Clinic] 
	union
	select 'Edit Provider' [Type],[Created On],[Clinic Date],[Edit Clinic Start Time] as [Clinic Start Time],[Edit Clinic End Time] as [Clinic End Time]
	,[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],''[Room Number],[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[Dep Name]   from [dbo].[Edit_Provider_Clinic_Specialty] 
	Union
	select 'Assigned Clinic' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],''[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],''[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery], [Dep Name]   from [dbo].[Provider_Assigned_Clinics] 
	union
	SELECT 'Shorten Provider' [TYPE], [Created On], [Clinic Date], [Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category]
	,Location,[Clinic Type], [Clinic Specialty],Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied]
	,[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[Dep Name]  
	from [Shorten_Provider_Clinic_Detail] a where not exists (select '' from [Shorten_Provider_Clinic] b where a.[Kezava Unique ID]=b.[Kezava Unique ID] 
	and a.provider=b.Provider and a.[Clinic Start Time]=b.[Clinic Start Time] and a.[Clinic End Time]=b.[Clinic End Time]
	)
	) Z  
)
--select * from [Cancel_Clinic]
,
Dataset as 
(
	select [Created On],[Type],Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied],[Clinic Date],[Clinic Start Time],
	[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Clinic Type],[Clinic Specialty],[Employee Login ID],[Kezava Unique ID] ,[Mode of Delivery],[Dep Name] 
	from [Cancel_Clinic] a
	where not exists
	(
	select '' from (
	select Distinct [Kezava Unique ID],[Created On] from [Cancel_Provider_Clinic] --where [Cancel Confirmation]='Yes'
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_34_Cancel Provider Clinic] --where [Cancel Confirmation]='Yes'
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_43_Shorten Provider Clinic]
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_46_Limit Provider Schedule]
	)b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') and b.[Created On]>a.[Created On]
	) and (isnull([Mode of Delivery],'') in ('In Person','Telehealth') and isnull([Room Number],'')!='')
)
,
FinalDataset as
(
select distinct a.* from Dataset a inner join (select max([Created On])[Created On],[Kezava Unique ID] 
from Dataset group by [Kezava Unique ID])b on a.[Created On]=b.[Created On] 
and a.[Kezava Unique ID]=b.[Kezava Unique ID]
)
select [Type]
      ,[Clinic Date]
      ,[Request Notice Period In Weeks]
      ,replace(replace(replace([Advance Notice Period],'0 Week,',''),', 0 Day',''),'0 Day',' 0') [Advance Notice Period]
	  ,[Clinic Start Time]
      ,[Clinic End Time]
      ,[Scheduled Clinic Time]
      ,[Clinic Duration]
      ,[Clinic Hours Category]
      ,[Location]
      ,[Clinic Type]
      ,[Clinic Specialty]
      ,[Provider]
      ,[Building]
      ,[Floor]
      ,[Wing]
      ,[Suite]
      ,[Room Name]
	  ,[Room Number]
      ,[No of Participants]
      ,[Workspaces Occupied]
      ,[Multi Specialty Clinic]
      ,[Employee Login ID]
      ,[Kezava Unique ID]
	  ,[Mode of Delivery],[Dep Name] 
	   from(

select distinct [Type],[Clinic Date],abs(datediff(dd,getdate(),[Clinic Date]))/7 [Request Notice Period In Weeks]
,'Advance Notice - '+ Convert(VARCHAR(20),abs(datediff(dd,getdate(),[Clinic Date]))/7 )+
case when (abs(datediff(dd,getdate(),[Clinic Date]))/7) <=1 then ' Week' else ' Weeks' end   +', '+
Convert(VARCHAR(20),abs(datediff(dd,getdate(),[Clinic Date]) )%7) + case when (abs(datediff(dd,getdate(),[Clinic Date]) )%7)<=1 then' Day' else' Days' end [Advance Notice Period]
,replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')[Clinic Start Time],
replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')[Clinic End Time],
ltrim((replace(replace(right(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')+ ' To ' +replace(replace(right(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')))[Scheduled Clinic Time],
[Clinic Duration],[Clinic Hours Category],[Location],[Clinic Type],[Clinic Specialty],[Provider],[Building],[Floor],[Wing],Suite,[Room Name],[Room Number],
[No of Participants],[Workspaces Occupied],''[Multi Specialty Clinic],[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[Dep Name] 
from FinalDataset
)a





GO
