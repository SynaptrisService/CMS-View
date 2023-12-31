USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Employee_User_Mapping_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_Employee_User_Mapping_Report] 
as
WITH User_mapping 
as
(
select Distinct [Last Name],[First Name]
,(case when [employee group]='Division Approver' then 'Yes' else '-' end )as  [Division Approver]
,(case when [employee group]='Schedule Coordinator' then 'Yes' else '-' end )as [Schedule Coordinator]
,(case when [employee group]='Schedule Confirmer' then 'Yes' else '-' end )as [Schedule Confirmer]
,(case when [employee group]='Schedule Creator' then 'Yes' else '-' end )as [Schedule Creator]
,(case when [employee group]='Schedule Reviewer' then 'Yes' else '-' end )as [Schedule Reviewer]
,(case when [employee group]='Provider' then 'Yes' else '-' end )as [Provider]
,(case when [employee group]='Provider Delegate' then 'Yes' else '-' end )as [Provider Delegate]
,(case when [employee group]='Clinic Delegate' then 'Yes' else '-' end )as [Clinic Delegate]
,(case when [employee group]='MDC Schedule Coordinator' then 'Yes' else '-' end )as[MDC Schedule Coordinator]
,(case when [employee group]='MDC Schedule Confirmer' then 'Yes' else '-' end )as [MDC Schedule Confirmer]
,(case when [employee group]='MDC Schedule Creator' then 'Yes' else '-' end )as [MDC Schedule Creator]
,(case when [employee group]='MDC Schedule Reviewer' then 'Yes' else '-' end )as [MDC Schedule Reviewer] 
,(case when [employee group]='Room Only Schedule Coordinator' then 'Yes' else '-' end )as [Room Only Schedule Coordinator]
,(case when [employee group]='Room Only Schedule Confirmer' then 'Yes' else '-' end )as [Room Only Schedule Confirmer]
,(case when [employee group]='Room Only Schedule Creator' then 'Yes' else '-' end )as [Room Only Schedule Creator]
,(case when [employee group]='Room Only Schedule Reviewer' then 'Yes' else '-' end )as [Room Only Schedule Reviewer]
,(case when [employee group]='Calendar Viewer' then 'Yes' else '-' end )as [Calendar Viewer]
,(case when [employee group]='Clinical Staffing Manager' then 'Yes' else '-' end )as [Clinical Staffing Manager] 
,(case when [employee group]='Executive Team' then 'Yes' else '-' end )as [Executive Team] 
,[Windows User Name],[Email ID]
from (select [Last Name],[First Name],c.splitdata as [employee group],[Employee Login ID][Windows User Name],[Email ID]
from employee_master e
cross apply
[fnSplitString]([User group],';') c where (e.[Employee Status]='Active' or cast(isnull(e.[Last Day of Work],getdate())as date)>=cast(getdate() as date)) )x
)
select distinct [Last Name],[First Name]
,replace(STUFF((SELECT distinct ';' + [Division Approver] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Division Approver]
,replace(STUFF((SELECT distinct ';' + [Executive Team] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Executive Team]
,replace(STUFF((SELECT distinct ';' + [Schedule Coordinator] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Schedule Coordinator]
,replace(STUFF((SELECT distinct ';' + [Schedule Confirmer] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Schedule Confirmer]
,replace(STUFF((SELECT distinct ';' + [Schedule Creator] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Schedule Creator]
,replace(STUFF((SELECT distinct ';' + [Schedule Reviewer] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Schedule Reviewer]
,replace(STUFF((SELECT distinct ';' + [Provider] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Provider]
,replace(STUFF((SELECT distinct ';' + [Provider Delegate] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Provider Delegate]
,replace(STUFF((SELECT distinct ';' + [Clinic Delegate] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Clinic Delegate]
,replace(STUFF((SELECT distinct ';' + [MDC Schedule Coordinator] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [MDC Schedule Coordinator]
,replace(STUFF((SELECT distinct ';' + [MDC Schedule Confirmer] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [MDC Schedule Confirmer]
,replace(STUFF((SELECT distinct ';' + [MDC Schedule Creator] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [MDC Schedule Creator]
,replace(STUFF((SELECT distinct ';' + [MDC Schedule Reviewer] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [MDC Schedule Reviewer]
,replace(STUFF((SELECT distinct ';' + [Room Only Schedule Coordinator] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Room Only Schedule Coordinator]
,replace(STUFF((SELECT distinct ';' + [Room Only Schedule Confirmer] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Room Only Schedule Confirmer]
,replace(STUFF((SELECT distinct ';' + [Room Only Schedule Creator] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Room Only Schedule Creator]
,replace(STUFF((SELECT distinct ';' + [Room Only Schedule Reviewer] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Room Only Schedule Reviewer]
,replace(STUFF((SELECT distinct ';' + [Calendar Viewer] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Calendar Viewer]
,replace(STUFF((SELECT distinct ';' + [Clinical Staffing Manager] from User_mapping b where a.[Last Name]=b. [Last Name]  and a.[First Name]=b.[First Name] FOR XML PATH ('')), 1, 1,''),'-;','') [Clinical Staffing Manager]
,[Windows User Name],[Email ID],(select top 1 com_company_name from dbo.com_company where com_company_seq_id=1) as [Company Name]
 from User_mapping a 


GO
