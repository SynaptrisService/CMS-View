USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_MDC_Get_Clinic_Detail]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE VIEW [dbo].[VW_MDC_Get_Clinic_Detail] 
as 
/*
WITH [RegualrSchedule] 
as
(
select PR.[Created On], [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[MDC Clinic Specialty],PR.Location,
 dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Suite]
,[Room Name] [Room Name],concat([Kezava Unique ID],[Division Name])[Kezava Unique ID],[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[WorkSpaces Required][Workspaces Occupied]
from [dbo].MDC_Regular_Schedule_Detail PR where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL

select PR.[Created On],PR.[Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],concat(PR.[Clinic Specialty],' MDC')[MDC Clinic Specialty],
PR.Location,dateadd(MINUTE,datepart(MINUTE,PR.[Clinic Start Time]),(dateadd(hour,datepart(hour,PR.[Clinic Start Time]),PR.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,PR.[Clinic end Time]),(dateadd(hour,datepart(hour,PR.[Clinic End Time]),PR.[Clinic Date])))[Clinic End Time],0 Ranks,PR.[Rooms Required] ,PR.Building,PR.Floor,PR.wing,PR.[Suite],
PR.[Room Name] [Room Name],concat(PR.[Kezava Unique ID],PR.[Division Name])[Kezava Unique ID],PR.[Employee Login ID],PR.[Division Name],PR.[Division Notification],PR.[Clinic Template],PR.[Provider] AS [MDC Provider Name]
,PR.[Clinic Duration],PR.[Clinic Hours Category],PR.[No of Participants],PR.[WorkSpaces Required][Workspaces Occupied]
from [dbo].MDC_Irregular_Schedule_Detail PR where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 

select  LPH.[Created On], [Originating Process], LPH.[Clinic Date] , LPH.Provider provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],LPH.Location,
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic Start Time]),(dateadd(hour,datepart(hour,LPH.[Clinic Start Time]),LPH.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic end Time]),(dateadd(hour,datepart(hour,LPH.[Clinic End Time]),LPH.[Clinic Date]))) [Clinic End Time],0 Ranks ,0 [Rooms Required],Building,
Floor,wing,suite,LPH.[Room Name] [Room Name],LPH.[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Cancel_MDC_Clinic] LPH where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 

select LPH.[Created On],  concat([Originating Process],' Inprogress')[Originating Process], LPH.[Clinic Date] , [MDC Provider Name]as  provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],
LPH.Location, dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Floor,wing,Suite,
LPH.[Room Name] [Room Name],LPH.[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from .[dbo].[2_54_Cancel MDC Clinic] LPH where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 

select  LPH.[Created On], [Originating Process], LPH.[Clinic Date] , LPH.Provider provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],LPH.Location,
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic Start Time]),(dateadd(hour,datepart(hour,LPH.[Clinic Start Time]),LPH.[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic end Time]),(dateadd(hour,datepart(hour,LPH.[Clinic End Time]),LPH.[Clinic Date]))) [Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Suite,
Floor,wing ,LPH.[Room Name] [Room Name],concat(LPH.[Kezava Unique ID],[Division Name])[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Shorten_MDC_Clinic_Detail] LPH where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 

select LPH.[Created On],  concat([Originating Process],' Inprogress')[Originating Process], LPH.[Clinic Date] , [MDC Provider Name]as  provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],
LPH.Location, dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Floor,wing,Suite,
LPH.[Room Name] [Room Name],concat(LPH.[Kezava Unique ID],[Division Name])[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from .[dbo].[2_60_Shorten MDC Clinic] LPH where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 
),
[Maxrecord]
as 
(
--/* In Progress Records Only and Rank Order [Kava Unique ID]*/
--selecT *, DENSE_RANK() over(partition by [Kezava Unique ID] order by a.[Kezava Unique ID] desc) RowID from [RegualrSchedule] a where 
--[Originating Process] in ('Cancel MDC Clinic InProgress','Shorten MDC Clinic Inprogress')

