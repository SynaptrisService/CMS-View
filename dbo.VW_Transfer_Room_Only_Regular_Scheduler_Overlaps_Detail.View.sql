USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Transfer_Room_Only_Regular_Scheduler_Overlaps_Detail]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





Create view [dbo].[VW_Transfer_Room_Only_Regular_Scheduler_Overlaps_Detail]
as
select Distinct b.[Clinic Date],(RIGHT(CONVERT(VARCHAR, a.[assign start time], 100),7)) as[Start Time],(RIGHT(CONVERT(VARCHAR, a.[assign end time], 100),7)) as [End Tine]
,a.Provider,a.Location,a.[Clinic Schedule Week],a.[Work Days],a.[Room Number],a.[Clinic Hours Category],a.[req provider]
from [Regular_Schedule_Room_Finder_data_Transfer] a
Inner  join
(select Distinct provider,location,[Clinic schedule week],[work days],[Clinic Start Time],[Clinic end time],[Clinic date],[Room Number]
 from Room_Occupancy_details where isnull(Provider,'')!='' and [Originating Process] in ('Add Clinic','Add Provider Clinic','Add Room Only Schedule','Add As Covering Provider') )b
on a.provider=b.provider  
and a.[clinic schedule week]=b.[Clinic schedule week]
and a.[work days]=b.[work days] 
and a.location=b.location 
and a.[Room number]=b.[Room Number] 
and cast(a.[assign start time] as time)=cast(b.[Clinic Start Time] as time)
and cast(a.[assign end time] as time)=cast(b.[Clinic end time] as time)
inner join  (select [Room Only Schedule Provider] provider, [Created On] ,[clinic schedule week],[work days] ,[Clinic Start Time],
[Clinic End Time],location ,z.splitdata [Room number]
from  [2_50_Room Only Regular Schedule] cross apply (select * from fnSplitString([Room Number],';')) z
Union 
select [Room Only Schedule Provider]provider,[Created On] ,[clinic schedule week],[work days] ,[Clinic Start Time],[Clinic End Time],location ,z.splitdata [Room number]
from  [Room_Only_Regular_Schedule] cross apply (select * from fnSplitString([Room Number],';')) z) r on 
a.[Req Provider]=r.provider

and a.[clinic schedule week]=r.[Clinic schedule week]
and a.[work days]=r.[work days] 
and a.location=r.location 
and a.[Room number]=r.[Room Number]  
and cast(a.[Request Start Time] as time)=cast(r.[Clinic Start Time] as time)
and cast(a.[Request End Time] as time)=cast(r.[Clinic end time] as time)
where  a.[Room Status]='Unoccupied' and isnull(a.Provider,'')!='' 
and isnull(a.[Rooms Percentage],0)<=20 




GO
