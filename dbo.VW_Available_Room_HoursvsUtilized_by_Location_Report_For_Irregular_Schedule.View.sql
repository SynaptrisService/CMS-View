USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Available_Room_HoursvsUtilized_by_Location_Report_For_Irregular_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE view [dbo].[VW_Available_Room_HoursvsUtilized_by_Location_Report_For_Irregular_Schedule]
as 
with [RoomHoursbyLocation] as
(
	select [first name]+' '+[last name] Provider,[Schedule Updated On],[schedule interval], PRS.Location,
	sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) [Total Room Hours Week],
	sum([Rooms Required]*10*[Rooms Required])  as [Available Room Hours]
	from Provider_Irregular_Schedule_FindRoom_ReferenceTable_detail PRS 
	left join [employee_master] EM on PRS.Provider=EM.[full name] 
	group by [first name]+' '+[last name] ,PRS.Location,[schedule interval],[Schedule Updated On]
 )
	selecT Provider,[schedule interval],'Available Room Hours vs Utilized by Location' 'Chart',Location,[Total Room Hours Week],[Available Room Hours]
    from [RoomHoursbyLocation]
 







GO
