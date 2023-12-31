USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_MDC_Irregular_Schedule_Alert]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE VIEW [dbo].[VW_MDC_Irregular_Schedule_Alert] 
AS

/*
selecT Distinct b.[Division Name], B.[Originating Process], [Message] =STUFF((SELECT  distinct ''+ a.[Message] FROM [Scheduler_Overlap_Message] a where a.[Originating Process]=b.[Originating Process] FOR XML PATH('')), 1, 0, '') 
from  [Scheduler_Overlap_Message] b
*/
selecT case when (select count(*) from MDC_Irregular_Schedule_Minimum_OneHostGuest_Alert)>0  then (select * from MDC_Irregular_Schedule_Minimum_OneHostGuest_Alert)
when (select count(*) from MDC_Irregular_Schedule_Overlap_Alert)>0 then (select * from MDC_Irregular_Schedule_Overlap_Alert)
else '' end as [Message] 
from  MDC_Irregular_Schedule_Overlap_Alert b







GO
