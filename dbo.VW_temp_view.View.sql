USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_temp_view]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VW_temp_view] as 
/*
selecT distinct  [Schedule Start Date],[Schedule End Date],Provider   from [Provider_Regular_Schedule] 
union 
selecT distinct [Schedule Start Date],[Schedule End Date] ,Provider   from [Provider_Regular_Schedule_History]
--select startdate [Schedule Start Date] ,enddate [Schedule End Date] ,Provider provider from dbo.days
*/
select * from provider_regular_schedule
union
select * from provider_regular_schedule_history

GO
