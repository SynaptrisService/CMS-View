USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Schedule_and_Changes_All]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Clinic_Schedule_and_Changes_All] 
AS 
select DISTINCT [Created On] ,[Created By],'Clinic Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
,[Rooms Required] ,Building,Floor,wing,[Room Name],[Kezava Unique ID],null   [Kezava Employee ID],[Mode of Delivery],Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].[Clinic_regular_Schedule_Detail] t
 where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select DISTINCT [Created On],[Created By] ,'Add Clinic' [Stage],[Originating Process], 'added' Legend, provider  ,[Clinic Type],[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
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
,''[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Mode of Delivery],Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].[Add_Clinic] t where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 

select DISTINCT t.[Created On],[Created By] ,'Cancel Clinic Hours' [Stage],[Originating Process], 'hourLimited' Legend, t.provider  , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Cancel Start Time] as time), cast(t.[Cancel End Time] as time))) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
,0 [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  [Reason for Cancel Hours],Location,'' [Limit Type]
, 0[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],null [Mode of Delivery],
(select top 1 a.[DEP Name] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Clinic_Regular_Schedule_Detail
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Clinic d
where provider not in (select provider from Clinic_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [DEP Name] ,
(select top 1 a.[No of Participants] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Clinic_Regular_Schedule_Detail
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [No of Participants]
from [dbo].[Shorten_Clinic] t where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 

select DISTINCT t.[Created On],[Created By] ,'Limit Clinic Schedule' [Stage],[Originating Process],'limitedSchedule' Legend, t.provider , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Clinic Start Time] as time),cast(t.[Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  [Limit Schedule Reason],t.Location,[Limit Schedule Request Type] as [Limit Type] 
,''[Rooms Required] ,''Building,''Floor,''wing,'' [Room Name],[Kezava Unique ID],null [Kezava Employee ID],t.[Mode of Delivery],
(select top 1 a.[DEP Name] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Clinic_Regular_Schedule_Detail
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Clinic d
where provider not in (select provider from Clinic_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [DEP Name] ,
(select top 1 a.[No of Participants] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Clinic_Regular_Schedule_Detail
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [No of Participants]
from [dbo].Limit_Clinic_Schedule  t where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 

select DISTINCT [Created On],[Created By] ,'Cancel Clinic Schedule' [Stage],[Originating Process],'canceled' Legend,t.provider  ,[Clinic Type],t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Clinic Start Time] as time),cast(t.[Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] 
, isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month(t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month(t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month(t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month(t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month(t.[Clinic Date]) in (7,8,9) then 1
when Month(t.[Clinic Date]) in (10,11,12) then 2
when Month(t.[Clinic Date]) in (1,2,3) then 3
when Month(t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month(t.[Clinic Date]) >= 7 then 'FY' + right(year(t.[Clinic Date])+1,2) 
when Month(t.[Clinic Date]) <= 6 then 'FY' + right(year(t.[Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],t.Location,'' [Limit Type] 
,''[Rooms Required] ,t.Building,t.Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],t.[Mode of Delivery],
(select top 1 a.[DEP Name] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Clinic_Regular_Schedule_Detail
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Clinic d
where provider not in (select provider from Clinic_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [DEP Name] ,
(select top 1 a.[No of Participants] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Clinic_Regular_Schedule_Detail
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [No of Participants]
from [dbo].Cancel_Clinic t where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL  

select DISTINCT [Created On],[Created By] ,'Assign Provider To Clinic' [Stage],[Originating Process],'' Legend,provider  ,[Clinic Type],[Clinic Specialty],[Clinic Duration], [Clinic Date] 
 ,[Assign Start Time] [Clinic Start Time] ,[Assign End Time] [Clinic End Time]
,casT((DATEDIFF(MINUTE,cast([Assign Start Time] as time),cast([Assign End Time] as time))) as float)/60  [Clinic Hours]
 ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] , 0 [request notice period in weeks]
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
,0 [Rooms Required] ,null Building,null Floor,null wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID], Null [Mode of Delivery],NULL [DEP Name],0 [No of Participants]
from [dbo].[Provider_Assigned_clinics] t
where [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select DISTINCT [Created On],[Created By] ,'Provider Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Mode of Delivery],Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].[Provider_regular_Schedule_Detail] t where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select DISTINCT [Created On],[Created By] ,'Irregular Provider Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Mode of Delivery],Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].Provider_irregular_Schedule_Detail t where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select DISTINCT [Created On],[Created By] ,'Irregular Clinic Schedule' [Stage],[Originating Process], '' Legend, provider  ,[Clinic Type],[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Mode of Delivery] ,Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].Clinic_Irregular_Schedule_Detail  t   where 
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
AND [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select DISTINCT [Created On],[Created By] ,'Add' [Stage],[Originating Process], 'added' Legend, provider  ,[Clinic Type],[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
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
,''[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Mode of Delivery],Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].Add_Provider_Clinic t where isnull([clinic date],'')!='' and [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select DISTINCT t.[Created On],[Created By] ,'Cancel Provider Hours' [Stage],[Originating Process], 'hourLimited' Legend, t.provider  , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Cancel Start Time] as time),cast(t.[Cancel End Time] as time))) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request not
ice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  t.[Reason for Cancel Hours][Notes],t.Location,'' [Limit Type] 
,0 [Rooms Required] ,t.Building,t.Floor,t.wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],Null [Mode of Delivery],
(select top 1 a.[DEP Name] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null[Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.provider=t.provider  and a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [DEP Name] ,
(select top 1 a.[No of Participants] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null [Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.provider=t.provider  and a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [No of Participants]
from [dbo].[Shorten_Provider_Clinic] t where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 
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

--UNION 

--select  [Created On] ,'Self Reported' [Stage],'Self Reported'[Originating Process],'added'Legend,provider  ,[Clinic Type],[Clinic Specialty],Null [Clinic Duration], [Clinic Date] ,[Start Time] ,[End Time]
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
--when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' Notes,[Clinic Location] as Location,'' [Limit Type],''[Rooms Required] ,''Building,''Floor,''wing,''[Room Name],[Kezava Unique ID],null [Kezava Employee ID],[Mode of Delivery] 
--from [dbo].[Provider_Self_Reported_Hours] t where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
--AND [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])


UNION ALL 

select DISTINCT t.[Created On],[Created By] ,'Limit Provider Schedule' [Stage],[Originating Process],'limitedSchedule' Legend, t.provider , t.[Clinic Type], t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Clinic Start Time] as time),cast(t.[Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  null [Notes],t.Location,[Limit Schedule Request Type] as [Limit Type] 
,''[Rooms Required] ,''Building,''Floor,''wing,''[Room Name],[Kezava Unique ID],null [Kezava Employee ID], Null [Mode of Delivery],
(select top 1 a.[DEP Name] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null[Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.provider=t.provider  and a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [DEP Name] ,
(select top 1 a.[No of Participants] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null [Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.provider=t.provider  and a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [No of Participants]
from [dbo].Limit_Provider_Schedule t   where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL 
select DISTINCT [Created On],[Created By] ,'Cancel' [Stage],[Originating Process],'canceled' Legend,t.provider  ,[Clinic Type],t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Clinic Start Time] as time),cast(t.[Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
 , isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month(t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month(t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month(t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month(t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month(t.[Clinic Date]) in (7,8,9) then 1
when Month(t.[Clinic Date]) in (10,11,12) then 2
when Month(t.[Clinic Date]) in (1,2,3) then 3
when Month(t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month(t.[Clinic Date]) >= 7 then 'FY' + right(year(t.[Clinic Date])+1,2) 
when Month(t.[Clinic Date]) <= 6 then 'FY' + right(year(t.[Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],t.Location,'' [Limit Type]
,''[Rooms Required] ,t.Building,t.Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],Null [Mode of Delivery], 
(select top 1 a.[DEP Name] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null[Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.provider=t.provider  and a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [DEP Name] ,
(select top 1 a.[No of Participants] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null [Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] and c.[Schedule Updated On]>d.[Created On] )
)a  where a.provider=t.provider  and a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time) and a.[Clinic Hours Category]=t.[Clinic Hours Category])as [No of Participants]
from [dbo].Cancel_Provider_Clinic t where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 
and exists (
select provider,Location,[Clinic Specialty],[clinic date], cast([clinic start time] as time) as [clinic start time],cast([clinic end time] as time) as [clinic end time],Building
,Floor,Suite from (select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null [Clinic Hours Category]  from Provider_Assigned_Clinics
union all
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location ,Building,floor,suite,[Clinic Hours Category] from Add_Provider_Clinic) b
where isnull(b.provider,'')!='' and t.provider=b.provider and t.[Clinic Date]=b.[Clinic Date] and t.Location=b.Location
and t.[Clinic Specialty]=b.[Clinic Specialty]
and cast(t.[clinic start time] as time)=cast(b.[clinic start time] as time) and cast(t.[clinic end time] as time)=cast(b.[clinic end time] as time)
)


/*
select Distinct [Created On],[Created By] ,'Cancel' [Stage],[Originating Process],'canceled' Legend,t.provider  ,[Clinic Type],t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Clinic Start Time] as time),cast(t.[Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
 , isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month(t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month(t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month(t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month(t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month(t.[Clinic Date]) in (7,8,9) then 1
when Month(t.[Clinic Date]) in (10,11,12) then 2
when Month(t.[Clinic Date]) in (1,2,3) then 3
when Month(t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month(t.[Clinic Date]) >= 7 then 'FY' + right(year(t.[Clinic Date])+1,2) 
when Month(t.[Clinic Date]) <= 6 then 'FY' + right(year(t.[Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],t.Location,'' [Limit Type]
,''[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],Null [Mode of Delivery],a.[DEP Name] ,a.[No of Participants]
from [dbo].Cancel_Provider_Clinic t  left join 
(
select distinct  provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants],[Clinic Specialty],Location  from Provider_Regular_Schedule_Detail
union 
select distinct isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants],[mdc Clinic Specialty],Location  from MDC_Regular_Schedule_Detail
union 
select distinct provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants],[Clinic Specialty],Location  from Add_Provider_Clinic d
where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] )
)a on  a.provider=t.provider  and a.[Clinic Date]=t.[Clinic Date] and a.[Clinic Specialty]=t.[Clinic Specialty] and a.Location=t.location
and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) 
and  cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time)
where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 


select Distinct [Created On],[Created By] ,'Cancel' [Stage],[Originating Process],'canceled' Legend,t.provider  ,[Clinic Type],t.[Clinic Specialty],[Clinic Duration], t.[Clinic Date] ,t.[Clinic Start Time] ,t.[Clinic End Time]
,casT((DATEDIFF(MINUTE,cast(t.[Clinic Start Time] as time),cast(t.[Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
 , isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month(t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month(t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month(t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month(t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month(t.[Clinic Date]) in (7,8,9) then 1
when Month(t.[Clinic Date]) in (10,11,12) then 2
when Month(t.[Clinic Date]) in (1,2,3) then 3
when Month(t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month(t.[Clinic Date]) >= 7 then 'FY' + right(year(t.[Clinic Date])+1,2) 
when Month(t.[Clinic Date]) <= 6 then 'FY' + right(year(t.[Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],t.Location,'' [Limit Type]
,''[Rooms Required] ,t.Building,t.Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],Null [Mode of Delivery],
isnull([Department Name],t1.[DEP Name]) [DEP Name],t1.[No of Participants]
 from [dbo].Cancel_Provider_Clinic t 
 cross apply dbo.split(Suite,';') s
 left join 
(select * from (select *,ROW_NUMBER()over (partition by Division,Location,Building,FLoor,Suite order by Division,Location,Building,FLoor,Suite) rno 
from (select distinct Division,Location,Building,FLoor,Suite,[Department Name]
from ERD_Dep_Report
where isnull(division,'')!='')x)z
where rno=1) b
on isnull(t.Location,'')=isnull(b.Location,'') and isnull(t.Building,'')=isnull(b.Building,'') and isnull(t.Floor,'')=isnull(b.Floor,'') and isnull(s.Data,'')=isnull(b.Suite,'')
and t.[Division Name]=b.Division
 left join (
	select   provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants],[Clinic Specialty],Location,Building,Floor,Suite from Provider_Regular_Schedule_Detail
	union 
	select  provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants],[Clinic Specialty],Location,Building,Floor,Suite  from Add_Provider_Clinic d
	where provider not in (select provider from Provider_Regular_Schedule_Detail c where c.provider=d.provider and c.[Clinic Date] =d.[Clinic Date] 
	and cast(d.[Clinic Start Time]as time )  between cast(c.[Clinic Start Time]as time) and cast(c.[Clinic End Time]as time)
	and cast(d.[Clinic End Time]as time )  between cast(c.[Clinic Start Time]as time) and cast(c.[Clinic End Time]as time))
 ) t1
 on t.provider=t1.provider and t.[Clinic Date] =t1.[Clinic Date]  and t1.Location=t.location and isnull(t1.Building,'')=isnull(t.Building,'')
and isnull(t1.Floor,'')=isnull(t.Floor,'')and isnull(t1.Suite,'')=isnull(t.Suite,'')
*/


GO
