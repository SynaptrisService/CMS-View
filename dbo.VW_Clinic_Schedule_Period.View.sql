USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Schedule_Period]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[VW_Clinic_Schedule_Period] as 

selecT distinct  [Schedule Start Date],[Schedule End Date],[Clinic Type],[Clinic Specialty]   from [Clinic_Regular_Schedule] 
union 
selecT distinct [Schedule Start Date],[Schedule End Date],[Clinic Type],[Clinic Specialty]   from [Clinic_Regular_Schedule_History]


GO
