USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Get_Schedule_Details_in_Transfer_Hold_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_Get_Schedule_Details_in_Transfer_Hold_Schedule]
as 
select * from (select * from Provider_Regular_Schedule_grid

union
select * from Provider_Room_Hold_Schedule_grid)x
where isnull([Schedule Frequency],'')='Recurring'

GO
