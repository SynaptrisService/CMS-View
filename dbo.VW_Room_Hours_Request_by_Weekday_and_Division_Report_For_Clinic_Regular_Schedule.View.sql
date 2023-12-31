USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Hours_Request_by_Weekday_and_Division_Report_For_Clinic_Regular_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*************************************************************************************************************************
**************************VW_Room_Hours_Request_by_Weekday_and_Division_Report********************************************
**************************************************************************************************************************
 Object Type 	  : View
 Object Name 	  : VW_Room_Hours_Request_by_Weekday_and_Division_Report
 Version		  : V 3.0
 Project		  : Kezava Clinic Management System
 Created By		  : Chandru
 Created on 	  : Tuesday June 16 2020
 Last Modified By : 
 Last Modified on : 
 Purpouse		  :	Purpouse of this procedure is calculate Room Hours based on Week Days

***************************************************************************************************************************
**************************************************************************************************************************/

CREATE VIEW [dbo].[VW_Room_Hours_Request_by_Weekday_and_Division_Report_For_Clinic_Regular_Schedule]
as
with [RoomHoursWeekday] as
(
	select		PRS.[Clinic Type],PRS.[Clinic Specialty]
				--,[Schedule Updated On]
				, [Work Days],
				sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) 
				[Total Room Hours Weekday]
	from		Clinic_Regular_Schedule_FindRoom_ReferenceTable PRS 
	left join	[Clinic_Specialty] EM on PRS.[Clinic Type]=EM.[Clinic Type] and PRS.[Clinic Specialty]=EM.[Clinic Specialty]
	group by	PRS.[Clinic Type],PRS.[Clinic Specialty] ,[Work Days]
				--,[Schedule Updated On]
 ),
[clinichrs] as
( 
	select		distinct PRS.[Clinic Type],PRS.[Clinic Specialty]
				--,[Schedule Updated On]
				,[Work Days],
				((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) 
				[Total Clinic Hours Week]
	from		Clinic_Regular_Schedule_FindRoom_ReferenceTable PRS 
	left join	[Clinic_Specialty] EM on PRS.[Clinic Type]=EM.[Clinic Type] and PRS.[Clinic Specialty]=EM.[Clinic Specialty]
)
	selecT		distinct  RH.[CLinic Type],RH.[CLinic Specialty]
				--,RH.[Schedule Updated On]
				,'Room Hours Request by Weekday vs Division' 'Chart', RH.[Work Days]
				,RH.[Total Room Hours Weekday],CH.[Total Clinic Hours Week]	,RSM.[Avg Room Hours] [Division Average]
	from		[RoomHoursWeekday]  RH 
	left join	clinichrs CH on RH.[Clinic Type]=CH.[Clinic Type] and RH.[Clinic Specialty]=CH.[Clinic Specialty]
	and			RH.[Work Days]=CH.[Work Days]
	--and			RH.[Schedule Updated On]=CH.[Schedule Updated On]
	left join	[VW_Clinic_Regular_Scheduling_Metrics_Report]  RSM 
	on			RH.[Clinic Type]=RSM.[Clinic Type] and RH.[Clinic Specialty]=RSM.[Clinic Specialty]
	

	
	












GO
