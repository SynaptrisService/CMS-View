USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Location_Comparison_Room_Hold_Schedule_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[VW_Location_Comparison_Room_Hold_Schedule_Report]
as
WITH Provider_Wize_Location_CTE AS
(
SELECT [Created On],Provider ,Location, Sum([Clinic Hours]) AS [Provider Wise Location Hrs]
FROM [VW_Clinic_Schedule_and_Changes]
WHERE ISNULL([Stage], '') IN ('Provider Room Hold Schedule') AND ISNULL(provider, '') != ''
AND [Clinic Date] NOT IN (SELECT [holiday date]	FROM [dbo].[ERD_Enterprise_Holiday_List])  GROUP BY provider,Location,[Created On] 
),
Location_Wize_CTE
AS
(
SELECT [Created On],Location, Sum([Clinic Hours]) AS [Location Hrs]
FROM [VW_Clinic_Schedule_and_Changes]
WHERE 
--ISNULL([Stage], '') not IN ('Provider Schedule', 'Irregular Provider Schedule','Assign Provider To Clinic') AND ISNULL(Provider, '') != ''
--AND 
[Clinic Date] NOT IN (SELECT [holiday date]	FROM [dbo].[ERD_Enterprise_Holiday_List])  GROUP BY Location,[Created On] 
),
Location_Schedule_Change
as
(
select [Created On], provider,Location,isnull(sum([Schedule Change Hours]),0) [Schedule Change Hours]
from (SELECT [Created On], Provider,Location,case when [Stage] in ('Cancel Provider Hours','Cancel') then SUM([Clinic Hours])*-1 else  SUM([Clinic Hours]) end [Schedule Change Hours]	
FROM [VW_Clinic_Schedule_and_Changes] 
WHERE ISNULL([Stage], '') IN ('Add','Self Reported','Cancel Provider Hours','Cancel')
AND ISNULL(provider, '') != ''	AND [clinic date] NOT IN (SELECT [holiday date]	FROM [dbo].[ERD_Enterprise_Holiday_List])GROUP BY provider,stage,Location,[Created On] )z
group by provider,Location,[Created On]
)
select distinct a.[Created On], isnull(b.Location,'') as Location,ISNULL(a.Provider,'') AS Provider
,case when Isnull(Round((a.[Provider Wise Location Hrs] + c.[Schedule Change Hours]),0),0)=0
then 0 else 
((b.[Location Hrs]/Isnull(Round((a.[Provider Wise Location Hrs] + c.[Schedule Change Hours]),0),0))/100) end as [Provider Wise Location Hrs] 
,case when b.[Location Hrs]=0
then 0 else 
((Isnull(Round((a.[Provider Wise Location Hrs] + c.[Schedule Change Hours]),0),0)/b.[Location Hrs])/100)end as [Division]
from Location_Wize_CTE b LEFT join Provider_Wize_Location_CTE a on a.location=b.location 
Left join Location_Schedule_Change c on  a.Location=c.Location and a.provider=c.provider
 where isnull(b.Location,'')!=''
and isnull(b.[Created On],'')!=''



GO
