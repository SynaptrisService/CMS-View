USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Get_Assign_Clinic_Details]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VW_Get_Assign_Clinic_Details] 
AS
With [Cancel_Clinic_Data_assign] 
as
(
	select * from 
	(
	select 'Regular' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Originating Process],NULL [Assign Start Time],NULL [Assign End Time] from [dbo].[Clinic_Regular_Schedule_Detail] A with(nolock) 
	
	WHERE NOT EXISTS
	(
	select '' from
	(
	SELECT *,isnull
		((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category with(nolock)
		where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		and cast([Start Time Maximum Value] as time)
		and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		and cast([End Time Maximum Value] as time))),'All Day') [Clinic Hours Category]	FROM Provider_Assigned_Clinics a with(nolock)
		union all
		select  *,isnull
		((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category with(nolock)
		where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		and cast([Start Time Maximum Value] as time)
		and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		and cast([End Time Maximum Value] as time))),'All Day') [Clinic Hours Category] from [Provider_Assigned_Clinics_History]  a with(nolock)
		where [Clinic Notes]='APC Removed due to Generic clinic cancel' and cast([Clinic Date] as date)>=cast(getdate() as date))b
		
		 WHERE isnull(A.[Clinic Date],'')=isnull(B.[Clinic Date],'')
	and isnull(A.[Clinic Type],'')=isnull(B.[Clinic Type],'') and isnull(A.[Clinic Specialty],'')=isnull(B.[Clinic Specialty],'') 
	--and isnull(A.[Clinic Duration],'')=isnull(B.[Clinic Duration],'') 
	--and isnull(A.[Provider],'')<>''	
	and 
		(
		(cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time))
		or a.[Clinic Hours Category]=b.[Clinic Hours Category]
		) and isnull(A.[Location],'')=isnull(B.[Location],''))
	union all
	select 'Add Clinic' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],
	[Employee Login ID],replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'') +isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')+isnull(convert(varchar(8),CONVERT(date, [Clinic Date], 103) , 112),''),',',''),' ','') [Kezava Unique ID]
	,[Originating Process],NULL [Assign Start Time],NULL [Assign End Time]  from [dbo].Add_Clinic A with(nolock) WHERE NOT EXISTS
	(SELECT '' FROM Provider_Assigned_Clinics B with(nolock) WHERE isnull(A.[Clinic Date],'')=isnull(B.[Clinic Date],'')
	and isnull(A.[Clinic Type],'')=isnull(B.[Clinic Type],'') and isnull(A.[Clinic Specialty],'')=isnull(B.[Clinic Specialty],'') and isnull(A.[Clinic Duration],'')=isnull(B.[Clinic Duration],'') 
	and isnull(A.[Provider],'')<>''	and   isnull(cast(A.[Clinic Start Time]as time),'')=isnull(cast(B.[Clinic Start Time]as time),'') and  isnull(cast(A.[Clinic end Time]as time),'')
	=isnull(cast(B.[Clinic end Time] as time),'') and isnull(A.[Location],'')=isnull(B.[Location],''))
	union all
	select 'Assign Provider Clinic' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],Null [Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],NULL [No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Originating Process], [Assign Start Time], [Assign End Time]  from [dbo].Provider_Assigned_Clinics A with(nolock)
	
	) Z

	
),
Dataset_Assign as 
(
	select [Created On],[Type],Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied],[Clinic Date],[Clinic Start Time],
	[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Clinic Type],[Clinic Specialty],[Employee Login ID],[Kezava Unique ID],[Originating Process],[Assign Start Time],[Assign End Time] 
	from [Cancel_Clinic_Data_assign] a with(nolock)
	where not exists
	(
	select '' from (
	select Distinct [Kezava Unique ID],[Created On] from [Cancel_Clinic] with(nolock)--where [Cancel Confirmation]='Yes'
	union all
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_45_Cancel Clinic] with(nolock)--where [Cancel Confirmation]='Yes'
	union all
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_48_Add Clinic] with(nolock) --where [Cancel Confirmation]='Yes'
	union all
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_47_Limit Clinic Schedule] with(nolock)--where [Cancel Confirmation]='Yes'
	union all
	select Distinct [Kezava Unique ID],[Created On] from .[dbo].[2_49_Shorten Clinic] with(nolock)
	)b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') and b.[Created On]>a.[Created On]
	)
)


select distinct [Created On],[Type]
      ,[Clinic Date]
      ,[Advance Notice Period]
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
	 , [Room Number]
      ,[No of Participants]
      ,[Workspaces Occupied]
      ,[Multi Specialty Clinic]
      ,[Employee Login ID]
      ,[Kezava Unique ID]
      ,[Originating Process]
	  ,[Assign Start Time],[Assign End Time]  
	  from 
(
select  [Created On],[Type],[Clinic Date], NULL [Advance Notice Period],
NULL [Request Notice Period In Weeks],
replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')[Clinic Start Time],
replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')[Clinic End Time],
(replace(replace(right(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')+ ' To ' +replace(replace(right(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM'))[Scheduled Clinic Time],
[Clinic Duration],[Clinic Hours Category],[Location],[Clinic Type],[Clinic Specialty],[Provider],[Building],[Floor],[Wing],Suite,[Room Name],[Room Number],
[No of Participants],[Workspaces Occupied],''[Multi Specialty Clinic],[Employee Login ID],[Kezava Unique ID],[Originating Process],[Assign Start Time],[Assign End Time] 
from(
select a.* from Dataset_Assign a with(nolock) 
)a
)a

GO
