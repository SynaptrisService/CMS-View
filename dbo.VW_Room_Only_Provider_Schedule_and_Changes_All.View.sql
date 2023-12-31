USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Only_Provider_Schedule_and_Changes_All]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Room_Only_Provider_Schedule_and_Changes_All] 
AS 
select distinct 3 grp,[Created On] ,[Created By],'Add' [Stage], 'added' Legend, [Room Only Schedule Provider], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],Null [Schedule Start Date],Null [Schedule End Date]
,casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] ,0 [request notice period in weeks] 
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],Location,ISNULL([Mode of Delivery],'') [Mode of Delivery],[Room Name],Isnull([DEP Name],'')
[DEP Name],[No of Participants],[Division Name] from [dbo].Add_Room_Only_Schedule t 
where [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select  1 grp,[Created On] ,[Created By],'Room Only Schedule' [Stage], '' Legend, [Room Only Schedule Provider] ,[Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
,ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))	[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],[Schedule Start Date],[Schedule End Date]
,casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date],0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,ISNULL([Mode of Delivery],'') [Mode of Delivery],[Room Name],Isnull([DEP Name],'') [DEP Name],[No of Participants],[Division Name]
from [dbo].[Room_Only_Regular_Schedule_Detail] t where  [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select 4 grp,t.[Created On] ,t.[Created By],'Cancel Provider Hours' [Stage], 'hourLimited' Legend, t.[Room Only Schedule Provider], t.[Clinic Date],datename(weekday,t.[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,t.[Clinic Date])/7.00 as float))[Clinic Schedule Week],t.[Cancel Start Time] ,t.[Cancel End Time],Null [Schedule Start Date],Null [Schedule End Date]
,casT((DATEDIFF(MINUTE,[Cancel Start Time],[Cancel End Time])) as float)/60  [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled]
 ,choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
 ,isnull([request notice period in weeks],0)  [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then 'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],t.[Reason for Cancel Hours][Notes],Location
,'' [Mode of Delivery],[Room Name],a.[DEP Name], a.[No of Participants],t.[Division Name]
from  [dbo].Shorten_Room_Only_Schedule t left join 
(
select distinct  [Room Only Schedule Provider],[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants]  from Room_Only_Regular_Schedule_Detail
union 
select distinct [Room Only Schedule Provider],[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants]  from Add_Room_Only_Schedule d
where [Room Only Schedule Provider] not in (select [Room Only Schedule Provider] from Room_Only_Regular_Schedule_Detail c where c.[Room Only Schedule Provider]=d.[Room Only Schedule Provider] and c.[Clinic Date] =d.[Clinic Date] )
)a on  a.[Room Only Schedule Provider]=t.[Room Only Schedule Provider]  and a.[Clinic Date]=t.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) and cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time)
where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL

select  5 grp,t.[Created On],t.[Created By],'Limit Provider Schedule' [Stage],'limitedSchedule' Legend, t.[Room Only Schedule Provider],t.[Clinic Date],datename(weekday,t.[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,t.[Clinic Date])/7.00 as float))[Clinic Schedule Week] ,t.[Clinic Start Time] ,t.[Clinic End Time],Null [Schedule Start Date],Null [Schedule End Date]
,casT((DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time])) as float)/60 [Clinic Hours] ,case when  t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date])
,t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
, isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month( t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month( t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month( t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month( t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month( t.[Clinic Date]) in (7,8,9) then 1
when Month( t.[Clinic Date]) in (10,11,12) then 2
when Month( t.[Clinic Date]) in (1,2,3) then 3
when Month( t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month( t.[Clinic Date]) >= 7 then 'FY' + right(year( t.[Clinic Date])+1,2) 
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  t.[Limit Schedule Reason][Notes],Location
 ,'' [Mode of Delivery],[Room Name],a.[DEP Name],[No of Participants],[Division Name]
from [dbo].Limit_Room_Only_Schedule t left join 
(
select distinct  [Room Only Schedule Provider],[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name]  from Room_Only_Regular_Schedule_Detail
union 
select distinct [Room Only Schedule Provider],[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name]  from Add_Room_Only_Schedule d
where [Room Only Schedule Provider] not in (select [Room Only Schedule Provider] from Room_Only_Regular_Schedule_Detail c where c.[Room Only Schedule Provider]=d.[Room Only Schedule Provider] and c.[Clinic Date] =d.[Clinic Date] )
)a on  a.[Room Only Schedule Provider]=t.[Room Only Schedule Provider]  and a.[Clinic Date]=t.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) and cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time)
where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL

select 6 grp,[Created On] ,[Created By],'Cancel' [Stage],'canceled' Legend,t.[Room Only Schedule Provider],t.[Clinic Date],datename(weekday,t.[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,t.[Clinic Date])/7.00 as float)) [Clinic Schedule Week],t.[Clinic Start Time] ,t.[Clinic End Time],Null [Schedule Start Date],Null [Schedule End Date]
,casT((DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time])) as float)/60 [Clinic Hours] ,case when t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,t.[Clinic Start Time],t.[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled]
, choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] 
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
when Month(t.[Clinic Date]) <= 6 then 'FY' + right(year(t.[Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],Location,'' [Mode of Delivery] ,[Room Name],a.[DEP Name],A.[No of Participants],[Division Name]
from [dbo].Cancel_Room_Only_Schedule t 
left join 
(
select distinct [Room Only Schedule Provider],[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants]  from Room_Only_Regular_Schedule_Detail
union 
select distinct [Room Only Schedule Provider],[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],[No of Participants]  from Add_Room_Only_Schedule d
where [Room Only Schedule Provider] not in (select [Room Only Schedule Provider] from Room_Only_Regular_Schedule_Detail c where c.[Room Only Schedule Provider]=d.[Room Only Schedule Provider] and c.[Clinic Date] =d.[Clinic Date] )
)a on  a.[Room Only Schedule Provider]=t.[Room Only Schedule Provider]  and a.[Clinic Date]=t.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(t.[Clinic Start Time]as time) and cast(a.[Clinic End Time]as time)=cast(t.[Clinic End Time]as time)
where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

GO
