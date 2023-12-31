USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Building_Picklist]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create view  [dbo].[VW_Building_Picklist] as
select distinct b.[Location]
,b.[Department Name] [DEP Name],b.[Building]
from [ERD_Dep_Report] b Left join ERD_Location_Master a on a.Location=b.Location 
inner join [Division_Detail] c on b.Division=c.[Division Name]
left join [ERD_Room_Master] r on b.location=r.location
GO
