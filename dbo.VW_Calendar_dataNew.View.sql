USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Calendar_dataNew]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[VW_Calendar_dataNew]
as
WITH inprogressdata as (select concat([Originating Process],' Inprogress')[Originating Process],Provider,[Schedule Start Date],[Schedule End Date] from [2_28_Provider Regular Schedule]
union
select concat([Originating Process],' Inprogress')[Originating Process],[Clinic Specialty],[Schedule Start Date],[Schedule End Date] from [2_15_Clinic Regular Schedule]
union
select concat([Originating Process],' Inprogress')[Originating Process],[Room Only Schedule Provider],[Schedule Start Date],[Schedule End Date] from [2_50_Room Only Regular Schedule]
union
select concat([Originating Process],' Inprogress')[Originating Process],Provider,[Schedule Start Date],[Schedule End Date] from [2_32_Provider Room Hold Schedule]),
 Calendar
as
(
Select distinct a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] [Provider or Room Only Name],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
a.[Clinic Start Time],a.[Clinic End Time],a.[Ranks],a.[Rooms Required],a.[Building],a.[Floor],a.[Wing],a.[Room Name],a.[Kezava Unique ID],a.[Employee Login ID],
a.[Linked Clinic Name],a.[RowID],
Case when a.[originating process] ='Cancel Provider Clinic Inprogress' then 'canceled'
when  a.[originating process] ='Shorten Provider Clinic Inprogress' then 'hourLimited'
when  a.[originating process] ='Add Provider Clinic Inprogress' then 'added'
when  a.[originating process] ='Limit Provider Schedule Inprogress' then 'limitedSchedule' Else ''  end [Legends] 
,a.[Color code],a.[Userid],a.[CalendarOrder],a.[Display in Calendar]
,a.[Room Number],a.[Suite],a.[Mode of Delivery]
FROM [Clinic_Calendar] a left join VW_Cancel_Clinics b on a.Provider=b.Provider
and a.[Clinic Date]=b.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(b.[Clinic Start Time]as time)
and cast(a.[Clinic End Time]as time)=cast(b.[Clinic End Time]as time)
and a.Location=b.Location and a.[Originating Process] in ('Provider Regular Schedule',
'Provider Regular Schedule InProgress','Provider Room Hold Schedule','Provider Room Hold Schedule InProgress','Room Only Regular Schedule','Room Only Regular Schedule InProgress')
where [Display in Calendar]='Yes' and isnull(b.provider,'')=''
and not exists(select '' from ERD_Enterprise_Holiday_List h where a.[Clinic Date]=h.[Holiday Date])
)

