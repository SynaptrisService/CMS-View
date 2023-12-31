USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Swap_Provider_Regular_Schedule_Picklist]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[VW_Swap_Provider_Regular_Schedule_Picklist] as 
select 
distinct [Division Name] ,provider , [Schedule Frequency],[Clinic Schedule Week],[Work Days],
--cast(cast([clinic start time] as time) as nvarchar(5))+'-'+cast(cast([clinic end time] as time) as nvarchar(5))
'1' [Clinic Schedule Time],
[Rooms Required],Location,Building,floor,wing,null Suite
 from [dbo].[ERD_Global_Schedule_Detail]
GO
