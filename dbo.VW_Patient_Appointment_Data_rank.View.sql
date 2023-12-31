USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Patient_Appointment_Data_rank]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VW_Patient_Appointment_Data_rank] as 
with Appointment as (
SELECT distinct  [Visit Provider],cast([Appointment Date] as date) [Appointment Date]
,[Appointment Date] StartTime
,  DateAdd(MINUTE,cast(SCH_Appt_Duration as int),[Appointment Date])  EndTime,SCH_Appt_Duration,[Cancel Reason],SCH_Entity_Identifier
,[Appointment Time],ROW_NUMBER() over(partition by [SCH_Entity_Identifier] order by [Created On] desc) rno 
,[AIP_3.1]
from Patient_Appointment_Data_HL7  where  isnull([Visit Type],'')!='' 

),

Appointmentrno1 as(selecT* from Appointment where rno=1 )


select * from  Appointmentrno1
GO
