USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Available_Room_HoursvsUtilized_by_Location_Report_For_Clinic_Regular_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*************************************************************************************************************************
**************************VW_Available_Room_HoursvsUtilized_by_Location_Report********************************************
**************************************************************************************************************************
 Object Type 	  : View
 Object Name 	  : VW_Available_Room_HoursvsUtilized_by_Location_Report
 Version		  : V 3.0
 Project		  : Kezava Clinic Management System
 Created By		  : Chandru
 Created on 	  : Tuesday June 16 2020
 Last Modified By : 
 Last Modified on : 
 Purpouse		  :	Purpouse of this view is calculate Available Room Hours based on Location

***************************************************************************************************************************
**************************************************************************************************************************/

CREATE VIEW [dbo].[VW_Available_Room_HoursvsUtilized_by_Location_Report_For_Clinic_Regular_Schedule]
as 
with [RoomHoursbyLocation] as
(
	select		PRS.[Clinic Type],PRS.[Clinic Specialty]
				--,PRS.[Schedule Updated On]
				,PRS.Location,
				sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required])
				[Total Room Hours Week],
				sum([Rooms Required]*10*[Rooms Required])  as [Available Room Hours]
	from		Clinic_Regular_Schedule_FindRoom_ReferenceTable PRS 
	left join	[Clinic_Specialty] EM 
	on			PRS.[Clinic Type]=EM.[Clinic Type] and PRS.[Clinic Specialty]=EM.[Clinic Specialty]
	group by	PRS.[Clinic Type],PRS.[Clinic Specialty],PRS.Location
				--,PRS.[Schedule Updated On]
 )
	selecT	[Clinic Type],[Clinic Specialty]
			--,[Schedule Updated On]
			,'Available Room Hours vs Utilized by Location' 'Chart',
			Location,[Total Room Hours Week],[Available Room Hours]
	from	[RoomHoursbyLocation]
 
GO
