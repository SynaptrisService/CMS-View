USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Calendar_data]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  CREATE view [dbo].[VW_Calendar_data]
as
With Calendar
as
(
select * from ( 
select * from Clinic_Calendar a where [originating process] in ('Provider Regular Schedule','Provider Room Hold Schedule','Room Only Regular Schedule')
and not exists (select '' from Clinic_Calendar b where a.[Provider]=b.[Provider] 
and b.[Originating Process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress')
and a.[Clinic Date]=b.[Clinic Date])
and not exists (select '' from Clinic_Calendar c where a.[Provider]=c.[Provider] 
and c.[Originating Process] in ('Shorten Provider Clinic','Shorten Provider Clinic Inprogress')
and a.[Clinic Date]=c.[Clinic Date] and
(cast(c.[Clinic Start Time] as time) between  cast(a.[Clinic Start Time] as time) and cast( a.[Clinic End Time] as time)
		or   cast(c.[Clinic End Time]  as time) between  cast(a.[Clinic Start Time] as time) and cast( a.[Clinic End Time] as time)
		or cast(a.[Clinic Start Time]  as time) between  cast(c.[Clinic Start Time] as time) and cast( c.[Clinic End Time]  as time)
		or  cast(a.[Clinic End Time]  as time) between cast(c.[Clinic Start Time] as time) and cast( c.[Clinic End Time]  as time) 
		--			or 
		--			(select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
		--where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		--and cast([Start Time Maximum Value] as time)
		--and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		-- and cast([End Time Maximum Value] as time)))='All Day'
		)
		and (cast(a.[Clinic End Time]  as time)!= cast(c.[Clinic Start Time] as time) and 
		(cast(a.[Clinic Start Time]  as time)!= cast(c.[Clinic End Time] as time) ))
)
union all
select * from Clinic_Calendar a where 
[originating process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress',
'Add Provider Clinic','Add Provider Clinic Inprogress','Add Clinic','Add Clinic Inprogress','Add Room Only Schedule','Add Room Only Schedule Inprogress','Add As Covering Provider','Cancel Provider Clinic','Cancel MDC Clinic','Cancel MDC Clinic Inprogress','Cancel Provider Clinic Inprogress'
,'Cancel Room Only Schedule','Cancel Room Only Schedule Inprogress','Shorten Provider Clinic','Shorten Provider Clinic Inprogress','Shorten Room Only Clinic','Shorten Room Only Clinic Inprogress',
'Edit Provider Clinic Inprogress','Limit Provider Schedule','Limit Provider Schedule Inprogress','Limit Room Only Schedule','Limit Room Only Schedule Inprogress','Limit Clinic Schedule',
'Limit Clinic Schedule Inprogress','Cancel Clinic','Cancel Clinic Inprogress','Shorten Clinic','Shorten Clinic Inprogress','Assign Provider Clinic','Convert Clinic Inprogress'
,'Convert Clinic','Convert Provider Clinic Inprogress','Convert Provider Clinic')

union all
select * from Clinic_Calendar a where [originating process] in ('Clinic Regular Schedule')
and not exists (select '' from Clinic_Calendar b where a.[Clinic Specialty]=b.[Clinic Specialty] 
and b.[Originating Process] in ('Clinic Regular Schedule InProgress')
and a.[Clinic Date]=b.[Clinic Date])

union all 
select * from Clinic_Calendar a where [originating process] in ('Clinic Regular Schedule InProgress'))t
where not exists (select '' from Clinic_Calendar t1 where [Originating Process] like '%cancel%'
and t.[Created On]<t1.[Created On] and t.[Clinic Date]=t1.[Clinic Date] and isnull(t.[Provider],t.[Clinic Specialty] )=
 isnull(t1.Provider,t1.[Clinic Specialty] )and  cast(t.[Clinic Start Time]as time)=cast(t1.[Clinic Start Time] as time)
and cast(t.[Clinic End Time]as time)=cast(t1.[Clinic End Time] as time) and t.Location=t1.Location)

union all

select a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] [Provider or Room Only Name],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
a.[Clinic Start Time],a.[Clinic End Time],1 [Ranks],a.[Rooms Required],a.[Building],a.[Floor],a.[Wing],a.[Room Name], a.[Kezava Unique ID],a.[Employee Login ID],
a.[Linked Clinic Name],a.[RowID],''[Legends] 
,a.[Color code],a.[Userid],a.[CalendarOrder],a.[Display in Calendar]
,a.[Room Number],a.[Suite],a.[Mode of Delivery] from [Clinic_Calendar] a where [originating process]='Edit Provider Clinic'
and not exists
(
select '' from (select a.* from Provider_Regular_Schedule_Detail a 
inner join [Clinic_Calendar] b on
a.[Clinic Date]=b.[Clinic Date]
and a.[Provider]=b.[Provider]
and a.[Clinic Type]=b.[Clinic Type]
and a.[Clinic Specialty]=b.[Clinic Specialty]
and a.[Clinic Start Time]=b.[Clinic Start Time]
and a.[Clinic End Time]=b.[Clinic End Time]
and a.[Location]=b.[Location]
where b.[Originating Process]='Provider Regular Schedule'
)b
where a.[Clinic Date]=b.[Clinic Date]
and a.[Provider]=b.[Provider]
and a.[Clinic Type]=b.[Clinic Type]
and a.[Clinic Specialty]=b.[Clinic Specialty]
and a.[Clinic Start Time]=b.[Clinic Start Time]
and a.[Clinic End Time]=b.[Clinic End Time]
and a.[Location]=b.[Location]
and b.[Schedule Updated On]>a.[Created On]
)
),
nexts as
(
Select a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] [Provider or Room Only Name],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
a.[Clinic Start Time],a.[Clinic End Time],1 [Ranks],a.[Rooms Required],a.[Building],a.[Floor],a.[Wing],a.[Room Name], a.[Kezava Unique ID],a.[Employee Login ID],
a.[Linked Clinic Name],a.[RowID],
Case when a.[originating process] ='Cancel Provider Clinic Inprogress' then 'canceled'
when  a.[originating process] ='Shorten Provider Clinic Inprogress' then 'hourLimited'
when  a.[originating process] ='Add Provider Clinic Inprogress' then 'added'
when  a.[originating process] ='Limit Provider Schedule Inprogress' then 'limitedSchedule' Else ''  end [Legends] 
,a.[Color code],a.[Userid],a.[CalendarOrder],a.[Display in Calendar]
,a.[Room Number],a.[Suite],a.[Mode of Delivery]
FROM [Calendar] a left join VW_Cancel_Clinics b on a.Provider=b.Provider
and a.[Clinic Date]=b.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(b.[Clinic Start Time]as time)
and cast(a.[Clinic End Time]as time)=cast(b.[Clinic End Time]as time)
and a.Location=b.Location and a.[Originating Process] 
in 
(
'Provider Regular Schedule',
'Provider Regular Schedule InProgress',
'Provider Room Hold Schedule',
'Provider Room Hold Schedule InProgress',
'Room Only Regular Schedule',
'Room Only Regular Schedule InProgress'
)
where [Display in Calendar]='Yes' and isnull(b.provider,'')=''
and not exists(select '' from ERD_Enterprise_Holiday_List h where a.[Clinic Date]=h.[Holiday Date])
union all
Select a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] [Provider or Room Only Name],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
dateadd(hour,datepart(HOUR,a.[Clinic Start Time]),dateadd(MINUTE, datepart(MINUTE,a.[Clinic Start Time]),CONVERT(datetime, a.[Clinic Date], 103))) [Clinic Start Time]
,dateadd(hour,datepart(HOUR,a.[Clinic End Time]),dateadd(MINUTE, datepart(MINUTE,a.[Clinic End Time]),CONVERT(datetime, a.[Clinic Date], 103))) [Clinic End Time]
,1 [Ranks],0 [Rooms Required],a.[Building],a.[Floor],a.[Wing],a.[Room Name], a.[Kezava Unique ID],a.[Employee Login ID],
null [Linked Clinic Name],1 [RowID],
'canceled'[Legends] 
,null [Color code],null[Userid],null [CalendarOrder],a.[Display in Calendar]
,a.[Room Number],a.[Suite],a.[Mode of Delivery] from Cancel_Provider_Clinic a
inner join  Provider_Regular_Schedule_grid d on  a.provider=d.Provider and  isnull(d.[Clinic Schedule Week],'')!=''
 and  CHARINDEX(cast(ceiling(cast(right(CONVERT(Date, a.[Clinic Date], 103),2)
				as float)/7.00)as nvarchar(10)),d.[Clinic Schedule Week])>0 
		and		CHARINDEX(left(datename(weekday,CONVERT(Date, a.[Clinic Date], 103)),3),
				d.[Work Days])> 0 and a.[Clinic Date] between d.[schedule start date] and d.[Schedule End Date]
