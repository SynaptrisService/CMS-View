USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_GET_Provider_Clinic_Details_Patinet_Cycle_Time_Calculation]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[VW_GET_Provider_Clinic_Details_Patinet_Cycle_Time_Calculation]
as
With [Cancel_Clinic] 
as
(
	select  * from 
	(
	select distinct [Originating Process],'Regular' [Type],[Created On],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name] from [dbo].[Provider_Regular_Schedule_Detail] a where isnull([clinic date],'')!='' 
	union all
	select distinct [Originating Process],'Add' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],''[Workspaces Occupied],[Employee Login ID]
	,isnull([Kezava Unique ID],replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')+isnull(convert(varchar(8),CONVERT(date, [Clinic Date], 103) , 112),''),',',''),' ',''))[Kezava Unique ID],
	[Mode of Delivery],[DEP Name]from [dbo].[Add_Provider_Clinic] a	where isnull([clinic date],'')!='' 
	union all
	SELECT [Originating Process],'Shorten Provider' [TYPE], [Created On], [Clinic Date], [Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category]
	,Location,[Clinic Type], [Clinic Specialty],Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied]
	,[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name]
	from [Shorten_Provider_Clinic_Detail] a where not exists (select '' from [Shorten_Provider_Clinic] b where a.[Kezava Unique ID]=b.[Kezava Unique ID] 
	and a.provider=b.Provider and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time))
	union all
	select [Originating Process],'Assign Provider To Clinic' [Type],[Created On],[Clinic Date],[Assign Start Time] [Clinic Start Time] ,[Assign End Time] [Clinic End Time],[Clinic Duration],
	(select top 1 [Clinic Hours Category] as [Hours Category] from [V3_ERD].[dbo].Clinic_Hours_Category
	where (cast([Assign Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) and cast([Start Time Maximum Value] as time)
	and cast([Assign End Time] as time) BETWEEN cast([End Time Minimum Value] as time) and cast([End Time Maximum Value] as time)))  as [Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],0 [No of Participants],''[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name]
	from [dbo].Provider_Assigned_Clinics a
	) A where not exists  (select '' from Cancel_Provider_Clinic B WHERE isnull(a.Provider,'')=isnull(b.Provider,'') 
	--and isnull(a.[Clinic Specialty],'')=isnull(b.[Clinic Specialty],'')
	and isnull(a. [Clinic Date],'')=isnull(b.[Clinic Date],'') and cast(a.[Clinic Start Time]as time)=cast(b.[Clinic Start Time]as time)
	and cast(a.[Clinic End Time]as time)=cast(b.[Clinic End Time]as time) and a.Location=b.Location and a.[Type] in ('Regular','Add','Shorten Provider') 
	and b.[Created On]>a.[Created On])
	)
	select a.*,B.PROV_ID from [Cancel_Clinic] a LEFT JOIN
				(
				select isnull(a.PROVID,'') as PROV_ID,RTRIM(a.[Full Name]) AS [Full Name] from employee_master a where [User Authentication]='Yes' and [employee type] ='Provider' 
				)b on rtrim(a.PROVIDER)=b.[Full Name]
	where not exists 
	(select * from [Cancel_Clinic] b  where a.[Created On]<b.[Created On] and isnull(a.Provider,'')=isnull(b.Provider,'')
	and isnull(a. [Clinic Date],'')=isnull(b.[Clinic Date],'') and a.Location=b.Location and isnull(a.[Clinic Specialty],'')=isnull(b.[Clinic Specialty],'')
	and
	(cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
	or cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time)
	and (cast(a.[Clinic End Time] as time) != cast(b.[Clinic Start Time] as time)
	and  cast(a.[Clinic Start Time] as time) != cast(b.[Clinic End Time] as time))
	and  
	isnull(a.[Clinic Hours Category],'')=isnull(b.[Clinic Hours Category],'')
	)) 
GO
