USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Employee_Inactivation_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE View [dbo].[VW_Employee_Inactivation_Report] as
select Distinct ltrim(rtrim(a.[Full Name])) [Full Name],a.[Employee Login ID],a.[Last Day of Work],a.[Inactive Date],a.[Inactive Reason]
,[Last Day of Work]+1 [Start Date],(select top 1 DATEADD(MM,-1,EOMONTH(DATEADD(MONTH,[Recurring Schedule Period],Getdate())))[Recurring Schedule End Date] 
from Division_Detail )[End Date],[Division Name]
, 
case when isnull(b.provider,'')=''
then 'The Provider does not have any scheduled clinics on or after the Inactivation date' else '' end 'Message'
from  Employee_master  a left join(select distinct provider  from [VW_Provider_Inactivation_Schedule_and_Changes_All] ) b on ltrim(rtrim(a.[Full Name]))=b.provider 
where a.[Employee Status]='Inactive'
and a.[Employee Login ID] in (select top 1 [Employee Login ID] from Employee_master  where [Employee Type]='provider' 
			and   [Employee Status]='Inactive'   order by [Submitted On] desc)
GO