where not exists (select '' from [Calendar] b where a.[Clinic Date]=b.[Clinic Date]
and a.Provider=b.Provider and a.[Clinic Hours Category]=(select top 1 [Clinic Hours Category] from [V3_ERD].[dbo].Clinic_Hours_Category
where (cast(b.[clinic start time] as time) BETWEEN cast([Start Time Minimum Value] as time) and cast([Start Time Maximum Value] as time)
and cast(b.[clinic end time] as time) BETWEEN cast([End Time Minimum Value] as time) and cast([End Time Maximum Value] as time)))
 and b.[Originating Process]='Cancel Provider Clinic' )
 union
 select  [Created On],[Originating Process],[Clinic Date],[Provider],[Clinic Type],[Clinic Specialty],[Location],[Clinic Duration],[Clinic Start Time],
[Clinic End Time],[Ranks],[Rooms Required],[Building],[Floor],[wing],[Room Name],[Kezava Unique ID],[Employee Login ID],[Linked Clinic Name],[RowID],
[Legends],[Color code],[Userid],[CalendarOrder],[Display in Calendar],[Room Number],[Suite],[Mode of Delivery]
 from (
select [Created On],
		a.[Originating Process],a.[Clinic Date],a.[Provider],a.[Clinic Type],
		a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
		dateadd(hour,datepart(HOUR,a.[Assign Start Time]),dateadd(MINUTE, datepart(MINUTE,a.[Assign Start Time]),CONVERT(datetime, a.[Clinic Date], 103))) [Clinic Start Time],
		dateadd(hour,datepart(HOUR,a.[Assign End Time]),dateadd(MINUTE, datepart(MINUTE,a.[Assign End Time]),CONVERT(datetime, a.[Clinic Date], 103))) [Clinic End Time],
		1 [Ranks],''[Rooms Required]
		,[Building]
		,[Floor]
		,[wing]
		,[Room Name]
		,replace(replace(
					isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')
					+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')
					+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
					+isnull(convert(varchar(8),
					CONVERT(date, a.[Clinic Date], 103) , 112),''),',',''),' ','')[Kezava Unique ID]
		,a.[Employee Login ID],null [Linked Clinic Name],
		1 [RowID],null [Legends],null [Color code],null [Userid],null [CalendarOrder]
		, 'Yes' [Display in Calendar],[Room Number],[Suite],''[Mode of Delivery],isnull((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
        where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time)
        and cast([Start Time Maximum Value] as time)
        and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
        and cast([End Time Maximum Value] as time))),'All Day') [Clinic Hours Category] 
		FROM Provider_Assigned_Clinics a where cast([Clinic Date] as date)>=cast(getdate()-30 as date)
		and not exists (select '' from ERD_Enterprise_Holiday_List h where a.[Clinic Date]=h.[Holiday Date])
		)a
		where not exists
		(
		select '' from [Calendar] b
		where a.[Clinic Date]=b.[Clinic Date]
		and a.[Provider]=b.[Provider]
		and a.[Clinic Type]=b.[Clinic Type]
		and a.[Clinic Specialty]=b.[Clinic Specialty]
		and cast(b.[Clinic Date] as date)>=cast(getdate()-30 as date)
		and b.[Originating Process]='Assign Provider Clinic'
		and 
		(
		cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
		and (cast(a.[Clinic End Time] as time) = cast(b.[Clinic End Time] as time)
		)
		)
		)
		and not exists
		(
		select '' from 
		(
		select a.* from 
			(
			select [Clinic Date],[Clinic Type],[Clinic Specialty],[Provider],[Clinic Start Time],[Clinic End Time],[Originating Process],[Clinic Hours Category] from [Cancel_Clinic] 
			union all
			select [Clinic Date],[Clinic Type],[Clinic Specialty],[Provider],[Clinic Start Time],[Clinic End Time],[Originating Process],[Clinic Hours Category] from Cancel_Provider_Clinic
			) a

		inner join [Clinic_Calendar] b 
		on a.[Clinic Date]=b.[Clinic Date]
		and a.[Clinic Type]=b.[Clinic Type]
		and concat(a.[Clinic Specialty],isnull(a.[Provider],''))=concat(b.[Clinic Specialty],isnull(b.[Provider],''))
		and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
		and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time)
		where b.[Originating Process] in ('Cancel Clinic','Cancel Provider Clinic')
		)c
		where a.[Clinic Date]=c.[Clinic Date]
		and a.[Clinic Type]=c.[Clinic Type]
		and concat(a.[Clinic Specialty],isnull(a.[Provider],''))=concat(c.[Clinic Specialty],isnull(c.[Provider],''))
		and a.[Clinic Hours Category]=c.[Clinic Hours Category]
		)
 )
 select  [Created On] ,[Originating Process] ,[Clinic Date] ,  [Provider or Room Only Name]
 ,[Clinic Type] ,[Clinic Specialty] ,[Location] ,[Clinic Duration] , [Clinic Start Time]
 ,[Clinic End Time]
 , ROW_NUMBER() OVER(PARTITION BY [Clinic Date] ORDER BY ranks, [Clinic Date] ,[clinic start time],[clinic end time])  [Ranks] ,[Rooms Required] , [Building] , [Floor] , [Wing] ,[Room Name] , [Kezava Unique ID]
 , [Employee Login ID] , [Linked Clinic Name] ,  [RowID] ,  [Legends]
 ,  [Color code] , [Userid] ,  [CalendarOrder] , [Display in Calendar] , [Room Number]
 , [Suite] , [Mode of Delivery] ,[Stage] ,[Schedule Type]
 , [No of Appointments Scheduled]  from 
