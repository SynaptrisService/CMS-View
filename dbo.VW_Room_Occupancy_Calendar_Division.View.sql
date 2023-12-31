USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Occupancy_Calendar_Division]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/************************************************************************************************************
*************************************VW_Room_Occupancy_Calendar_Division*************************************
*************************************************************************************************************
 Object Type 	  : Stored Procedure
 Object Name 	  : VW_Room_Occupancy_Calendar_Division
 Version		  : V 3.0
 Project		  : Kezava Clinic Management System
 Created By		  : Muthu
 Created on 	  : Friday September 25 2020
 Last Modified By : 
 Last Modified on : 
 Purpose		  :	This View Used to Identify the Occupied(Occupied Hours) and Unoccupied Status
*************************************************************************************************************
*************************************************************************************************************/

	--**************************************************************************
	--The below block Used to get the data from Room_Occupancy_Details Table
	--**************************************************************************

	   CREATE View [dbo].[VW_Room_Occupancy_Calendar_Division] as  
	   (
	     Select * from [V3_Room-Management].[dbo].[VW_Room_Occupancy_Calendar] where 
	     [Division Name]=(select Distinct [Division Name] from [Division_Detail])
	   )
		

GO
