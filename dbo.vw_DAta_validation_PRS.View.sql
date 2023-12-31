USE [V3_Neurology]
GO
/****** Object:  View [dbo].[vw_DAta_validation_PRS]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_DAta_validation_PRS] as 
with PRSGRId as (select * from provider_regular_schedule_grid )

,prsdetail as (
select 'PRSGRIDNODETAILYES'  Issuein,a.[Provider]'Provider',a.[Clinic Date],a.[Clinic Start Time],a.[Clinic end Time],a.Location,a.[Room Number],
a.[Room Name], 
a.[Originating Process]  from Provider_Regular_Schedule_Detail  a left join PRSGRId  b on 
cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE) and a.Provider=b.[Provider] 
and a.[Clinic Schedule Week]=b.[Clinic Schedule Week] and a.[Work Days]=b.[Work Days]
and a.[Clinic Date] between b.[Schedule Start Date] and b.[Schedule end Date] and a.location=b.Location
where isnull(b.provider,'')='' and a.[Clinic Date]>cast(getdate()-5 as date)),

calendar as (
select'PRSGRIDNOCALENDARYES'  Issuein , a.[Provider or Room Only Name]'Provider',a.[Clinic Date],a.[Clinic Start Time],a.[Clinic end Time],a.Location,a.[Room Number],
a.[Room Name], 
a.[Originating Process] from VW_Calendar_data  a left join PRSGRId  b on 
cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE) and a.[Provider or Room Only Name]=b.[Provider] 
and CHARINDEX(cast(ceiling(cast(right(CONVERT(Date, a.[Clinic Date], 103),2)
				as float)/7.00)as nvarchar(10)),b.[Clinic Schedule Week])>0 
		and		CHARINDEX(left(datename(weekday,CONVERT(Date, a.[Clinic Date], 103)),3),
				b.[Work Days])> 0 
and a.[Clinic Date] between b.[Schedule Start Date] and b.[Schedule end Date] and a.location=b.Location
where  a.[Clinic Date]>cast(getdate()-5 as date)
and isnull(b.provider, '')='' and a.[Originating Process]='Provider Regular Schedule')
,
RAD as (
select'PRSGRIDNORADYES'  Issuein , a.[Provider]'Provider',a.[Clinic Date],a.[Clinic Start Time],a.[Clinic end Time],a.Location,a.[Room Number],
a.[Room Name], 
a.[Originating Process] from [Room_Assignment_Detail]  a left join PRSGRId  b on 
cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and a.[Clinic Schedule Week]=b.[Clinic Schedule Week]
and a.[Work Days]=b.[Work Days]
and a.[Clinic Date] between b.[Schedule Start Date] and b.[Schedule end Date] and a.location=b.Location
where  a.[Clinic Date]>cast(getdate()-5 as date)
and isnull(b.provider, '')='' and a.[Originating Process]='Provider Regular Schedule'  and a.[Division Name]=b.[Division Name]),

ROC as (
select'PRSGRIDNOROCYES'  Issuein , a.[Provider]'Provider',a.[Clinic Date],a.[Clinic Start Time],a.[Clinic end Time],a.Location,a.[Room Number],
a.[Room Name], 
a.[Originating Process] from Room_Occupancy_Details  a left join PRSGRId  b on 
cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and a.[Clinic Schedule Week]=b.[Clinic Schedule Week]
and a.[Work Days]=b.[Work Days]
and a.[Clinic Date] between b.[Schedule Start Date] and b.[Schedule end Date] and a.location=b.Location
where  a.[Clinic Date]>cast(getdate()-5 as date)
and isnull(b.provider, '')='' and a.[Originating Process]='Provider Regular Schedule'  and a.[Division Name]=b.[Division Name])


select * from calendar  
union
select * from prsdetail
union
select * from RAD
union
 select * from ROC

GO
