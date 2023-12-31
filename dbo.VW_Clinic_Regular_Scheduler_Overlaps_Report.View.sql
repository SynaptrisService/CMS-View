USE [V3_Neurology]
GO

/****** Object:  View [dbo].[VW_Clinic_Regular_Scheduler_Overlaps_Report]    Script Date: 9/4/2023 6:18:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[VW_Clinic_Regular_Scheduler_Overlaps_Report]
as
select Distinct (Select top 1 isnull([Created On],'')  from (
select [CLinic Type],[Clinic Specialty],[Created On] from  [2_15_Clinic Regular Schedule]
Union 
select [CLinic Type],[Clinic Specialty],[Created On] from [Clinic_Regular_Schedule]
)P where p.[Clinic Specialty]=a.[Request Clinic Specialty]
and a.[Request Clinic Type]=p.[CLinic Type] )[Created on],
 b.[Clinic date],(RIGHT(CONVERT(VARCHAR, r.[Clinic Start Time], 100),7)) as[Start Time],(RIGHT(CONVERT(VARCHAR, r.[Clinic End Time], 100),7)) as [End Time]
,[Request Clinic Specialty] [Req Clinic Specialty], [Request Clinic Type] as [Clinic Type] ,[Request Clinic Specialty] as [Clinic Specialty]
,a.Location,a.[Schedule Week No] [Clinic Schedule Week],a.[Day of Week] [Work Days]--,a.[Room Number]
from (select * from  [Room_Finder_Schedule_dataset_Rooms_Percentage]a  where  isnull(a.[Rooms Percentage],0)<=20 
and (isnull(a.[Rooms Percentage],0) >0 ) and isnull([Request Clinic Specialty],'')!='') a   
inner join  (select [CLinic Type],[Clinic Specialty],[Created On] ,[clinic schedule week],[work days],[Clinic Hours Category] ,[Clinic Start Time],
[Clinic End Time],location ,z.splitdata [Room number],[Schedule Start Date],[Schedule End Date]
from  [2_15_Clinic Regular Schedule] cross apply (select * from fnSplitString([Room Number],';')) z
Union 
select [CLinic Type],[Clinic Specialty],[Created On] ,[clinic schedule week],[work days],[Clinic Hours Category]  ,[Clinic Start Time],[Clinic End Time],location ,z.splitdata [Room number],[Schedule Start Date],[Schedule End Date]
from  [Clinic_Regular_Schedule] cross apply (select * from fnSplitString([Room Number],';')) z
where  CAST([CLinic Type] AS nvarchar(MAX))+CAST([Clinic Specialty] AS nvarchar(MAX)) not in (select  CAST([CLinic Type] AS nvarchar(MAX))+CAST([Clinic Specialty] AS nvarchar(MAX))  from  [2_15_Clinic Regular Schedule] )
) r on 
isnull(a.[Request Clinic Specialty],'')=isnull(r.[Clinic Specialty],'')
and 
isnull(a.[Request Clinic Type],'')=isnull(r.[CLinic Type]  ,'')
and a.[Schedule Week No]=r.[Clinic schedule week]
and a.[Day of Week]=r.[work days] 
and a.location=r.location 
and a.[Room number]=r.[Room Number]  
--and a.[Clinic Hours Category]=r.[Clinic Hours Category]  

and (cast(a.[Available Start Time] as time) between cast(r.[Clinic Start Time] as time) and cast(r.[Clinic End Time] as time)
	or cast(a.[Available End Time] as time) between cast(r.[Clinic Start Time] as time) and cast(r.[Clinic End Time] as time)
	or cast(r.[Clinic Start Time] as time) between cast(a.[Available Start Time] as time) and cast(a.[Available End Time] as time)
	or cast(r.[Clinic End Time] as time) between cast(a.[Available Start Time] as time) and cast(a.[Available End Time] as time))
	and (cast(r.[Clinic End Time]  as time)!= cast(a.[Available Start Time] as time) 
	and  (cast(r.[Clinic Start Time]  as time)!= cast(a.[Available End Time] as time))
	)
Inner  join
(select Distinct provider as [Overlap Provider],[Clinic Specialty],location,[Clinic schedule week],[work days],[Clinic Start Time],[Clinic end time],[Clinic date],[Room Number]
			from [Room_Assignment_Detail] where
			[Originating Process] not in ('Temporary Room Operations Hold Calendar','Temporary Room Operations Hold')
			union
			select Distinct provider as [Overlap Provider],[Clinic Specialty],location,[Clinic schedule week],[work days],[Clinic Start Time],[Clinic end time]
			,[Clinic date],[Room Number]
			from [Room_Assignment_Detail] where [Originating Process] in ('Temporary Room Operations Hold Calendar','Temporary Room Operations Hold')
			and  (isnull([Division Name],'')!=(select top 1 [Division Name] from Division_Detail)
))b
on   
 a.[schedule week no]=b.[Clinic schedule week]
and a.[day of week]=b.[work days] 
and a.location=b.location 
and a.[Room number]=b.[Room Number] 
--and isnull(a.[Request Clinic Specialty],'')!=isnull(b.[Clinic Specialty],'')

and b.[Clinic Date] =a.[Date]

--and cast(a.[Available Start Time] as time)=cast(b.[Clinic Start Time] as time)
--and cast(a.[Available end Time] as time)=cast(b.[Clinic end time] as time)

--and cast(a.[Request Start Time] as time)=cast(r.[Clinic Start Time] as time)
--and cast(a.[Request End Time] as time)=cast(r.[Clinic end time] as time)
where  isnull(a.[Request Provider],'')='' and isnull(a.[Request Clinic Specialty],'')=isnull(r.[Clinic Specialty] ,'')
and [Clinic Date] between r.[Schedule Start Date] and r.[Schedule End Date]
and isnull(a.[Rooms Percentage],0)<=20 
--and isnull(a.[Request Clinic Specialty],'')!=isnull(a.[Clinic Specialty],'')
and [Clinic Date] between r.[Schedule Start Date] and r.[Schedule End Date]
and isnull(a.[Rooms Percentage],0)<=20 
and (isnull(a.[Rooms Percentage],0) >0 
and isnull(a.[Rooms Percentage],0)<=20)  
and (cast(a.[Available Start Time] as time) between cast(b.[Clinic Start Time] as time) and cast(b.[Clinic End Time] as time)
	or cast(a.[Available End Time] as time) between cast(b.[Clinic Start Time] as time) and cast(b.[Clinic End Time] as time)
	or cast(b.[Clinic Start Time] as time) between cast(a.[Available Start Time] as time) and cast(a.[Available End Time] as time)
	or cast(b.[Clinic End Time] as time) between cast(a.[Available Start Time] as time) and cast(a.[Available End Time] as time))
	and (cast(b.[Clinic End Time]  as time)!= cast(a.[Available Start Time] as time) 
	and  (cast(b.[Clinic Start Time]  as time)!= cast(a.[Available End Time] as time))
	)
GO


