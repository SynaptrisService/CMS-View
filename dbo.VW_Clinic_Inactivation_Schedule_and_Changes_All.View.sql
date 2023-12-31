USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Inactivation_Schedule_and_Changes_All]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[VW_Clinic_Inactivation_Schedule_and_Changes_All] 
AS
select distinct a.*,b.[Full Name],b.[Employee Login ID] from [VW_Clinic_Schedule_and_Changes_All] a join employee_master b
on ltrim(rtrim(a.Provider))=ltrim(rtrim(b.[Full Name])) 
where isnull(b.[Employee Status],'')='Inactive' and [Clinic Date]>b.[Last Day of Work]
GO
