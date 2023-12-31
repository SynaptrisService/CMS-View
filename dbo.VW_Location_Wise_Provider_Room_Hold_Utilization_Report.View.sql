USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Location_Wise_Provider_Room_Hold_Utilization_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [dbo].[VW_Location_Wise_Provider_Room_Hold_Utilization_Report]
AS
WITH Provider_Wize_Location_CTE AS
(
SELECT [Created On], Provider ,Location, Sum([Clinic Hours])*[Rooms Required] AS [Provider Wise Location Hrs],[Division Name]
FROM [VW_Clinic_Schedule_and_Changes]
WHERE ISNULL([Stage], '') IN ('Provider Room Hold Schedule') AND ISNULL(provider, '') != ''
AND [Clinic Date] NOT IN (SELECT [holiday date]	FROM [dbo].[ERD_Enterprise_Holiday_List]) GROUP BY provider,Location ,[Division Name],[Rooms Required],[Created On]
),
Location_Schedule_Change
as
(
select [Created On],provider,Location,isnull(sum([Schedule Change Hours]),0) [Schedule Change Hours],[Division Name]
from (SELECT [Created On], Provider,Location,case when [Stage] in ('Cancel Provider Hours','Cancel') then SUM([Clinic Hours])*-1*[Rooms Required] else  SUM([Clinic Hours])*[Rooms Required] end [Schedule Change Hours]	
,[Division Name] FROM [VW_Clinic_Schedule_and_Changes] 
WHERE ISNULL([Stage], '') IN ('Add','Self Reported','Cancel Provider Hours','Cancel')
AND ISNULL(provider, '') != ''	AND [clinic date] NOT IN (SELECT [holiday date]	FROM [dbo].[ERD_Enterprise_Holiday_List])GROUP BY provider,stage,Location,[Division Name],[Rooms Required],[Created On])z
group by provider,Location,[Division Name],[Created On]
)
select distinct a.[Created On], isnull(a.Location,'') as Location,ISNULL(a.Provider,'') AS Provider,Isnull(Round((a.[Provider Wise Location Hrs] + c.[Schedule Change Hours]),0),0) as [Provider Wise Location Hrs]
,(100-Isnull(Round((a.[Provider Wise Location Hrs] + c.[Schedule Change Hours]),0),0)) as [Division]
from Provider_Wize_Location_CTE a 
Left join Location_Schedule_Change c on  a.Location=c.Location Where isnull(a.Location,'')!=''




GO
