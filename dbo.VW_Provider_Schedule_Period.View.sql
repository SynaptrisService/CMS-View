USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Schedule_Period]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[VW_Provider_Schedule_Period] as 

selecT distinct  [Schedule Start Date],[Schedule End Date],Provider   from [Provider_Regular_Schedule] 
union 
selecT distinct [Schedule Start Date],[Schedule End Date] ,Provider   from [Provider_Regular_Schedule_History]
--select startdate [Schedule Start Date] ,enddate [Schedule End Date] ,Provider provider from dbo.days



GO
