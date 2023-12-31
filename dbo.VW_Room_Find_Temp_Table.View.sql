USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Find_Temp_Table]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[VW_Room_Find_Temp_Table] as 
select x.*,x1.[Room Category],x1.[Sink Available],x1.[Procedure Allowed],x1.[Suite] from 
(select   [Schedule Start Date], [Schedule End Date],[Provider],[Clinic Type],[Clinic Specialty],[Location],[Room Number]
,[Clinic Start Time],[Clinic End Time], [Clinic Start Time] [Request Start Time], [Clinic End Time][Request End Time],
 [Clinic Start Time] [Assign Room Setup Start Time],[Clinic end Time] [Assign Room Setup End Time]
 , [Clinic Start Time] [Req Room Setup Start Time],[Clinic end Time] [Req Room Setup End Time],[Clinic Duration],[Clinic Hours Category],
  'Occupied'   [Room Status] ,
 [Day of the Week] [Work Days],[Clinic Schedule Week],[Building],[Floor],[Wing],0 [Total Hours],[Room Name],
 null [Color Code],1 [Roomcnt],null [Room Finder Color Code],[rowno] from (
select *,ROW_NUMBER()over(partition by [Day of the Week],[Clinic Schedule Week],[Room Name] order by [Room Name])rowno from Regular_Provider_Schedule_Roomfind  )a
where rowno=1 )x left join [dbo].[ERD_Room_Master] x1
on x.[Room name] =x1.[room name]
--order by [Location],[Clinic Schedule Week],[Work Days],[Room Name]
GO
