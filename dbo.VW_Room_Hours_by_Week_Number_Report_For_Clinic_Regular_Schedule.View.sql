USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Hours_by_Week_Number_Report_For_Clinic_Regular_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/****************************************************************************************************
**************************VW_Room_Hours_by_Week_Number_Report****************************************
*****************************************************************************************************
 Object Type 	  : View
 Object Name 	  : VW_Room_Hours_by_Week_Number_Report
 Version		  : V 3.0
 Project		  : Kezava Clinic Management System
 Created By		  : Chandru
 Created on 	  : Tuesday June 16 2020
 Last Modified By : 
 Last Modified on : 
 Purpouse		  :	Purpouse of this procedure is calculate Room Hours based on Week Number

***********************************************************************************************************
***********************************************************************************************************/
CREATE VIEW  [dbo].[VW_Room_Hours_by_Week_Number_Report_For_Clinic_Regular_Schedule]
as 
with [RoomHoursbyWeek] as
(
	select PRS.[Clinic Type],PRS.[Clinic Specialty]
	--,[Schedule Updated On]
	,'Week '+ cast([Clinic Schedule Week]as varchar) [Clinic Schedule Week],
	sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) [Total Room Hours Week]
	from Clinic_Regular_Schedule_FindRoom_ReferenceTable PRS 
	left join [Clinic_Specialty] EM on PRS.[Clinic Type]=EM.[Clinic Type] and PRS.[Clinic Specialty]=EM.[Clinic Specialty]
	group by PRS.[Clinic Type],PRS.[Clinic Specialty],[Clinic Schedule Week]
	--,[Schedule Updated On]
)
	selecT [Clinic Type],[Clinic Specialty]
	--,[Schedule Updated On]
	,'Room Hours by Week Number' 'Chart',[Clinic Schedule Week],[Total Room Hours Week] 
	from [RoomHoursbyWeek]










GO
