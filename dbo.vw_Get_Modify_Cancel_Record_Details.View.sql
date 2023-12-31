USE [V3_Neurology]
GO
/****** Object:  View [dbo].[vw_Get_Modify_Cancel_Record_Details]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[vw_Get_Modify_Cancel_Record_Details]
as
With Cancel_Reaon
as
(
select 'Provider' as [Select Type], [Created On] [Cancel Created On],[Originating Process] as [Source Of Originating Process],[Provider],Null as [Room Only Schedule Provider],[Clinic Start Date],[Clinic End Date],[Request Notice Period In Weeks],
[Clinic Date],[Clinic Hours Category],[Clinic Duration],cast([Clinic Start Time] as time) as [Clinic Start Time],cast([Clinic End Time] as time) as [Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],
[Location],[Building],[Floor],[Suite],[Room Name],[Room Number],[No of Participants],[Reason For Cancellation],replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
+isnull(convert(varchar(8),CONVERT(date, [clinic date], 103) , 112),''),',',''),' ','')[Kezava Unique ID],[Division Name],[Total No Scheduled Clinics],
[Mode of Delivery],[DEP Name],'Completed' as [Record Status] from Cancel_Provider_Clinic
union all
select 'Clinic' as [Select Type], [Created On] [Cancel Created On],[Originating Process] as [Source Of Originating Process],[Provider],Null as [Room Only Schedule Provider],[Clinic Start Date],[Clinic End Date],[Request Notice Period In Weeks],
[Clinic Date],[Clinic Hours Category],[Clinic Duration],cast([Clinic Start Time] as time) as [Clinic Start Time],cast([Clinic End Time] as time) as [Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],
[Location],[Building],[Floor],[Suite],[Room Name],[Room Number],[No of Participants],[Reason For Cancellation],replace(replace(isnull([Employee Login ID],'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
+isnull(convert(varchar(8),CONVERT(date, [clinic date], 103) , 112),''),',',''),' ','')[Kezava Unique ID],[Division Name],[Total No Scheduled Clinics],
[Mode of Delivery],[DEP Name],'Completed' as [Record Status]  from Cancel_Clinic

union all
select 'Room only' as [Select Type], [Created On] [Cancel Created On],[Originating Process] as [Source Of Originating Process],Null [Provider], [Room Only Schedule Provider],[Clinic Start Date],[Clinic End Date],[Request Notice Period In Weeks],
[Clinic Date],[Clinic Hours Category],[Clinic Duration],cast([Clinic Start Time] as time) as [Clinic Start Time],cast([Clinic End Time] as time) as [Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],
[Location],[Building],[Floor],[Suite],[Room Name],[Room Number],[No of Participants],[Reason For Cancellation],replace(replace(isnull([Room Only Schedule Provider],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
+isnull(convert(varchar(8),CONVERT(date, [clinic date], 103) , 112),''),',',''),' ','')[Kezava Unique ID],[Division Name],[Total No Scheduled Clinics],
[Mode of Delivery],[DEP Name],'Completed' as [Record Status]  from Cancel_Room_Only_Schedule
--union all
--select 'Provider' as [Select Type],[Created On] [Cancel Created On],[Originating Process] as [Source Of Originating Process],[Provider],Null as [Room Only Schedule Provider],[Clinic Start Date],[Clinic End Date],[Request Notice Period In Weeks],
--[Clinic Date],[Clinic Hours Category],[Clinic Duration],cast([Clinic Start Time] as time) as [Clinic Start Time],cast([Clinic End Time] as time) as [Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],
--[Location],[Building],[Floor],[Suite],[Room Name],[Room Number],[No of Participants],[Reason For Cancellation],replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
--+isnull(convert(varchar(8),CONVERT(date, [clinic date], 103) , 112),''),',',''),' ','')[Kezava Unique ID],[Division Name],[Total No Scheduled Clinics],
--[Mode of Delivery],[DEP Name],'Inprogress' as [Record Status] from [2_34_Cancel Provider Clinic]
--union all
--select 'Clinic' as [Select Type],[Created On] [Cancel Created On],[Originating Process] as [Source Of Originating Process],[Provider],Null as [Room Only Schedule Provider],[Clinic Start Date],[Clinic End Date],[Request Notice Period In Weeks],
--[Clinic Date],[Clinic Hours Category],[Clinic Duration],cast([Clinic Start Time] as time) as [Clinic Start Time],cast([Clinic End Time] as time) as [Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],
--[Location],[Building],[Floor],[Suite],[Room Name],[Room Number],[No of Participants],[Reason For Cancellation],replace(replace(isnull([Employee Login ID],'')+isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
--+isnull(convert(varchar(8),CONVERT(date, [clinic date], 103) , 112),''),',',''),' ','')[Kezava Unique ID],[Division Name],[Total No Scheduled Clinics],
--[Mode of Delivery],[DEP Name],'Inprogress' as [Record Status]  from [2_45_Cancel Clinic]

--union all
--select 'Room only' as [Select Type],[Created On] [Cancel Created On],[Originating Process] as [Source Of Originating Process],Null [Provider], [Room Only Schedule Provider],[Clinic Start Date],[Clinic End Date],[Request Notice Period In Weeks],
--[Clinic Date],[Clinic Hours Category],[Clinic Duration],cast([Clinic Start Time] as time) as [Clinic Start Time],cast([Clinic End Time] as time) as [Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],
--[Location],[Building],[Floor],[Suite],[Room Name],[Room Number],[No of Participants],[Reason For Cancellation],replace(replace(isnull([Room Only Schedule Provider],'')+isnull([Location],'')+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
--+isnull(convert(varchar(8),CONVERT(date, [clinic date], 103) , 112),''),',',''),' ','')[Kezava Unique ID],[Division Name],[Total No Scheduled Clinics],
--[Mode of Delivery],[DEP Name],'Inprogress' as [Record Status]  from [2_57_Cancel Room Only Schedule]
),
Cancel_Max_records
as
(
select * from 
	(
		select *,ROW_NUMBER() over (Partition by [Source Of Originating Process],concat(Provider,[Room Only Schedule Provider],[Clinic Specialty]),[clinic date],[Clinic Start Time],[Clinic End Time] 
		order by [Cancel Created On] desc) Row_no
		from Cancel_Reaon
	)x where Row_no =1

)

select [Select Type],[Cancel Created On], [Source Of Originating Process], [Provider], [Room Only Schedule Provider],[Clinic Start Date],[Clinic End Date],[Request Notice Period In Weeks],
[Clinic Date],[Clinic Hours Category],[Clinic Duration],dateadd(hour,datepart(HOUR,[Clinic Start Time]),dateadd(MINUTE, datepart(MINUTE,[Clinic Start Time]),CONVERT(datetime, [Clinic Date], 103))) [Clinic Start Time]
,dateadd(hour,datepart(HOUR,[Clinic End Time]),dateadd(MINUTE, datepart(MINUTE,[Clinic End Time]),CONVERT(datetime, [Clinic Date], 103))) [Clinic End Time]
,[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],[Clinic Specialty] as [Generic Clinic],[Clinic Type] as [Clinic Type Provider],[Location],[Building],[Floor],[Suite],[Room Name],[Room Number]
,[No of Participants],[Reason For Cancellation],[Kezava Unique ID]
,[Division Name],[Total No Scheduled Clinics],[Mode of Delivery],[DEP Name], [Record Status]  from Cancel_Max_records 
--where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 
GO