--UNION 
/* Except (Cancel Provider Hours) Confimed records !=In Progress all Records and Rank Order [Created On]*/
selecT a.*, DENSE_RANK() over(partition by a.[Kezava Unique ID] order by a.[Created On] desc) RowID from [RegualrSchedule] a  where [Originating Process] in ('Cancel MDC Clinic')
and not EXISTS (select '' from [RegualrSchedule] b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') 
and b.[Originating Process] in ('Cancel MDC Clinic InProgress','Shorten MDC Clinic Inprogress') and FORMAT(b.[Created On],'yyyy-MM-dd hh:mm') > FORMAT(a.[Created On],'yyyy-MM-dd hh:mm'))

UNION

/* Cancel Provider Hours Confimed records != All Confirmed Records,In Progress Records  and Rank Order [Kezava Unique ID]*/
selecT *, DENSE_RANK() over(partition by [Kezava Unique ID] order by a.[Kezava Unique ID] desc) RowID from [RegualrSchedule] a where [Originating Process] in ('Shorten MDC Clinic')
and not exists (select '' from [RegualrSchedule] b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') 
and b.[Originating Process] in ('Shorten MDC Clinic','Shorten MDC Clinic Inprogress')
and a.[Clinic Start Time]=b.[Clinic Start Time] and a.[Clinic End Time]=b.[Clinic End Time] and FORMAT(b.[Created On],'yyyy-MM-dd hh:mm') > FORMAT(a.[Created On],'yyyy-MM-dd hh:mm'))

UNION

