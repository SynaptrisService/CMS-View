USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Employee_FY_Contracted_Hours]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[VW_Employee_FY_Contracted_Hours] as
select [Employee Login ID], [FY Start Date],[FY End Date],concat(year([FY start Date]),' - ',year([FY End Date] ) )[FY Year],[Provider],case when year([submitted on]) =year(getdate()) then case when [adjusted fy contracted hours] in (null,0,'') then
[fy contracted hours] else [adjusted fy contracted hours] end else [fy contracted hours] end [Contracted Hours]
 from [employee_contract_hours]
 where [Record Status]='Active'

GO
