USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Division_Room_Occupancy_Calendar]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




Create View [dbo].[VW_Division_Room_Occupancy_Calendar] as
(
select * from [V3_Room-Management].[dbo].[VW_Room_Occupancy_Calendar] where [Division Name]=(select Distinct [Division Name] from [Division_Detail])
)

GO
