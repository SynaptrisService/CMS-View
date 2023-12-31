USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Cancel_Clinic_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create View [dbo].[VW_Cancel_Clinic_Report]
As
with canceldata as
(
select [Created On],[Split Reference Date],[Created By],[Clinic Type],[Clinic Specialty],[Clinic Date],[Location],[Clinic Start Time],[Clinic End Time],[Scheduled Clinic Time],
[Clinic Notes],[Reason For Cancellation],[Approver Notes to Scheduling Center],[Clinic Hours Category] from [2_45_Cancel Clinic] where [Clinic Date]>=cast(getdate() as date)
union 
select [Created On],[Split Reference Date],[Created By],[Clinic Type],[Clinic Specialty],[Clinic Date],[Location],[Clinic Start Time],[Clinic End Time],[Scheduled Clinic Time],
[Clinic Notes],[Reason For Cancellation],[Approver Notes to Scheduling Center],[Clinic Hours Category] from [Cancel_Clinic] where [Clinic Date]>=cast(getdate() as date)
--select distinct a.[Created On],a.[Created By],a.[Clinic Type],a.[Clinic Specialty],a.[Clinic Date],a.[Location],a.[Clinic Start Time],a.[Clinic End Time],a.[Scheduled Clinic Time],
--a.[Clinic Notes],a.[Reason For Cancellation],a.[Approver Notes to Scheduling Center],a.[Clinic Hours Category] from [Kezava_DM_V3_Psychiatry].[dbo].[2_Cancel Clinic] a inner join (select [Clinic Type],[Clinic Specialty],max([Created On])[Created On] from [Kezava_DM_V3_Psychiatry].[dbo].[2_Cancel Clinic]
--group by [Clinic Type],[Clinic Specialty])b on a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty]
--and a.[Created On]=b.[Created On]
),
Assignprovider as
(
select [Created On],[Created By],[Provider],[Clinic Type],[Clinic Specialty],[Clinic Date],[Location],[Clinic Start Time],[Clinic End Time],[Assign Start Time],[Assign End Time],
[Clinic Notes],isnull
		((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
		where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		and cast([Start Time Maximum Value] as time)
		and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		and cast([End Time Maximum Value] as time))),'All Day') [Clinic Hours Category]	
		from		
		(
		select * from [Provider_Assigned_Clinics]
		Union 
		select * from [Provider_Assigned_Clinics_History] where [Clinic Notes]='APC Removed due to Generic clinic cancel'
		)
		a
)
select distinct a.[Created On],a.[Split Reference Date],a.[Clinic Type],a.[Clinic Specialty],b.[Clinic Date],b.[Provider],b.[Assign Start Time],b.[Assign End Time] 
from canceldata a inner join Assignprovider b 
		on cast(a.[Clinic Date] as date)=cast(b.[Clinic Date] as date)
		and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] 
		and 
		(
		(cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time))
		or a.[Clinic Hours Category]=b.[Clinic Hours Category]
		)
GO
