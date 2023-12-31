USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Get_Provider_Clinic_Details]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[VW_Get_Provider_Clinic_Details]
as
With [Cancel_Clinic] 
as
(
	select * from (select 'Regular' [Type],[Created On],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name] from [dbo].[Provider_Regular_Schedule_Detail] a
	  where  [Clinic Date] not in(select [Holiday Date] from [ERD_Enterprise_Holiday_List])
	  and not exists (select '' from [Edit_Provider_Clinic_Specialty] b where a.[Kezava Unique ID]=b.[Kezava Unique ID] and a.provider=b.Provider )
	  and not exists (
	  select '' from [Convert_Provider_Clinic] c 
	  where a.[Clinic Date]=c.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(c.[Clinic Start Time] as time)
	  and cast(a.[Clinic End Time] as time)=cast(c.[Clinic End Time] as time) and a.[Provider]=c.[Provider]
	  )
	  --union all
	--select 'Irregular' [Type],[Created On],[Clinic Date],[Clinic Start Time], [Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	--[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Required][Workspaces Occupied],
	--[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name] from [dbo].[Provider_Irregular_Schedule_Detail] 
	union all
	select 'Limit Additional' [Type],[Created On],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name] from [dbo].[Limit_Provider_Schedule] 
	Union All
	select 'Convert Clinic' [Type],[Created On],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Duration],[Clinic Hours Category],'Telehealth VO'Location,
	[Clinic Type],[Clinic Specialty], Provider,''Building,''[Floor],''Wing,''Suite,''[Room Name],''[Room Number],[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],'Telehealth'[Mode of Delivery],''[DEP Name] from [dbo].[Convert_Provider_Clinic] 
	union all
	select 'Add' [Type],[Created On],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,
	[Clinic Type],[Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],''[Workspaces Occupied],
	[Employee Login ID]
	,isnull([Kezava Unique ID],replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')+isnull(convert(varchar(8),CONVERT(date, [Clinic Date], 103) , 112),''),',',''),' ',''))[Kezava Unique ID],
	[Mode of Delivery],[DEP Name]
	 from [dbo].[Add_Provider_Clinic] a
	 where isnull([clinic date],'')!='' and not exists (select '' from [Edit_Provider_Clinic_Specialty] b where a.[Kezava Unique ID]=b.[Kezava Unique ID] and a.provider=b.Provider )
	union all
	select 'Edit Provider' [Type],[Created On],[Clinic Date],
	Case when [Edit Clinic]='Edit Clinic' then cast([Clinic Start Time] as time)  else cast([Edit Clinic Start Time] as time) end as [Clinic Start Time]
	,Case when [Edit Clinic]='Edit Clinic' then cast([Clinic End Time] as time)  else cast([Edit Clinic End Time] as time) end  as [Clinic End Time]
	,[Clinic Duration],isnull((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
		where (cast([Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		and cast([Start Time Maximum Value] as time)
		and cast([Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		and cast([End Time Maximum Value] as time))),'All Day')
	[Clinic Hours Category],Location,[Clinic Type],
	 [Edit Clinic Specialty]  as [Clinic Specialty], Provider,Building,[Floor],Wing,Suite,[Room Name], [Room Number],[No of Participants],[Workspaces Occupied],
	[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name] from [dbo].[Edit_Provider_Clinic_Specialty] 
	union all
	SELECT 'Shorten Provider' [TYPE], [Created On], [Clinic Date], cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Duration],[Clinic Hours Category]
	,Location,[Clinic Type], [Clinic Specialty],Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied]
	,[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name]
	from [Shorten_Provider_Clinic_Detail] a where not exists (select '' from [Shorten_Provider_Clinic] b where a.[Kezava Unique ID]=b.[Kezava Unique ID] 
	and a.provider=b.Provider and a.[Clinic Start Time]=b.[Clinic Start Time] and a.[Clinic End Time]=b.[Clinic End Time]
	)
	) Z
)
,
Dataset as 
(
	select [Created On],[Type],Provider,Building,[Floor],Wing,Suite,[Room Name],[Room Number],[No of Participants],[Workspaces Occupied],[Clinic Date],[Clinic Start Time],
	[Clinic End Time],[Clinic Duration],[Clinic Hours Category],Location,[Clinic Type],[Clinic Specialty],[Employee Login ID],[Kezava Unique ID] ,[Mode of Delivery],[DEP Name]
	from [Cancel_Clinic] a 
	where [clinic date] >= cast(getdate() as date) and not exists
	(
	select '' from (
	select distinct  [Kezava Unique ID],[Created On],Provider,cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Specialty],[Clinic Date],Location,[Clinic Hours Category] from [Cancel_Provider_Clinic] --where [Cancel Confirmation]='Yes'
	union all
	select  [Kezava Unique ID],[Created On],Provider,cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Specialty],[Clinic Date],Location,[Clinic Hours Category]from [dbo].[2_34_Cancel Provider Clinic] --where [Cancel Confirmation]='Yes'
	union all 
	select  [Kezava Unique ID],[Created On],Provider,cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Specialty],[Clinic Date],Location,[Clinic Hours Category]from .[dbo].[2_43_Shorten Provider Clinic]
	union all 
	select [Kezava Unique ID],[Created On],Provider,cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Specialty],[Clinic Date],Location,[Clinic Hours Category] from .[dbo]. [2_101_Convert Provider Clinic to Telehealth]
	union all 
	select  [Kezava Unique ID],[Created On],Provider,cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Specialty],[Clinic Date],Location,[Clinic Hours Category] from .[dbo]. [2_44_Edit Provider Clinic Specialty]
	union all 
	select  [Kezava Unique ID],[Created On],Provider,cast([Clinic Start Time] as time)[Clinic Start Time],cast([Clinic End Time] as time)[Clinic End Time],[Clinic Specialty],[Clinic Date],Location,[Clinic Hours Category] from .[dbo].[2_46_Limit Provider Schedule]
	)b where isnull(a.Provider,'')=isnull(b.Provider,'') 
	--and isnull(a.[Clinic Specialty],'')=isnull(b.[Clinic Specialty],'')
	and isnull(a. [Clinic Date],'')=isnull(b.[Clinic Date],'') 
	--and cast(a.[Clinic Start Time]as time)=cast(b.[Clinic Start Time]as time)
	--and cast(a.[Clinic End Time]as time)=cast(b.[Clinic End Time]as time)
	and (
	(a.[Clinic Start Time]  between b.[Clinic Start Time] and b.[Clinic End Time]
	or a.[Clinic End Time]  between b.[Clinic Start Time]  and b.[Clinic End Time]
	or b.[Clinic Start Time]  between a.[Clinic Start Time] and a.[Clinic End Time]
	or b.[Clinic End Time] between a.[Clinic Start Time] and a.[Clinic End Time]
	)
	and (a.[Clinic End Time]  != b.[Clinic Start Time]  
	and  a.[Clinic Start Time]  != b.[Clinic End Time])
	)
	--and a.Location=b.Location
	  and b.[Created On]>a.[Created On]
	)
)
select distinct [Type]
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
      ,[Kezava Unique ID],[Mode of Delivery],[DEP Name]
	  ,(select count(distinct [Appointment Time]) from [Patient_Appointment_Data_rank_table] z where --isnull([Visit Type],'')!=''
charindex(z.[Visit Provider],a.Provider)>0 and len(z.[Visit Provider])>1 and cast(z.[Appointment Date] as date)=cast(a.[clinic date] as date) 
 and cast(z.StartTime as time) between a.[CLinic Start Time] and a.[CLinic End Time]
  and cast(z.Endtime as time) between a.[CLinic Start Time]  and a.[CLinic End Time])  [No of Appointments Scheduled]
  from
  (
select [Type],[Clinic Date],abs(datediff(dd,getdate(),[Clinic Date]))/7 [Request Notice Period In Weeks]
,'Advance Notice - '+ Convert(VARCHAR(20),abs(datediff(dd,getdate(),[Clinic Date]))/7 )+
case when (abs(datediff(dd,getdate(),[Clinic Date]))/7) <=1 then ' Week' else ' Weeks' end   +', '+
Convert(VARCHAR(20),abs(datediff(dd,getdate(),[Clinic Date]) )%7) + case when (abs(datediff(dd,getdate(),[Clinic Date]) )%7)<=1 then' Day' else' Days' end [Advance Notice Period]
,replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')[Clinic Start Time],
replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')[Clinic End Time],
ltrim((replace(replace(right(Convert(VARCHAR(20),[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM')+ ' To ' +replace(replace(right(Convert(VARCHAR(20),[Clinic End Time],100),7),'AM',' AM'),'PM',' PM')))[Scheduled Clinic Time],
[Clinic Duration],[Clinic Hours Category],[Location],[Clinic Type],[Clinic Specialty],[Provider],[Building],[Floor],[Wing],Suite,[Room Name],[Room Number],
[No of Participants],[Workspaces Occupied],''[Multi Specialty Clinic],[Employee Login ID],[Kezava Unique ID],[Mode of Delivery],[DEP Name]
from
(
select a.* from Dataset a
 where not exists (select *
from Dataset b  where a.[Created On]<b.[Created On] 
and isnull(a.Provider,'')=isnull(b.Provider,'')
	and isnull(a.[Clinic Date],'')=isnull(b.[Clinic Date],'') 
	and a.Location=b.Location
	and
	(a.[Clinic Start Time]=b.[Clinic Start Time]
	or a.[Clinic End Time]=b.[Clinic End Time]
	and (a.[Clinic End Time] != b.[Clinic Start Time]  
	and  a.[Clinic Start Time] != b.[Clinic End Time])
	and  
	isnull(a. [Clinic Hours Category],'')=isnull(b.[Clinic Hours Category],'')
	)
	)
 )a)a
GO
