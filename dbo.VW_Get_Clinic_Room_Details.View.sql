USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Get_Clinic_Room_Details]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE VIEW [dbo].[VW_Get_Clinic_Room_Details] 
AS
With [Cancel_Clinic_Data] 
as
(
	select * from 
	(select 'Regular' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time]
	,[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name]
	,[No of Participants],[Workspaces Required][Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Originating Process],NULL [Assign Start Time],NULL [Assign End Time]
	,[Room Number],[Mode of Delivery],[DEP Name]
	from [dbo].[Clinic_Regular_Schedule_Detail] A 
	--WHERE NOT EXISTS
	--(SELECT '' FROM Provider_Assigned_Clinics B WHERE isnull(A.[Clinic Date],'')=isnull(B.[Clinic Date],'')
	--and isnull(A.[Clinic Type],'')=isnull(B.[Clinic Type],'') and isnull(A.[Clinic Specialty],'')=isnull(B.[Clinic Specialty],'') 
	----and isnull(A.[Clinic Duration],'')=isnull(B.[Clinic Duration],'') 
	----and isnull(A.[Provider],'')<>''	
	--and   isnull(cast(A.[Clinic Start Time]as time),'')=isnull(cast(B.[Clinic Start Time]as time),'') and  isnull(cast(A.[Clinic end Time]as time),'')
	--=isnull(cast(B.[Clinic end Time] as time),'') and isnull(A.[Location],'')=isnull(B.[Location],''))
	
	union
	select 'Add Clinic' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[No of Participants],[Workspaces Required][Workspaces Occupied],
	[Employee Login ID],replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'') +isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')+isnull(convert(varchar(8),CONVERT(date, [Clinic Date], 103) , 112),''),',',''),' ','') [Kezava Unique ID]
	,[Originating Process],NULL [Assign Start Time],NULL [Assign End Time],[Room Number],[Mode of Delivery],[DEP Name]   from [dbo].Add_Clinic A 
	--WHERE NOT EXISTS
	--(SELECT '' FROM Provider_Assigned_Clinics B WHERE isnull(A.[Clinic Date],'')=isnull(B.[Clinic Date],'')
	--and isnull(A.[Clinic Type],'')=isnull(B.[Clinic Type],'') and isnull(A.[Clinic Specialty],'')=isnull(B.[Clinic Specialty],'') and isnull(A.[Clinic Duration],'')=isnull(B.[Clinic Duration],'') 
	--and isnull(A.[Provider],'')<>''	and   isnull(cast(A.[Clinic Start Time]as time),'')=isnull(cast(B.[Clinic Start Time]as time),'') and  isnull(cast(A.[Clinic end Time]as time),'')
	--=isnull(cast(B.[Clinic end Time] as time),'') and isnull(A.[Location],'')=isnull(B.[Location],''))
	union
	select 'Limit Additional' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Originating Process],NULL [Assign Start Time],NULL [Assign End Time] ,''[Room Number]  ,[Mode of Delivery],[DEP Name]
	from [dbo].[Limit_Clinic_Schedule] A 
	--WHERE NOT EXISTS
	--(SELECT '' FROM Provider_Assigned_Clinics B WHERE isnull(A.[Clinic Date],'')=isnull(B.[Clinic Date],'')
	--and isnull(A.[Clinic Type],'')=isnull(B.[Clinic Type],'') and isnull(A.[Clinic Specialty],'')=isnull(B.[Clinic Specialty],'') and isnull(A.[Clinic Duration],'')=isnull(B.[Clinic Duration],'') 
	--and isnull(A.[Provider],'')<>''	and   isnull(cast(A.[Clinic Start Time]as time),'')=isnull(cast(B.[Clinic Start Time]as time),'') and  isnull(cast(A.[Clinic end Time]as time),'')
	--=isnull(cast(B.[Clinic end Time] as time),'') and isnull(A.[Location],'')=isnull(B.[Location],''))
		union
	select 'Shorten Clinic' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Originating Process],NULL [Assign Start Time],NULL [Assign End Time] ,[Room Number] ,[Mode of Delivery],[DEP Name]
	from [dbo].[Shorten_Clinic_Detail] A 
	----WHERE NOT EXISTS
	----(SELECT '' FROM Provider_Assigned_Clinics B WHERE isnull(A.[Clinic Date],'')=isnull(B.[Clinic Date],'')
	----and isnull(A.[Clinic Type],'')=isnull(B.[Clinic Type],'') and isnull(A.[Clinic Specialty],'')=isnull(B.[Clinic Specialty],'') and isnull(A.[Clinic Duration],'')=isnull(B.[Clinic Duration],'') 
	----and isnull(A.[Provider],'')<>''	and   isnull(cast(A.[Clinic Start Time]as time),'')=isnull(cast(B.[Clinic Start Time]as time),'') and  isnull(cast(A.[Clinic end Time]as time),'')
	----=isnull(cast(B.[Clinic end Time] as time),'') and isnull(A.[Location],'')=isnull(B.[Location],''))
	) Z

	
),
Dataset as 
(
	select [Created On],[Type],Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number] ,[No of Participants],[Workspaces Occupied],[Clinic Date],[Clinic Start Time],
	[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Clinic Type],[Clinic Specialty],[Employee Login ID],[Kezava Unique ID],[Originating Process],[Assign Start Time],[Assign End Time],[Mode of Delivery],[DEP Name] 
	from [Cancel_Clinic_Data] a
	where not exists
	(
	select '' from (
	select Distinct [Kezava Unique ID],[Created On] from [Cancel_Clinic] --where [Cancel Confirmation]='Yes'
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_45_Cancel Clinic] --where [Cancel Confirmation]='Yes'
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_48_Add Clinic] --where [Cancel Confirmation]='Yes'
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_47_Limit Clinic Schedule] --where [Cancel Confirmation]='Yes'
	union
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_49_Shorten Clinic] 
	)b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') and b.[Created On]>a.[Created On]
	)
),
FinalDataset as
(
select distinct a.* from Dataset a inner join (select max([Created On])[Created On],[Kezava Unique ID] 
from Dataset group by [Kezava Unique ID])b on a.[Created On]=b.[Created On] 
and isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'')
)
select [Type]
      ,[Clinic Date]
      ,replace(replace(replace([Advance Notice Period],'0 Week,',''),', 0 Day',''),'0 Day',' 0') [Advance Notice Period]
      ,[Request Notice Period In Weeks]
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
      ,[Originating Process],[Assign Start Time],[Assign End Time],[Mode of Delivery],[DEP Name]  from (
select distinct [Type],[Clinic Date],'Advance Notice - '+ Convert(VARCHAR(20), abs(datediff(dd,getdate(),[Clinic Date]))/7 )+
case when (abs(datediff(dd,getdate(),[Clinic Date]))/7) <=1 then ' Week' else ' Weeks' end   +', '+
Convert(VARCHAR(20),abs(datediff(dd,getdate(),[Clinic Date]) )%7) + case when (abs(datediff(dd,getdate(),[Clinic Date]) )%7)<=1 then' Day' else' Days' end  [Advance Notice Period],
abs(datediff(dd,getdate(),[Clinic Date]))/7 [Request Notice Period In Weeks],
replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')[Clinic Start Time],
replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')[Clinic End Time],
(replace(replace(right(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')+ ' To ' +replace(replace(right(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM'))[Scheduled Clinic Time],
[Clinic Duration],[Clinic Hours Category],[Location],[Clinic Type],[Clinic Specialty],[Provider],[Building],[Floor],[Wing],Suite,[Room Name],[Room Number] ,
[No of Participants],[Workspaces Occupied],''[Multi Specialty Clinic],[Employee Login ID],[Kezava Unique ID],[Originating Process],[Assign Start Time],[Assign End Time] ,[Mode of Delivery],[DEP Name]
from FinalDataset
)a













GO
