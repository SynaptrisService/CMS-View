USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Overeview_Appointment_VisitType_27Aug2021]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW  [dbo].[VW_Provider_Overeview_Appointment_VisitType_27Aug2021]
as 
/****** Script for SelectTopNRows command from SSMS  ******/
seleCT  distinct  b.[Full Name] [Visit Provider],[APPT_Date]AS [Appointment Date],[APPT_TIME] as StartTime
,[APPT_TIME] as EndTime,[After Visit Summary  PRINT time] as SCH_Appt_Duration,
[Visit Type]=
(select   stuff((
	select ';'+u.[APPT_PRC_ID]+' - '+u.Location_Department_Name
		from dbo.[Patient_Appointment_Data] u
	where u.[PROV_NAME] = x.[PROV_NAME] and  u.[APPT_Date] = x.[APPT_Date] 
	and u.[CHECKIN_TIME] =  x.[CHECKIN_TIME]  	 and u.[CHECKOUT_TIME]= x.[CHECKOUT_TIME] 
for xml path('') ),1,1,''))
 from dbo.[Patient_Appointment_Data] x  left join Employee_Master b 
 on charindex(x.[PROV_NAME],b.[Full Name])>0
 where len([PROV_NAME])>1

/* --V2 Query
seleCT  distinct  b.[Employee Full Name] [Visit Provider],[Appointment Date],StartTime,EndTime,SCH_Appt_Duration,
[Visit Type]=
(select   stuff((
	select ';'+u.[Cancel Reason]+' - '+u.SCH_Entity_Identifier	from Patient_Appointment_Data_rank_table u
	where u.[Visit Provider] = x.[Visit Provider] and  u.[Appointment Date] = x.[Appointment Date] 
	and u.StartTime =  x.StartTime  	 and u.EndTime= x.EndTime 
for xml path('') ),1,1,''))
 from Patient_Appointment_Data_rank_table x  left join Employee_Master b on charindex(x.[Visit Provider],b.[Employee Full Name])>0
 where len([Visit Provider])>1

*/

GO
