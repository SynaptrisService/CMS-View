USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Scheduler_Overlap_Alert_Message]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[VW_Provider_Scheduler_Overlap_Alert_Message] 
AS
selecT Distinct [Message] =STUFF((SELECT  distinct ''+ a.[Message] FROM [Provider_Regular_Schedule_SchType_Message] a where 1=1 FOR XML PATH('')), 1, 0, '') 
from  [Provider_Regular_Schedule_SchType_Message] b

GO
