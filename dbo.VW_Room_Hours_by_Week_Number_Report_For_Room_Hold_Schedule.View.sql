USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Hours_by_Week_Number_Report_For_Room_Hold_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/****************************************************************************************************
***********************VW_Room_Hours_by_Week_Number_Report_For_Room_Hold_Schedule********************
*****************************************************************************************************
 Object Type 	  : View
 Object Name 	  : VW_Room_Hours_by_Week_Number_Report_For_Room_Hold_Schedule
 Version		  : V 3.0
 Project		  : Kezava Clinic Management System
 Created By		  : Muthu
 Created on 	  : Thursday August 13 2020
 Last Modified By : 
 Last Modified on : 
 Purpouse		  :	Purpouse of this procedure is calculate Room Hours based on Week Number

***********************************************************************************************************
***********************************************************************************************************/
CREATE VIEW  [dbo].[VW_Room_Hours_by_Week_Number_Report_For_Room_Hold_Schedule]
as 
with [RoomHoursbyWeek] as
(
	select [first name]+' '+[last name]  Provider
	--,[Schedule Updated On]
	,'Week '+ cast([Clinic Schedule Week]as varchar) [Clinic Schedule Week],
	sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) [Total Room Hours Week]
	from Provider_Room_Hold_Schedule_FindRoom_ReferenceTable PRS 
	left join [employee_master] EM on PRS.Provider=EM.[full name]  
	group by [first name]+' '+[last name] ,[Clinic Schedule Week]
	--,[Schedule Updated On]
)
	selecT Provider
	--,[Schedule Updated On]
	,'Room Hours by Week Number' 'Chart',[Clinic Schedule Week],[Total Room Hours Week] 
	from [RoomHoursbyWeek]










GO
