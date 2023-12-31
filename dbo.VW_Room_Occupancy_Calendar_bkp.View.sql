USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Occupancy_Calendar_bkp]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










create view [dbo].[VW_Room_Occupancy_Calendar_bkp] as  
with 
RoomAssign as
(
	select a.[Clinic Date], a.[Provider],a.[Clinic Type],a.[Clinic Specialty],a.[Location]  ,a.[Room Number] ,a.[Clinic Start Time],a.[Clinic End Time]
	,null [Room Status] ,a.[Schedule Start Date],a.[Schedule end Date], a.[Work Days],a.[Clinic Schedule Week], 
	a.Building,a.Floor,a.Wing ,Datediff(hh,a.[Clinic Start Time],a.[Clinic End Time]) [Total Hours] 
	,a.[Room Name],Datediff(MINUTE,a.[Clinic Start Time],a.[Clinic End Time]) [Total Mins]
	from Room_Occupancy_Details a 
	where a.[Room Name] in (select b.[Room Name] 
	from [V3_Room-Management].dbo.[Room_Assignment_Detail]  b where a.[Clinic Date]=b.[Clinic Date] and a.Location=b.Location and a.Building=b.Building 
	and a.Floor=b.Floor  and a.Wing=b.wing)
	--and not exists (select '' from [Holiday_List] x where a.[Clinic Date]=x.[Holiday Date])	
) ,
roomsch as 
(
	select distinct  a.[Date],null  [Provider],null [Clinic Type],null [Clinic Specialty],a.[Location],a.[Room Number],a.[Start Time] [Star tTime],a.[End Time] [End Time]
	,'Unoccupied' [Room Status], a.[Schedule Start Date] , a.[Schedule end Date],a.[Work Days],a.[Clinic Schedule Week] 
	,a.Building,a.Floor,a.wing,Datediff(hh,a.[Start Time],a.[End Time]) [Total Hours],a.[Room Name] ,Datediff(MINUTE,a.[Start Time],a.[End Time]) [Total Mins] 
	from [V3_Room-Management].dbo.[Room_Schedule_Detail] a 
	where a.[Room Name] not in (select b.[Room Name] 
	from [V3_Room-Management].dbo.[Room_Assignment_Detail] b where a.[Date]=b.[Clinic Date] and a.Location=b.Location and a.Building=b.Building and a.Floor=b.Floor  and a.Wing=b.wing 
	--and not exists (select '' from [Holiday_List] x where b.[Clinic Date]=x.[Holiday Date])
	)
	),
dataset as 
(
	select *  
	,case when [Room Status]='Occupied' and [Total Hours]<2 then '#9bb764'   when [Room Status]='Occupied' and [Total Hours]>=2 and  [Total Hours]<=5 then '#faff05'
	when [Room Status]='Occupied' and [Total Hours]>5 then '#ff6347' else '#9bb764'   end 'Color Code' 
	,case when [Room Status]='Occupied' and [Used Hours]<2 then '#9bb764'   when [Room Status]='Occupied' and [Used Hours]>=2 and  [Used Hours]<=5 then '#faff05'
	when [Room Status]='Occupied' and [Used Hours]>5 then '#ff6347' else '#9bb764'   end 'PCLR Color Code' 
	,Dense_rank() over(partition by [clinic date],Building,[floor],wing,location,[room name] order by [room status],[used hours] desc) rankno
	from 
	(select * ,(select sum([Total Hours]) from  RoomAssign A WHERE A.[Clinic Date]=B.[Clinic Date] AND A.Location=B.Location
	AND A.Building=B.Building AND A.wing=B.wing AND A.[Floor]=B.[Floor] AND A.[Room Name]=B.[Room Name] and a.[Room Status]='Occupied') 'Used Hours'  
	from RoomAssign b  where b.[Room Status]='Unoccupied'	
	union
	select * ,(select sum([Total Hours]) from  RoomAssign A WHERE A.[Clinic Date]=B.[Clinic Date] AND A.Location=B.Location
	AND A.Building=B.Building AND A.wing=B.wing AND A.[Floor]=B.[Floor] AND A.[Room Name]=B.[Room Name] and a.[Room Status]='Occupied') 'Used Hours' from RoomAssign b   
	where  b.[Room Status]='Occupied'
	union
	select a.* ,0 from roomsch a 
	)x
)
select  a.[Clinic Date],a.[Provider],a.[Clinic Type],a.[Clinic Specialty],a.[Location],[Room Number],[Clinic Start Time],[Clinic End Time],[Room Status],[Schedule Start Date]
,[Schedule end Date],[Work Days],[Clinic Schedule Week],a.[Building],a.[Floor],a.[Wing],[Total Hours],a.[Room Name],[Used Hours],[Color Code]
,[PCLR Color Code],[rankno]
,case when a.rankno=1 then a.[PCLR Color Code] else '' end   PCLR ,case when datename(weekday,a.[clinic date]) ='Monday' then 2   
when datename(weekday,a.[clinic date]) ='Tuesday' then 3 
when datename(weekday,a.[clinic date])='Wednesday' then 4  
when datename(weekday,a.[clinic date]) ='Thursday' then 5  when datename(weekday,a.[clinic date])='Friday' then 6  when datename(weekday,a.[clinic date])='Saturday' then 7 
when datename(weekday,a.[clinic date])='Sunday' then 1  end 'Week Order' 
,(select top 1 [Room Category] from [V3_ERD].dbo.Room_Master where [room name]=a.[Room Name])as [Room Category]
from dataset  a 
where a.[Total Mins] > 0
 --and Location in  (select Location from [V3_ERD].dbo.Location_Master where [Location status] ='Yes') 











GO
