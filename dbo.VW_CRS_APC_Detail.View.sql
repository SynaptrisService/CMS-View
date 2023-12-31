USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_CRS_APC_Detail]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create View [dbo].[VW_CRS_APC_Detail] As
with Crsdetail as
(
select [Created On],[Schedule Start Date],[Schedule End Date],[Clinic Type],[Clinic Specialty],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category],[Clinic Schedule Week],[Work Days] 
from [2_15_Clinic Regular Schedule] where [Schedule End Date]>=cast(getdate() as date)
union
select a.[Created On],a.[Schedule Start Date],a.[Schedule End Date],a.[Clinic Type],a.[Clinic Specialty],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category],a.[Clinic Schedule Week],a.[Work Days] 
from [Clinic_Regular_Schedule_Grid] a inner join (select [Clinic Type],[Clinic Specialty],[Clinic Schedule Week],[Work Days],[Location],max([Schedule Updated On])[Schedule Updated On]
from [Clinic_Regular_Schedule_Grid] group by [Clinic Type],[Clinic Specialty],[Clinic Schedule Week],[Work Days],[Location])b
on a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] and a.[Clinic Schedule Week]=b.[Clinic Schedule Week] and a.[Location]=b.[Location]
and a.[Work Days]=b.[Work Days] and a.[Schedule Updated On]=b.[Schedule Updated On] where a.[Schedule End Date]>=cast(getdate() as date)
Union
select a.[Created On],a.[Schedule Start Date],a.[Schedule End Date],a.[Clinic Type],a.[Clinic Specialty],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category],a.[Clinic Schedule Week],a.[Work Days] 
from [Clinic_Regular_Schedule_Grid_History] a inner join (select [Clinic Type],[Clinic Specialty],[Clinic Schedule Week],[Work Days],[Location],max([Schedule Updated On])[Schedule Updated On]
from [Clinic_Regular_Schedule_Grid_History] group by [Clinic Type],[Clinic Specialty],[Clinic Schedule Week],[Work Days],[Location])b
on a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] and a.[Clinic Schedule Week]=b.[Clinic Schedule Week] and a.[Location]=b.[Location]
and a.[Work Days]=b.[Work Days] and a.[Schedule Updated On]=b.[Schedule Updated On] where a.[Schedule End Date]>=cast(getdate() as date)
),
Assignprovider as
(
select [Created On],[Created By],[Provider],[Clinic Type],[Clinic Specialty],[Clinic Date],datename(dw,[Clinic Date])[Work Days],ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))[Clinic Schedule Week],
[Location],[Clinic Start Time],[Clinic End Time],[Assign Start Time],[Assign End Time],
[Clinic Notes],isnull
		((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
		where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		and cast([Start Time Maximum Value] as time)
		and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		and cast([End Time Maximum Value] as time))),'All Day') [Clinic Hours Category]	
		from		
		(
		select * from [Provider_Assigned_Clinics] where cast([Clinic Date] as date)>=cast(getdate() as date)
		Union 
		select * from [Provider_Assigned_Clinics_History] where [Clinic Notes]='APC Removed or Updated due to CRS Change' and cast([Clinic Date] as date)>=cast(getdate() as date)
		)
		a
	)
	select distinct a.* from 
	(
	select a.[Created On],a.[Clinic Type],a.[Clinic Specialty],a.[Clinic Schedule Week],a.[Work Days],b.[Clinic Date],b.[Provider],b.[Assign Start Time],b.[Assign End Time] from Crsdetail a inner join Assignprovider b 
	on a.[Work Days]=b.[Work Days]
		and a.[Clinic Schedule Week]=b.[Clinic Schedule Week]
		and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] 
		and 
		(
		(cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time))
		or a.[Clinic Hours Category]=b.[Clinic Hours Category]
		)
		and b.[Clinic Date] between a.[Schedule Start Date] and a.[Schedule End Date]
		)a inner join CRS_APC_Schedule_Date b on a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty]
		 where b.[Schedule End Date]>=cast(getdate() as date) and a.[Clinic Date] between b.[Schedule Start Date] and b.[Schedule End Date]

GO
