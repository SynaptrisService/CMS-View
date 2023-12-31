USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Transfer_Clinic_Regular_Scheduler_Overlaps_Detail]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





Create view [dbo].[VW_Transfer_Clinic_Regular_Scheduler_Overlaps_Detail]
as
select Distinct (Select top 1 isnull([Created On],'')  from (
select [CLinic Type],[Clinic Specialty],[Created On] from  [2_15_Clinic Regular Schedule]
Union 
select [CLinic Type],[Clinic Specialty],[Created On] from [Clinic_Regular_Schedule])P where p.[Clinic Specialty]=a.[Req Clinic Specialty]
and a.[Req Clinic Type]=p.[CLinic Type] )[Created on],
 b.[Clinic date],(RIGHT(CONVERT(VARCHAR, a.[assign start time], 100),7)) as[Start Time],(RIGHT(CONVERT(VARCHAR, a.[assign end time], 100),7)) as [End Time]
,[Req Clinic Specialty],a.Location,a.[Clinic Schedule Week],a.[Work Days]--,a.[Room Number],[re]
,[Req Clinic Type]
from Regular_Schedule_Room_Finder_data_Transfer a

Inner  join
(select Distinct [CLinic Type],[Clinic Specialty],location,[Clinic schedule week],[work days],[Clinic Start Time],[Clinic end time],[Clinic date],[Room Number]
from Room_Occupancy_details where 
 [Originating Process] in ('Add Clinic','Add Provider Clinic','Add Room Only Schedule','Add As Covering Provider') )b
on a.[Req Clinic Specialty]=b.[Clinic Specialty]  
and a.[Req Clinic Type]=b.[CLinic Type]  
and a.[clinic schedule week]=b.[Clinic schedule week]
and a.[work days]=b.[work days] 
and a.location=b.location 
and a.[Room number]=b.[Room Number] 
and cast(a.[assign start time] as time)=cast(b.[Clinic Start Time] as time)
and cast(a.[assign end time] as time)=cast(b.[Clinic end time] as time)
inner join  (select [CLinic Type],[Clinic Specialty],[Created On] ,[clinic schedule week],[work days] ,[Clinic Start Time],
[Clinic End Time],location ,z.splitdata [Room number]
from  [2_15_Clinic Regular Schedule] cross apply (select * from fnSplitString([Room Number],';')) z
Union 
select [CLinic Type],[Clinic Specialty],[Created On] ,[clinic schedule week],[work days] ,[Clinic Start Time],[Clinic End Time],location ,z.splitdata [Room number]
from  [Clinic_Regular_Schedule] cross apply (select * from fnSplitString([Room Number],';')) z) r on 
a.[Req Clinic Specialty]=r.[Clinic Specialty]
and 
a.[Req Clinic Type]=r.[CLinic Type]  
and a.[clinic schedule week]=r.[Clinic schedule week]
and a.[work days]=r.[work days] 
and a.location=r.location 
and a.[Room number]=r.[Room Number]  
and cast(a.[Request Start Time] as time)=cast(r.[Clinic Start Time] as time)
and cast(a.[Request End Time] as time)=cast(r.[Clinic end time] as time)
where  a.[Room Status]='Unoccupied' and isnull(a.[Req Provider],'')='' 
and isnull(a.[Rooms Percentage],0)<=20 



GO
