USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Schedule_and_Changes_All]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Provider_Schedule_and_Changes_All] 
AS 
--/* Previos View Name: [VW_Provider_All_Records] */
select Distinct 1 grp,[Created On] ,[System Submitter Name],[Created By],'Provider Schedule' [Stage], '' Legend, provider  ,[Clinic Type],[Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
,ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))	[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],[Schedule Start Date],[Schedule End Date]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,ISNULL([Mode of Delivery],'') [Mode of Delivery],[Room Name],Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].[Provider_Regular_Schedule_Detail] t where  [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct 2 grp,[Created On],[System Submitter Name],	[Created By],'Irregular Provider Schedule' [Stage], '' Legend, provider  ,[Clinic Type],[Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],[Schedule Start Date],[Schedule End Date]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,ISNULL([Mode of Delivery],'') [Mode of Delivery],[Room Name],Isnull([DEP Name],'') [DEP Name],0 [No of Participants]
from [dbo].Provider_Irregular_Schedule_Detail t where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct 2 grp,[Created On],[System Submitter Name],	[Created By],'Irregular Clinic Schedule' [Stage], '' Legend, provider  ,[Clinic Type],[Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],[Schedule Start Date],[Schedule End Date]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,'' [Mode of Delivery],[Room Name],Isnull([DEP Name],'') [DEP Name],0 [No of Participants]
from [dbo].Clinic_Irregular_Schedule_Detail t where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select distinct 3 grp,[Created On] ,[System Submitter Name],[Created By],'Add' [Stage], 'added' Legend, provider  ,[Clinic Type],[Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],Null [Schedule Start Date],Null [Schedule End Date]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
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
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],Location,ISNULL([Mode of Delivery],'') [Mode of Delivery],[Room Name],Isnull([DEP Name],'') [DEP Name],[No of Participants]
 from [dbo].Add_Provider_Clinic t 
where [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select Distinct 4 grp,t.[Created On] ,t.[System Submitter Name],t.[Created By],'Cancel Provider Hours' [Stage], 'hourLimited' Legend, t.provider, t.[Clinic Type], t.[Clinic Specialty], t.[Clinic Date],datename(weekday,t.[Clinic Date]) [Day of the Week]
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
,'' [Mode of Delivery],t.[Room Name],(select top 1 a.[DEP Name] from 
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
from  [dbo].[Shorten_Provider_Clinic] t 
where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 
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

UNION ALL

select Distinct 5 grp,t.[Created On],t.[System Submitter Name],t.[Created By],'Limit Provider Schedule' [Stage],'limitedSchedule' Legend, t.provider,t.[Clinic Type], t.[Clinic Specialty],t.[Clinic Date],datename(weekday,t.[Clinic Date]) [Day of the Week]
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
when Month( t.[Clinic Date]) <= 6 then 'FY' + right(year( t.[Clinic Date]),2) end as [Financial Year],  t.[Limit Schedule Reason][Notes],Location ,'' [Mode of Delivery],[Room Name],
(select top 1 a.[DEP Name] from 
(
select provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],[DEP Name],isnull([No of Participants],0) as [No of Participants],[Clinic Specialty],Location,Building,floor,suite,[Clinic Hours Category]  from Provider_Regular_Schedule_Detail
union all
select isnull(provider,'')provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],null [DEP Name],null [No of Participants],[Clinic Specialty],Location,Building,floor,suite,null[Clinic Hours Category]  from Provider_Assigned_Clinics
union  all
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
from [dbo].Limit_Provider_Schedule t where t.[clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 

UNION ALL

select Distinct 6 grp,[Created On] ,[System Submitter Name],[Created By],'Cancel' [Stage],'canceled' Legend,t.provider  ,[Clinic Type],[Clinic Specialty], t.[Clinic Date],datename(weekday,t.[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,t.[Clinic Date])/7.00 as float)) 	[Clinic Schedule Week]  ,t.[Clinic Start Time] ,t.[Clinic End Time],Null [Schedule Start Date],Null [Schedule End Date]
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
when Month(t.[Clinic Date]) <= 6 then 'FY' + right(year(t.[Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],T.Location,'' [Mode of Delivery] ,[Room Name],
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

UNION ALL

select Distinct 7 grp,[Created On] ,[System Submitter Name],[Created By],'Clinic Schedule' [Stage],'' Legend,provider  ,[Clinic Type],[Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week] ,[Clinic Start Time] ,[Clinic End Time],[Schedule Start Date],[Schedule End Date]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] ,0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],Location,ISNULL([Mode of Delivery],'') [Mode of Delivery],[Room Name],Isnull([DEP Name],'') [DEP Name],[No of Participants]
 from [dbo].[Clinic_Regular_Schedule_Detail] t 
where [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select Distinct 8 grp,[Created On],[System Submitter Name],[Created By],'Cancel Clinic Schedule' [Stage],'Canceled' Legend,provider,[Clinic Type],[Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],Null [Schedule Start Date],Null [Schedule End Date]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled],choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] , 0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],Location,'' [Mode of Delivery],[Room Name],NULL [DEP Name],[No of Participants]
 from [dbo].[Cancel_Clinic] t
