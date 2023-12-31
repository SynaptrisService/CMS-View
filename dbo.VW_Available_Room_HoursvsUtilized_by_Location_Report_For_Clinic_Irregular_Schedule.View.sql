USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Available_Room_HoursvsUtilized_by_Location_Report_For_Clinic_Irregular_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create view [dbo].[VW_Available_Room_HoursvsUtilized_by_Location_Report_For_Clinic_Irregular_Schedule]
as 
with [RoomHoursbyLocation] as
(
	select PRS.[Clinic Type],PRS.[Clinic Specialty],[Schedule Updated On],[schedule interval], PRS.Location,
	sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) [Total Room Hours Week],
	sum([Rooms Required]*10*[Rooms Required])  as [Available Room Hours]
	from Clinic_Irregular_Schedule_FindRoom_ReferenceTable_detail PRS 
	left join	[Clinic_Specialty] EM on PRS.[Clinic Type]=EM.[Clinic Type] and PRS.[Clinic Specialty]=EM.[Clinic Specialty]
	group by PRS.[Clinic Type],PRS.[Clinic Specialty] ,PRS.Location,[schedule interval],[Schedule Updated On]
 )
	selecT [Clinic Type],[Clinic Specialty],[schedule interval],'Available Room Hours vs Utilized by Location' 'Chart',Location,[Total Room Hours Week],[Available Room Hours]
    from [RoomHoursbyLocation]
 








GO