(
select [Created On]      ,case when (a.[CLinic Date] between [Schedule Start Date] and [Schedule End Date] and isnull([Provider or Room Only Name],a.[CLinic Specialty])=b.Provider
and (a.[Originating Process] like '%Regular SChedule%' or a.[Originating Process] like '%hold SChedule%'))
then b.[Originating Process] else a.[Originating Process] end [Originating Process]
      ,[Clinic Date]      ,[Provider or Room Only Name]      ,[Clinic Type]      ,[Clinic Specialty]      ,[Location]      ,[Clinic Duration]
      ,[Clinic Start Time]      ,[Clinic End Time]      , 2 [Ranks]      ,[Rooms Required]      ,[Building]      ,[Floor]      ,[Wing]      ,[Room Name]      , [Kezava Unique ID]
      ,[Employee Login ID]      ,[Linked Clinic Name]      ,[RowID]      ,isnull([Legends],'')[Legends]    ,[Color code]      ,[Userid]      ,[CalendarOrder]      ,[Display in Calendar]
      ,[Room Number]      ,[Suite]      ,[Mode of Delivery]      ,Case when a.[originating process]='Provider Regular Schedule' then 'Provider Schedule'
when a.[originating process] ='Provider Regular Schedule InProgress' then 'Provider Schedule' Else a.[originating process] End as Stage
,case when (a.[Originating Process] like '%Inprogress%' and a.[Originating Process] in ('Provider Regular Schedule InProgress','Clinic Regular Schedule InProgress',
'Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress')) then 'Schedule In Progress'
when (a.[Originating Process] like '%Inprogress%' and a.[Originating Process] like '%Short%') then 'Shorten In Progress'
when (a.[Originating Process] like '%Inprogress%' and a.[Originating Process] like '%Cancel%') then 'Cancel In Progress'
when (a.[Originating Process] like '%Inprogress%' and a.[Originating Process] like '%Add%') then 'Add In Progress'
when (a.[Originating Process] like '%Inprogress%' and a.[Originating Process] like '%Edit%') then 'Edit In Progress'
when (a.[Originating Process] like '%Inprogress%' and a.[Originating Process] like '%Limit%') then 'Limit In Progress'
when (a.[Originating Process] not like '%Inprogress%' and a.[Originating Process] in ('Provider Regular Schedule','Clinic Regular Schedule',
'Provider Room Hold Schedule','Room Only Regular Schedule')) then 'Schedule'
when (a.[Originating Process] not like '%Inprogress%' and a.[Originating Process] like '%Short%') then 'Shorten'
when (a.[Originating Process] not like '%Inprogress%' and a.[Originating Process] like '%Cancel%') then 'Cancel'
when (a.[Originating Process] not like '%Inprogress%' and a.[Originating Process] like '%Add%') then 'Add'
when (a.[Originating Process] not like '%Inprogress%' and a.[Originating Process] like '%Edit%') then 'Edit'
when (a.[Originating Process] not like '%Inprogress%' and a.[Originating Process] like '%Limit%') then 'Limit'
end [Schedule Type]
,case when (a.[Originating Process]  like '%Inprogress%' or a.[Originating Process] like '%Cancel%') then '0 Appts' else
isnull(c.cnt ,'0 Appts') end [No of Appointments Scheduled]  
from 
	(
	select * from nexts t
	where not exists (select [Clinic Date] from nexts t1 where 
	t.[Created On]<t1.[Created On] and t.[Clinic Date]=t1.[Clinic Date] and isnull(t.[Provider or Room Only Name],t.[Clinic Specialty] )=
	isnull(t1.[Provider or Room Only Name],t1.[Clinic Specialty] )
	and cast(t.[Clinic Start Time]as time)=cast(t1.[Clinic Start Time]as time)
	and cast(t.[Clinic End Time]as time)=cast(t1.[Clinic End Time]as time) and t.Location=t1.Location
	)
)a left join 
(
select concat([Originating Process],' Inprogress')[Originating Process],Provider,[Schedule Start Date],[Schedule End Date] from [2_28_Provider Regular Schedule]
union
select concat([Originating Process],' Inprogress')[Originating Process],[Clinic Specialty],[Schedule Start Date],[Schedule End Date] from [2_15_Clinic Regular Schedule]
union
select concat([Originating Process],' Inprogress')[Originating Process],[Room Only Schedule Provider],[Schedule Start Date],[Schedule End Date] from [2_50_Room Only Regular Schedule]
union
select concat([Originating Process],' Inprogress')[Originating Process],Provider,[Schedule Start Date],[Schedule End Date] from [2_32_Provider Room Hold Schedule]
)b 
on isnull([Provider or Room Only Name],a.[CLinic Specialty])=b.Provider 
left join  Patient_Appointment_Data_for_calendar c on a.[Provider or Room Only Name]=c.[Appt Provider] and a.[Clinic Date]=c.[Appt Date]
and a.[Clinic Start Time]=c.[Appt Start Time] and [Clinic end Time]=c.[Appt End Time]
)a where [Clinic Date] not in (select [Holiday Date] from [ERD_Enterprise_Holiday_List])


GO
