USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Shorten_MDC_Clinic_Supporting_Report]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[VW_Shorten_MDC_Clinic_Supporting_Report]
AS
SELECT DISTINCT B.[Division Type],B.[Division Name],B.[Division Notification],B.[MDC Clinic Specialty],A.[Created On],B.[Clinic Type] 
 FROM (
SELECT  [Division Name],[Division Notification], [MDC Clinic Specialty],[Created On],[Clinic Type]  FROM [Shorten_MDC_Clinic] union
select  [Division Name],[Division Notification], [MDC Clinic Specialty],[Created On],[Clinic Type]  from [Kezava_DM_V3_Neurology].DBO.[2_60_Shorten MDC Clinic])A
inner join
(select distinct [Division Type],[Division Name],[Division Notification], [MDC Clinic Specialty],[Created On],[Clinic Type] from MDC_Regular_Schedule where [Division Type] ='GUEST')b
on a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] where isnull(b.[MDC Clinic Specialty],'')!='' 
GO
