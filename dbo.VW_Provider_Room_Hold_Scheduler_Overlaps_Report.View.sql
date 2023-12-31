USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Room_Hold_Scheduler_Overlaps_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[VW_Provider_Room_Hold_Scheduler_Overlaps_Report]
as
select Distinct (Select top 1 isnull([Created On],'')  from (
select Provider,[Created On] from  [2_32_Provider Room Hold Schedule]
Union 
select Provider,[Created On] from [Provider_Room_hold_Schedule]
)P where p.Provider=a.[Request Provider])[Created on],
 b.[Clinic date], (RIGHT(CONVERT(VARCHAR, r.[Clinic Start Time], 100),7)) as[Start Time],(RIGHT(CONVERT(VARCHAR, r.[Clinic End Time], 100),7)) as [End Tine]
,[Request Provider] as Provider,a.Location, a.[schedule week no] [Clinic Schedule Week],a.[day of week]  [Work Days]--,a.[Room Number]
from (select * from  [Room_Finder_Schedule_dataset_Rooms_Percentage]a  where  isnull(a.[Rooms Percentage],0)<=20 
and (isnull(a.[Rooms Percentage],0) >0 ) and isnull([Request Provider],'')!='') a  
inner join  
	(
	select Provider,[Created On] ,[clinic schedule week],[work days],[Clinic Hours Category] ,[Clinic Start Time],[Clinic End Time],location ,z.splitdata [Room number],[Schedule Start Date],[Schedule End Date]
	from  [2_32_Provider Room Hold Schedule] cross apply (select * from fnSplitString([Room Number],';')) z
	Union 
	select Provider,[Created On] ,[clinic schedule week],[work days],[Clinic Hours Category] ,[Clinic Start Time],[Clinic End Time],location ,z.splitdata [Room number],[Schedule Start Date],[Schedule End Date]
	from  [Provider_Room_hold_Schedule] cross apply (select * from fnSplitString([Room Number],';')) z
	where Provider  not in (select Provider  from  [2_32_Provider Room Hold Schedule] )
	) r on 
	isnull(a.[Request Provider],'')=isnull(r.Provider ,'') 
and a.[schedule week no]=r.[Clinic schedule week]
and a.[day of week]=r.[work days] 
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

 
--and cast(a.[Available Start Time] as time)=cast(b.[Clinic Start Time] as time)
--and cast(a.[Available end Time] as time)=cast(b.[Clinic end time] as time)
 
--and cast(a.[Available Start Time] as time)=cast(r.[Clinic Start Time] as time)
--and cast(a.[Request End Time] as time)=cast(r.[Clinic end time] as time)
Inner  join
			(
			select Distinct provider as [Overlap Provider],location,[Clinic schedule week],[work days],[Clinic Start Time],[Clinic end time],[Clinic date],[Room Number]
			from [Room_Assignment_Detail] where
			[Originating Process] not in ('Temporary Room Operations Hold Calendar','Temporary Room Operations Hold')
			union
			select Distinct provider as [Overlap Provider],location,[Clinic schedule week],[work days],[Clinic Start Time],[Clinic end time]
			,[Clinic date],[Room Number]
			from [Room_Assignment_Detail] where [Originating Process] in ('Temporary Room Operations Hold Calendar','Temporary Room Operations Hold')
			and  (isnull([Division Name],'')!=(select top 1 [Division Name] from Division_Detail)) 
			)b
on a.[schedule week no]=b.[Clinic schedule week]
and a.[day of week]=b.[work days] 
and a.location=b.location 
and a.[Room number]=b.[Room Number]  
and isnull(a.[Request Provider],'')!=isnull(b.[Overlap Provider],'')
and b.[Clinic Date] between r.[Schedule Start Date] and r.[Schedule End Date]
where isnull(a.[Request Provider],'')=isnull(r.Provider,'')

and isnull(a.[Request Provider],'')!=isnull(a.Provider,'') and [Clinic Date] between r.[Schedule Start Date] and r.[Schedule End Date]
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
