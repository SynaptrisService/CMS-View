USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Schedule_and_Changes]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_Clinic_Schedule_and_Changes] 
AS 
--/* Previos View Name: [VW_Provider_All_Records] */
select Distinct [Created On] ,'Clinic Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC','')[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
,0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location ,'' [Limit Type]
,isnull([Rooms Required],0) as[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null   [Kezava Employee ID],[Suite],[Schedule Updated On],[Clinic Hours Category] as [Hours Category] 
from [dbo].[Clinic_regular_Schedule_Detail] t where 
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select distinct [Created On] ,'Add Clinic' [Stage],[Originating Process], 'added' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] ,0 [request notice period in weeks] 
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],Location,'' [Limit Type]
,isnull([Rooms Required],0) as[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].[Add_Clinic] t where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct t.[Created On] ,'Cancel Clinic Hours' [Stage],[Originating Process], 'hourLimited' Legend, t.provider  , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,t.[Cancel Start Time],t.[Cancel End Time])) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],
 [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  t.[Reason for Cancel Hours],Location,'' [Limit Type]
,isnull( LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) [Rooms Required],[Division Name],Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].[Shorten_Clinic]  t
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])


UNION ALL

select Distinct t.[Created On] ,'Limit Clinic Schedule' [Stage],[Originating Process],'limitedSchedule' Legend, t.provider , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time])) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],[request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  [Limit Schedule Reason],Location,[Limit Schedule Request Type] as [Limit Type] 
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) [Rooms Required],[Division Name] ,''Building,''Floor,''wing,'' [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].Limit_Clinic_Schedule  t
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year]) 
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL

select Distinct [Created On] ,'Cancel Clinic Schedule' [Stage],[Originating Process],'canceled' Legend,provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] 
, isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],Location,'' [Limit Type] 
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) [Rooms Required],[Division Name],Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].Cancel_Clinic t -- where  [Reason For Cancellation] not in ('Service','Patient Care','Retreat')
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])AND 
[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select Distinct [Created On] ,'Assign Provider To Clinic' [Stage],[Originating Process],'' Legend,provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] 
 ,[Assign Start Time] [Clinic Start Time] ,[Assign End Time] [Clinic End Time]
,casT((DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time])) as float)/60  [Clinic Hours]
 ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t. [Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] , 0[request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],[Location] as Location,'' [Limit Type] 
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) [Rooms Required],''[Division Name],null Building,null Floor,null wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Suite],[Created On] as [Schedule Updated On],
(select top 1 [Clinic Hours Category] as [Hours Category] from [V3_ERD].[dbo].Clinic_Hours_Category
	where (cast([Assign Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) and cast([Start Time Maximum Value] as time)
	and cast([Assign End Time] as time) BETWEEN cast([End Time Minimum Value] as time) and cast([End Time Maximum Value] as time)))  as [Hours Category]
from [dbo].[Provider_Assigned_clinics] t
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])AND 
[clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct [Created On] ,'Provider Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location ,'' [Limit Type]
,isnull([Rooms Required],0) as[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite], [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].[Provider_regular_Schedule_Detail] t where 
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])
--and  not exists (select '' from [Edit_Provider_Clinic_Specialty] b where isnull(t.[Kezava Unique ID],'')=isnull(b.[Kezava Unique ID],'') and t.provider=b.Provider )


--UNION ALL