,
Calendar_Final_1
as
(select * from ( 
select * from Calendar a where [originating process] in ('Provider Regular Schedule','Provider Room Hold Schedule','Room Only Regular Schedule')
and not exists (select '' from Calendar b where a.[Provider or Room Only Name]=b.[Provider or Room Only Name] 
and b.[Originating Process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress')
and a.[Clinic Date]=b.[Clinic Date])
union 
select * from Calendar a where 
[originating process] in ('Provider Regular Schedule InProgress','Provider Room Hold Schedule InProgress','Room Only Regular Schedule InProgress',
'Add Provider Clinic','Add Clinic','Add Room Only Schedule','Add As Covering Provider','Cancel Provider Clinic','Cancel MDC Clinic','Cancel MDC Clinic Inprogress','Cancel Provider Clinic Inprogress'
,'Cancel Room Only Schedule','Cancel Room Only Schedule Inprogress','Shorten Provider Clinic','Shorten Provider Clinic Inprogress','Shorten Room Only Clinic','Shorten Room Only Clinic Inprogress',
'Edit Provider Clinic','Edit Provider Clinic Inprogress','Limit Provider Schedule','Limit Provider Schedule Inprogress','Limit Room Only Schedule','Limit Room Only Schedule Inprogress','Limit Clinic Schedule',
'Limit Clinic Schedule Inprogress','Cancel Clinic','Cancel Clinic Inprogress','Shorten Clinic','Shorten Clinic Inprogress','Assign Provider Clinic')
union
select * from Calendar a where [originating process] in ('Clinic Regular Schedule')
and not exists (select '' from Calendar b where a.[Clinic Specialty]=b.[Clinic Specialty] 
and b.[Originating Process] in ('Clinic Regular Schedule InProgress')
and a.[Clinic Date]=b.[Clinic Date])
union 
select * from Calendar a where [originating process] in ('Clinic Regular Schedule InProgress'))t
where not exists (select '' from Clinic_Calendar t1 where [Originating Process] like '%cancel%'
and t.[Created On]<t1.[Created On] and t.[Clinic Date]=t1.[Clinic Date] and isnull(t.[Provider or Room Only Name],t.[Clinic Specialty] )=
 isnull(t1.Provider,t1.[Clinic Specialty] )and  cast(t.[Clinic Start Time]as time)=cast(t1.[Clinic Start Time] as time)
and cast(t.[Clinic End Time]as time)=cast(t1.[Clinic End Time] as time) and t.Location=t1.Location)
)
,
Calendar_Final as
(
select * from Calendar_Final_1 t
 where not exists (select [Clinic Date] from Calendar_Final_1 t1 where 
 t.[Created On]<t1.[Created On] and t.[Clinic Date]=t1.[Clinic Date] and isnull(t.[Provider or Room Only Name],t.[Clinic Specialty] )=
 isnull(t1.[Provider or Room Only Name],t1.[Clinic Specialty] )
 and cast(t.[Clinic Start Time]as time)=cast(t1.[Clinic Start Time]as time)
and cast(t.[Clinic End Time]as time)=cast(t1.[Clinic End Time]as time) and t.Location=t1.Location)
)
,

Calendar_Finalnew as(select Cast(count(distinct [Appointment Time]) as Nvarchar(100))+' Appts' Cnt,a.[Provider or Room Only Name] [RoomName],[clinic date] CDate ,[CLinic Start Time] Cst,[CLinic end Time]Cet from ( select    a.* ,b.[Full Name] from (Select [Appointment Date],[Appointment Time],StartTime,EndTime,[Visit Provider] from Patient_Appointment_Data_rank_table where  ltrim(rtrim(isnull([Visit Provider],',')))!=',') a join (select  distinct PROV_NAME,[Full Name] from ERD_Employee_Master_HL7 h  join employee_master e on isnull([active directory id],'')=isnull([Employee Login ID],''))b on  charindex([Visit Provider],b.prov_name)>0 ) z  left join Calendar_Final a  on  z.[Full Name]=a.[Provider or Room Only Name]  and cast(z.[Appointment Date] as date)=cast(a.[clinic date] as date)  where --isnull([Visit Type],'')!=''--z.[Full Name]=a.[Provider or Room Only Name]  and cast(z.[Appointment Date] as date)=cast(a.[clinic date] as date) cast(StartTime as time) between cast([CLinic Start Time] as time) and cast([CLinic End Time] as time)  and cast(Endtime as time) between cast([CLinic Start Time] as time) and cast([CLinic End Time] as time)  group by [Provider or Room Only Name],[clinic date],[CLinic Start Time] ,[CLinic end Time]  )

select  [Created On]      ,case when (a.[CLinic Date] between [Schedule Start Date] and [Schedule End Date] and isnull([Provider or Room Only Name],a.[CLinic Specialty])=b.Provider
and (a.[Originating Process] like '%Regular SChedule%' or a.[Originating Process] like '%hold SChedule%'))
then b.[Originating Process] else a.[Originating Process] end [Originating Process]
      ,[Clinic Date]      ,[Provider or Room Only Name]      ,[Clinic Type]      ,[Clinic Specialty]      ,[Location]      ,[Clinic Duration]
      ,[Clinic Start Time]      ,[Clinic End Time]      ,[Ranks]      ,[Rooms Required]      ,[Building]      ,[Floor]      ,[Wing]      ,[Room Name]      ,[Kezava Unique ID]
      ,[Employee Login ID]      ,[Linked Clinic Name]      ,[RowID]      ,[Legends]      ,[Color code]      ,[Userid]      ,[CalendarOrder]      ,[Display in Calendar]
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
c.cnt  end [No of Appointments Scheduled]
	   from Calendar_Final a
left join inprogressdata b 
on isnull([Provider or Room Only Name],a.[CLinic Specialty])=b.Provider 
left join  Calendar_FinalNew c on a.[Provider or Room Only Name]=c.[RoomName] and a.[Clinic Date]=c.CDateand a.[Clinic Start Time]=c.CST and [Clinic end Time]=c.Cet
-- Old query
/*
Select distinct a.[Created On],a.[Originating Process],a.[Clinic Date],a.[Provider] [Provider or Room Only Name],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Duration],
a.[Clinic Start Time],a.[Clinic End Time],a.[Ranks],a.[Rooms Required],a.[Building],a.[Floor],a.[Wing],a.[Room Name],a.[Kezava Unique ID],a.[Employee Login ID],
a.[Linked Clinic Name],a.[RowID],a.[Legends],a.[Color code],a.[Userid],a.[CalendarOrder],a.[Display in Calendar]
FROM [Clinic_Calendar] a left join VW_Cancel_Clinics b on a.Provider=b.Provider
and a.[Clinic Date]=b.[Clinic Date]
and cast(a.[Clinic Start Time]as time)=cast(b.[Clinic Start Time]as time)
and cast(a.[Clinic End Time]as time)=cast(b.[Clinic End Time]as time)
and a.Location=b.Location and a.[Originating Process] in ('Provider Regular Schedule',
'Provider Regular Schedule InProgress','Provider Room Hold Schedule','Provider Room Hold Schedule InProgress','Room Only Regular Schedule','Room Only Regular Schedule InProgress')
where [Display in Calendar]='Yes' and isnull(b.provider,'')=''
*/


















GO
