USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_ClinicType_Scheduler_Overlap_Alert_Message]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VW_ClinicType_Scheduler_Overlap_Alert_Message] 
AS

/*
selecT Distinct b.[Division Name], B.[Originating Process], [Message] =STUFF((SELECT  distinct ''+ a.[Message] FROM [Scheduler_Overlap_Message] a where a.[Originating Process]=b.[Originating Process] FOR XML PATH('')), 1, 0, '') 
from  [Scheduler_Overlap_Message] b
*/
--selecT Distinct [Message] =STUFF((SELECT  distinct ''+ a.[Message] FROM [Clinic_Regular_Schedule_SchType_Message] a where 1=1 FOR XML PATH('')), 1, 0, '') 
--from  [Clinic_Regular_Schedule_SchType_Message] b

select * from Provider_Regular_Schedule_Overlap_Alert




GO
