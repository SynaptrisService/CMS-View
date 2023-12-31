USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Room_Hold_Schedule_Expected_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [dbo].[VW_Provider_Room_Hold_Schedule_Expected_Report]
AS
select distinct x.Provider,x.[Created On],x.[Created By],x.[Schedule Start Date],x.[Schedule End Date],x.[Division Name]
,ABS(a.[Expected Hours])as [Expected Hours],ABS(a.[Schedule Hours])[Schedule Hours],ABS(a.Actual)Actual,ABS(a.Percentage)Percentage
,Case When [Expected Hours]=0 then 'Yes' Else'No' end [Status] 
from VW_Provider_Hold_Overview_Report_Expected a 
left join Employee_Master b on a.Provider=b.[Full Name]
left join
(select [Created On],[Created By],[Provider],[Schedule Start Date],[Schedule End Date],[Division Name] from Provider_Room_Hold_Schedule union
Select [Created On],[Created By],[Provider],[Schedule Start Date],[Schedule End Date],[Division Name] from [dbo].[2_32_Provider Room Hold Schedule] ) x
on x.Provider=a.Provider where [Employee type]='Provider' AND ISNULL(X.Provider,'')!=''

union 
select distinct a.[Provider], c.[Created On],c.[Created By],c.[Schedule Start Date],c.[Schedule End Date],c.[Division Name]
,ABS([Expected Hours])[Expected Hours],ABS([Schedule Hours])[Schedule Hours],ABS(Actual)Actual,ABS(Percentage)Percentage,Case When [Expected Hours]=0 then 'Yes' Else'No' end [Status] 
from [VW_Provider_Hold_Overview_Report_Expected_Inprogress] a
left join Employee_Master b on a.Provider=b.[Full Name]
left join 
(select [Created On],[Created By],[Provider],[Schedule Start Date],[Schedule End Date],[Division Name] from Provider_Room_Hold_Schedule union
Select [Created On],[Created By],[Provider],[Schedule Start Date],[Schedule End Date],[Division Name] from [dbo].[2_32_Provider Room Hold Schedule] ) 
c on c.provider=b.[Full Name] where A.provider not in(select distinct provider from VW_Provider_Hold_Overview_Report_Expected) 
AND [Employee type]='Provider' AND ISNULL(a.Provider,'')!=''






GO