--select  [Created On] ,'MDC Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
--,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
--case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
--when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
--when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
--,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
--,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
--when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
--when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
--when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
--end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
--when Month([Clinic Date]) in (10,11,12) then 2
--when Month([Clinic Date]) in (1,2,3) then 3
--when Month([Clinic Date]) in (4,5,6) then  4
--end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
--when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location ,'' [Limit Type]
--,[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] 
--from [dbo].[Provider_regular_Schedule_Detail] t where 
--[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
--AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct [Created On] ,'Irregular Provider Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,'' [Limit Type] 
,isnull([Rooms Required],0) as[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].Provider_irregular_Schedule_Detail  t   where 
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

--UNION ALL

----- Added on 8/6/2019
--select  [Created On] ,'Irregular Linked Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
--,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
--case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
--when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
--when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
--,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
--,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
--when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
--when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
--when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
--end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
--when Month([Clinic Date]) in (10,11,12) then 2
--when Month([Clinic Date]) in (1,2,3) then 3
--when Month([Clinic Date]) in (4,5,6) then  4
--end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
--when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,'' [Limit Type] 
--,[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite]
--from [dbo].Irregular_Linked_Schedule_Detail  t   where 
--[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
--AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct [Created On] ,'Irregular Clinic Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,'' [Limit Type] 
,isnull([Rooms Required],0) as[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].Clinic_Irregular_Schedule_Detail  t   where 
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

--UNION ALL

--select  [Created On] ,'Regular Linked Clinic Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
--,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
--case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
--when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
--when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
--,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
--,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
--when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
--when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
--when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
--end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
--when Month([Clinic Date]) in (10,11,12) then 2
--when Month([Clinic Date]) in (1,2,3) then 3
--when Month([Clinic Date]) in (4,5,6) then  4
--end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
--when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,'' [Limit Type] 
--,[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite]
--from [dbo].Regular_Linked_Clinic_Schedule_Detail  t   where 
--[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
--AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])


UNION ALL

select distinct [Created On] ,'Add' [Stage],[Originating Process], 'added' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] ,0 [request notice period in weeks] 
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],Location,'' [Limit Type] 
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].Add_Provider_Clinic t 
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year]) AND 
[clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct t.[Created On] ,'Cancel Provider Hours' [Stage],[Originating Process], 'hourLimited' Legend, t.provider  , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,t.[Cancel Start Time],t.[Cancel End Time])) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
, [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  t.[Reason for Cancel Hours][Notes],Location,'' [Limit Type] 
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required],[Division Name],Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].[Shorten_Provider_Clinic] t
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year]) 
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])
and exists (
select provider,Location,[Clinic Specialty],[clinic date], cast([clinic start time] as time) as [clinic start time],cast([clinic end time] as time) as [clinic end time],Building
,Floor,Suite from (select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null [Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic) b
where isnull(b.provider,'')!='' and t.provider=b.provider and t.[Clinic Date]=b.[Clinic Date] and t.Location=b.Location
and t.[Clinic Specialty]=b.[Clinic Specialty]
and cast(t.[clinic start time] as time) between cast(b.[clinic start time] as time) and cast(b.[clinic end time] as time)
and cast(t.[clinic end time] as time) between cast(b.[clinic start time] as time) and cast(b.[clinic end time] as time)) 


--UNION ALL

--select  [Created On] ,'Self Reported' [Stage],'Self Reported'[Originating Process],'added'Legend,provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),Null [Clinic Duration], [Clinic Date] ,[Start Time] ,[End Time]
--,casT((DATEDIFF(MINUTE,[Start Time],[End Time])) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
--case when DATEDIFF(MINUTE,[Start Time],[End Time]) > 240 then 2
--when DATEDIFF(MINUTE,[Start Time],[End Time]) <= 0 then 0 
--when DATEDIFF(MINUTE,[Start Time],[End Time]) <= 240 then 1 
--end [Clinic Half Days]
--,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] , 0 [request notice period in weeks]
--,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
--when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
--when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
--when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
--end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
--when Month([Clinic Date]) in (10,11,12) then 2
--when Month([Clinic Date]) in (1,2,3) then 3
--when Month([Clinic Date]) in (4,5,6) then  4
--end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
--when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' Notes,[Clinic Location] as Location,'' [Limit Type],[Rooms Required],[Division Name] ,''Building,''Floor,''wing,''[Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite]
--from [dbo].[Provider_Self_Reported_Hours] t where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
--AND [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])


UNION ALL

select Distinct t.[Created On] ,'Limit Provider Schedule' [Stage],[Originating Process],'limitedSchedule' Legend, t.provider , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time])) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date], [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  [Limit Schedule Reason],Location,[Limit Schedule Request Type] as [Limit Type] 
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required],[Division Name] ,''Building,''Floor,''wing,''[Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Suite] ,[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].Limit_Provider_Schedule  t
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year]) 
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL

select Distinct [Created On] ,'Cancel' [Stage],[Originating Process],'canceled' Legend,provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
 , isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],Location,'' [Limit Type]
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] ,[Suite],[Created On] as [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
 from [dbo].Cancel_Provider_Clinic t
where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])AND 
[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])
and exists (
select provider,Location,[Clinic Specialty],[clinic date], cast([clinic start time] as time) as [clinic start time],cast([clinic end time] as time) as [clinic end time],Building
,Floor,Suite from (select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null [Clinic Hours Category]  from Provider_Assigned_Clinics
union  all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic) b
where isnull(b.provider,'')!='' and t.provider=b.provider and t.[Clinic Date]=b.[Clinic Date] and t.Location=b.Location
and t.[Clinic Specialty]=b.[Clinic Specialty]
and cast(t.[clinic start time] as time)=cast(b.[clinic start time] as time) and cast(t.[clinic end time] as time)=cast(b.[clinic end time] as time)
)

UNION ALL

select Distinct [Created On] ,'Provider Room Hold Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Clinic Specialty],' MDC',''),[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location ,'' [Limit Type]
,isnull([Rooms Required],0) as[Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Suite] , [Schedule Updated On],[Clinic Hours Category] as [Hours Category]
from [dbo].[Provider_Room_Hold_Schedule_Detail] t where 
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

union all

select Distinct [Created On] ,'Edit Provider' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],replace([Edit Clinic Specialty],' MDC','') as [Clinic Specialty],[Clinic Duration], [Clinic Date] 
,Case when [Edit Clinic]='Edit Clinic' then [Clinic Start Time]  else [Edit Clinic Start Time] end as [Clinic Start Time]
,Case when [Edit Clinic]='Edit Clinic' then [Clinic End Time]  else [Edit Clinic End Time] end  as [Clinic End Time]
,casT((DATEDIFF(MINUTE,CAST(Case when [Edit Clinic]='Edit Clinic' then [Clinic Start Time]  else [Edit Clinic Start Time] end  AS TIME),CAST(Case when [Edit Clinic]='Edit Clinic' then [Clinic End Time]  else [Edit Clinic End Time] end AS TIME))) as float)/60  [Clinic Hours] 
,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location ,'' [Limit Type]
,isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required],[Division Name] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID] 
,[Suite], [Created On] as[Schedule Updated On],
isnull((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
		where (cast([Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		and cast([Start Time Maximum Value] as time)
		and cast([Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		and cast([End Time Maximum Value] as time))),'All Day') as [Hours Category]
from [dbo].[Edit_Provider_Clinic_Specialty] t where 
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])



GO