where [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL 

select Distinct 9 grp,[Created On],[System Submitter Name],[Created By],'Assign Provider To Clinic' [Stage],'' Legend,t.provider  ,[Clinic Type],[Clinic Specialty], t.[Clinic Date],datename(weekday,t.[Clinic Date]) [Day of the Week]
, ceiling(cast(datepart(day,t.[Clinic Date])/7.00 as float))[Clinic Schedule Week],
[Assign Start Time] [Clinic Start Time] , [Assign End Time] [Clinic End Time],Null [Schedule Start Date],Null [Schedule End Date]
,casT((DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time])) as float)/60 [Clinic Hours] ,case when t.[Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Assign Start Time],[Assign End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] , 0 [request notice period in weeks]
,case when Month(t.[Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month(t.[Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month(t.[Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month(t.[Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month(t.[Clinic Date]) in (7,8,9) then 1
when Month(t.[Clinic Date]) in (10,11,12) then 2
when Month(t.[Clinic Date]) in (1,2,3) then 3
when Month(t.[Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month(t.[Clinic Date]) >= 7 then 'FY' + right(year(t.[Clinic Date])+1,2) 
when Month(t.[Clinic Date]) <= 6 then 'FY' + right(year(t.[Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],[Location] as Location,[Mode of Delivery],[Room Name],Isnull([DEP Name],'')[DEP Name],0 [No of Participants]
from [dbo].[Provider_Assigned_clinics] t where [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

--UNION ALL 

--select 10 grp,[Created On],[Created By],'Self Reported' [Stage],'added'  Legend,provider  ,[Clinic Type],[Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
--, ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week],[Start Time] ,[End Time],Null [Schedule Start Date],Null [Schedule End Date]
--,casT((DATEDIFF(MINUTE,[Start Time],[End Time])) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
--case when DATEDIFF(MINUTE,[Start Time],[End Time]) > 240 then 2
--when DATEDIFF(MINUTE,[Start Time],[End Time]) <= 0 then 0 
--when DATEDIFF(MINUTE,[Start Time],[End Time]) <= 240 then 1 end [Clinic Half Days]
--,0 [No of Appointments Scheduled] ,choose(datepart(weekday,t.[Clinic Date]),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date] , 0 [request notice period in weeks]
--,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
--when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
--when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
--when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
--end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
--when Month([Clinic Date]) in (10,11,12) then 2
--when Month([Clinic Date]) in (1,2,3) then 3
--when Month([Clinic Date]) in (4,5,6) then 4
--end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
--when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],'' [Reason For Cancellation],[Clinic Location] as Location from [dbo].[Provider_Self_Reported_Hours] t
--where [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])



union all

select Distinct 1 grp,[Created On] ,[System Submitter Name],[Created By],'Room Only Schedule' [Stage], '' Legend, [Room Only Schedule Provider]  ,null [Clinic Type],null [Clinic Specialty], [Clinic Date],datename(weekday,[Clinic Date]) [Day of the Week]
,ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))	[Clinic Schedule Week],[Clinic Start Time] ,[Clinic End Time],[Schedule Start Date],[Schedule End Date]
,casT((DATEDIFF(MINUTE,cast([Clinic Start Time] as time),cast([Clinic End Time] as time))) as float)/60 [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
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
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location,ISNULL([Mode of Delivery],'') [Mode of Delivery],[Room Name],Isnull([DEP Name],'') [DEP Name],[No of Participants]
from [dbo].[Room_Only_Regular_Schedule_Detail] t where  [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])





GO
