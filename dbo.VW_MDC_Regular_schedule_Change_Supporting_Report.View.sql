USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_MDC_Regular_schedule_Change_Supporting_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[VW_MDC_Regular_schedule_Change_Supporting_Report]
AS
SELECT Distinct b.*,Isnull(c.[MDC Notification Status],'') as [Division Notification] from [Kezava_dm_v3_Neurology].[dbo].[2_MDC Regular Schedule Change Report] a left join
(select distinct [Clinic Type],[Created On], [MDC Clinic Specialty],[Division Type],[Division Name]
 from [Kezava_dm_v3_Neurology].dbo.[2_38_MDC Regular Schedule] where [Division Type] ='Guest'
)b
on a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty]
left join Define_MDC_Division_Participants c on a.[MDC Clinic Specialty]=c.[MDC Clinic Specialty]
 where isnull(b.[MDC Clinic Specialty],'')!=''
GO