/* Except Confrimed Records and In Progress Records*/
selecT a.*, ROW_NUMBER() over(partition by a.[Kezava Unique ID] order by a.[Created On] desc) RowID from [RegualrSchedule]  a
where not EXISTS (select '' from [RegualrSchedule] b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') 
and [Originating Process] in ('Cancel MDC Clinic','Cancel MDC Clinic InProgress','Shorten MDC Clinic','Shorten MDC Clinic Inprogress'))
),
finaldata as
(
selecT a.[Originating Process] as[Source Originating Process],a.[Clinic Date]
,abs(datediff(dd,getdate(),a.[Clinic Date]))/7 [Request Notice Period In Weeks]
,'Advance Notice - '+ Convert(VARCHAR(20),abs(datediff(dd,getdate(),a.[Clinic Date]))/7 )+
case when (abs(datediff(dd,getdate(),a.[Clinic Date]))/7) <=1 then ' Week' else ' Weeks' end   +', '+
Convert(VARCHAR(20),abs(datediff(dd,getdate(),a.[Clinic Date]) )%7) + case when (abs(datediff(dd,getdate(),a.[Clinic Date]) )%7)<=1 then' Day' else' Days' end [Advance Notice Period],
a.[Clinic Start Time],a.[Clinic End Time], replace(replace(RIGHT(Convert(VARCHAR(20), a.[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM') + ' To ' + replace(replace(RIGHT(Convert(VARCHAR(20), a.[Clinic End Time],100),7),'AM',' AM'),'PM',' PM') as [Scheduled Clinic Time],
a.[Location],a.[Clinic Type], isnull(A.[Provider],'') as [Provider],a.[MDC Clinic Specialty],isnull(a.[Building],'')[Building],isnull(a.[Floor],'') as [Floor],isnull(a.[Wing],'')[Wing],isnull(a.[Suite],'')[Suite],
isnull(a.[Room Name],'') as [Room Name],A.[Kezava Unique ID],[Division Name],[Division Notification],
STUFF((select distinct ';' + B.[Division Name] from [Maxrecord] B WHERE A.[MDC Clinic Specialty]=B.[MDC Clinic Specialty] AND A.[Clinic Date]=B.[Clinic Date] FOR XML PATH('')),1,1,'') AS [Reference Division Name],
isnull([MDC Provider Name],'') AS [MDC Provider Name],[Clinic Template],[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Maxrecord] a where  isnull(a.[Originating Process],'') Not in ('Cancel MDC Clinic','Cancel MDC Clinic In Progress','Shorten MDC Clinic Inprogress') 
) ,
FinalReuslt as
(
	select top 10000  a.*,concat([Division Name],' - ',tes)test,case when [MDC Provider Name]='Clinic;' then 'Clinic' else 'Provider' end as [Clinic Template Order] 
		from (
		select [Clinic Type],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time],[Advance Notice Period],[Request Notice Period In Weeks],[Clinic Date],case when isnull([MDC Provider Name],'')!='' then concat([MDC Provider Name],';') else 'Clinic;' end as [MDC Provider Name] ,
		[Division Name],case when isnull([MDC Provider Name] ,'')!='' then concat('Provider: ',[MDC Provider Name]) else 'Clinic' end as tes,
		[Source Originating Process],[Scheduled Clinic Time],[Division Notification],[Location],[Room Name],[Kezava Unique ID]
		from finaldata 
	)a order by [Clinic Template Order] desc
)
	select Distinct [Clinic Type],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time],replace(replace(replace([Advance Notice Period],'0 Week,',''),', 0 Day',''),'0 Day',' 0') [Advance Notice Period],[Request Notice Period In Weeks],[Clinic Date],[Source Originating Process],[Scheduled Clinic Time],[Location],[Room Name],left([MDC Provider Name],len([MDC Provider Name])-1)[MDC Provider Name],
	right([Division Name],len([Division Name])-1)[Division Name],[MDC Details],
	--left([MDC Details],len([MDC Details])-1)[MDC Details],
	right([Kezava Unique ID],len([Kezava Unique ID])-1)[Kezava Unique ID]
 from (
select distinct [Clinic Type],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time],[Advance Notice Period],[Request Notice Period In Weeks],[Clinic Date],[Source Originating Process],[Scheduled Clinic Time],[Location],[Room Name],
[MDC Provider Name]=STUFF((SELECT  ''+a.[MDC Provider Name] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, ''),
[Division Name]=STUFF((SELECT  ';'+ a.[Division Name] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date]  and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, ''),
[MDC Details] =STUFF((SELECT  '\n'+ a.[Test] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, ''),
[Kezava Unique ID] =STUFF((SELECT  distinct ';'+ a.[Kezava Unique ID] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, '')
,[Clinic Template Order] from FinalReuslt b

)a 



*/
WITH [RegualrSchedule] 
as
(
select PR.[Created On],'MDC Regular Schedule' [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],PR.[MDC Clinic Specialty],PR.Location,
 dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time],0 Ranks,[Rooms Required] ,Building,Floor,wing,[Suite]
,[Room Name] [Room Name],concat([Kezava Unique ID],[Division Name])[Kezava Unique ID],[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
,[Clinic Duration],[Clinic Hours Category],[No of Participants],[WorkSpaces Required][Workspaces Occupied]
from [dbo].MDC_Regular_Schedule_Detail PR where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 

--UNION ALL

--select PR.[Created On],'MDC Irregular Schedule' [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],concat(PR.[Clinic Specialty],' MDC')[MDC Clinic Specialty],
--PR.Location,dateadd(MINUTE,datepart(MINUTE,PR.[Clinic Start Time]),(dateadd(hour,datepart(hour,PR.[Clinic Start Time]),PR.[Clinic Date])))[Clinic Start Time],
--dateadd(MINUTE,datepart(MINUTE,PR.[Clinic end Time]),(dateadd(hour,datepart(hour,PR.[Clinic End Time]),PR.[Clinic Date])))[Clinic End Time],0 Ranks,PR.[Rooms Required] ,PR.Building,PR.Floor,PR.wing,PR.[Suite],
--PR.[Room Name] [Room Name],concat(PR.[Kezava Unique ID],PR.[Division Name])[Kezava Unique ID],PR.[Employee Login ID],PR.[Division Name],PR.[Division Notification],PR.[Clinic Template],PR.[Provider] AS [MDC Provider Name]
--,PR.[Clinic Duration],PR.[Clinic Hours Category],PR.[No of Participants],PR.[WorkSpaces Required][Workspaces Occupied]
--from [dbo].MDC_Irregular_Schedule_Detail PR where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 
--and not exists (select '' from [Shorten_Provider_Clinic] b where PR.[Clinic Date]=b.[Clinic Date] and cast(PR.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
--and cast(PR.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and b.[Created On]>PR.[Created On] and concat(PR.[Clinic Specialty],' MDC')=b.[Clinic Specialty])

--UNION ALL

--select PR.[Created On],'Shorten MDC Clinic' [Originating Process], PR.[Clinic Date] , PR.Provider provider,PR.[Clinic Type],concat(PR.[Clinic Specialty],' MDC')[MDC Clinic Specialty],
--PR.Location,dateadd(MINUTE,datepart(MINUTE,b.[Clinic Start Time]),(dateadd(hour,datepart(hour,b.[Clinic Start Time]),b.[Clinic Date])))[Clinic Start Time],
--dateadd(MINUTE,datepart(MINUTE,b.[Clinic end Time]),(dateadd(hour,datepart(hour,b.[Clinic End Time]),b.[Clinic Date])))[Clinic End Time],0 Ranks,PR.[Rooms Required] ,PR.Building,PR.Floor,PR.wing,PR.[Suite],
--PR.[Room Name] [Room Name],concat(PR.[Kezava Unique ID],PR.[Division Name])[Kezava Unique ID],PR.[Employee Login ID],PR.[Division Name],PR.[Division Notification],PR.[Clinic Template],PR.[Provider] AS [MDC Provider Name]
--,PR.[Clinic Duration],PR.[Clinic Hours Category],PR.[No of Participants],PR.[WorkSpaces Required][Workspaces Occupied]
--from [dbo].MDC_Irregular_Schedule_Detail PR inner join (Select [Clinic Date],[Clinic Specialty],[Created On],[Clinic Start Time],[Clinic End Time] from [Shorten_Provider_Clinic_Detail] 
--union 
--Select [Clinic Date],[Clinic Specialty],[Created On],[Clinic Start Time],[Clinic End Time] from [Shorten_Clinic_Detail])b on PR.[Clinic Date]=b.[Clinic Date] and concat(PR.[Clinic Specialty],' MDC')=b.[Clinic Specialty]
--where b.[Created On]>PR.[Created On]

--UNION ALL 

--select  LPH.[Created On], [Originating Process], LPH.[Clinic Date] , LPH.Provider provider,LPH.[Clinic Type],LPH.[MDC Clinic Specialty],LPH.Location,
--dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic Start Time]),(dateadd(hour,datepart(hour,LPH.[Clinic Start Time]),LPH.[Clinic Date])))[Clinic Start Time],
--dateadd(MINUTE,datepart(MINUTE,LPH.[Clinic end Time]),(dateadd(hour,datepart(hour,LPH.[Clinic End Time]),LPH.[Clinic Date]))) [Clinic End Time],0 Ranks ,0 [Rooms Required],Building,Suite,
--Floor,wing ,LPH.[Room Name] [Room Name],concat(LPH.[Kezava Unique ID],[Division Name])[Kezava Unique ID],LPH.[Employee Login ID],[Division Name],[Division Notification],[Clinic Template],[Provider] AS [MDC Provider Name]
--,[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
--from [Shorten_MDC_Clinic_Detail] LPH where [clinic date] not in (select [Holiday Date] from [dbo].[ERD_Enterprise_Holiday_List]) 

)
,[Maxrecord]
as 
(
select * from [RegualrSchedule] a
where not exists
	(
	select '' from (
	select Distinct concat([Kezava Unique ID],[Division Name])[Kezava Unique ID],[Created On] from [Cancel_MDC_Clinic_Detail] --where [Cancel Confirmation]='Yes'
	union
	select Distinct concat([Kezava Unique ID],[Division Name])[Kezava Unique ID],[Created On] from [Cancel_MDC_Clinic_Inprogress] --where [Cancel Confirmation]='Yes'
	union
	select Distinct concat([Kezava Unique ID],[Division Name])[Kezava Unique ID],[Created On] from [Shorten_MDC_Clinic_Inprogress] --where [Cancel Confirmation]='Yes'
	
	)b where isnull(a.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') and b.[Created On]>=a.[Created On]
	)
),
finaldata as
(
selecT a.[Originating Process] as[Source Originating Process],a.[Clinic Date]
,abs(datediff(dd,getdate(),a.[Clinic Date]))/7 [Request Notice Period In Weeks]
,'Advance Notice - '+ Convert(VARCHAR(20),abs(datediff(dd,getdate(),a.[Clinic Date]))/7 )+
case when (abs(datediff(dd,getdate(),a.[Clinic Date]))/7) <=1 then ' Week' else ' Weeks' end   +', '+
Convert(VARCHAR(20),abs(datediff(dd,getdate(),a.[Clinic Date]) )%7) + case when (abs(datediff(dd,getdate(),a.[Clinic Date]) )%7)<=1 then' Day' else' Days' end [Advance Notice Period],
a.[Clinic Start Time],a.[Clinic End Time], replace(replace(RIGHT(Convert(VARCHAR(20), a.[Clinic Start Time],100),7),'AM',' AM'),'PM',' PM') + ' To ' + replace(replace(RIGHT(Convert(VARCHAR(20), a.[Clinic End Time],100),7),'AM',' AM'),'PM',' PM') as [Scheduled Clinic Time],
a.[Location],a.[Clinic Type], isnull(A.[Provider],'') as [Provider],a.[MDC Clinic Specialty],isnull(a.[Building],'')[Building],isnull(a.[Floor],'') as [Floor],isnull(a.[Wing],'')[Wing],isnull(a.[Suite],'')[Suite],
isnull(a.[Room Name],'') as [Room Name],A.[Kezava Unique ID],[Division Name],[Division Notification],
STUFF((select distinct ';' + B.[Division Name] from [Maxrecord] B WHERE A.[MDC Clinic Specialty]=B.[MDC Clinic Specialty] AND A.[Clinic Date]=B.[Clinic Date] FOR XML PATH('')),1,1,'') AS [Reference Division Name],
isnull([MDC Provider Name],'') AS [MDC Provider Name],[Clinic Template],[Clinic Duration],[Clinic Hours Category],[No of Participants],[Workspaces Occupied]
from [Maxrecord] a --where  a.[Originating Process] Not in ('Cancel MDC Clinic','Cancel MDC Clinic In Progress','MDC Shorten Hours In Progress') 
) ,
FinalReuslt as
(
	select top 10000  a.*,concat([Division Name],' - ',tes)test,case when [MDC Provider Name]='Clinic;' then 'Clinic' else 'Provider' end as [Clinic Template Order] 
		from (
		select [Clinic Type],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time],[Advance Notice Period],[Request Notice Period In Weeks],[Clinic Date],case when isnull([MDC Provider Name],'')!='' then concat([MDC Provider Name],';') else 'Clinic;' end as [MDC Provider Name] ,
		[Division Name],case when isnull([MDC Provider Name] ,'')!='' then concat('Provider: ',[MDC Provider Name]) else 'Clinic' end as tes,
		[Source Originating Process],[Scheduled Clinic Time],[Division Notification],[Location],[Room Name],[Kezava Unique ID]
		from finaldata 
	)a order by [Clinic Template Order] desc
)
	select Distinct [Clinic Type],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time],replace(replace(replace([Advance Notice Period],'0 Week,',''),', 0 Day',''),'0 Day',' 0') [Advance Notice Period],[Request Notice Period In Weeks],[Clinic Date],[Source Originating Process],[Scheduled Clinic Time],[Location],[Room Name],left([MDC Provider Name],len([MDC Provider Name])-1)[MDC Provider Name],
	right([Division Name],len([Division Name])-1)[Division Name],[MDC Details],
	--left([MDC Details],len([MDC Details])-1)[MDC Details],
	right([Kezava Unique ID],len([Kezava Unique ID])-1)[Kezava Unique ID]
 from (
select distinct [Clinic Type],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time],[Advance Notice Period],[Request Notice Period In Weeks],[Clinic Date],[Source Originating Process],[Scheduled Clinic Time],[Location],[Room Name],
[MDC Provider Name]=STUFF((SELECT  ''+a.[MDC Provider Name] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, ''),
[Division Name]=STUFF((SELECT  ';'+ a.[Division Name] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date]  and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, ''),
[MDC Details] =STUFF((SELECT  '\n'+ a.[Test] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, ''),
[Kezava Unique ID] =STUFF((SELECT  distinct ';'+ a.[Kezava Unique ID] FROM FinalReuslt a where a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time) and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] FOR XML PATH('')), 1, 0, '')
,[Clinic Template Order] from FinalReuslt b --where [Clinic Date]='2021-02-08'

)a 







GO
