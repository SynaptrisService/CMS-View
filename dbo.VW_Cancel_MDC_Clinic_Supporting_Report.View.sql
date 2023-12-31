USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Cancel_MDC_Clinic_Supporting_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_Cancel_MDC_Clinic_Supporting_Report]
AS
SELECT DISTINCT B.[Division Type],B.[Division Name],B.[Division Notification],B.[MDC Clinic Specialty],A.[Created On],B.[Clinic Type],A.[Split Reference Date]
 FROM (
SELECT  [Division Name],[Division Notification], [MDC Clinic Specialty],[Created On],[Clinic Type],[Split Reference Date] FROM Cancel_MDC_Clinic_Detail
union
select  [Division Name],[Division Notification], [MDC Clinic Specialty],[Created On],[Clinic Type],[Split Reference Date] from [Cancel_MDC_Clinic_Inprogress]
)A inner join
(select distinct [Division Type],[Division Name],[MDC Notification Status] as [Division Notification], [MDC Clinic Specialty],[Created On],[Clinic Type],''[Split Reference Date]
 from Define_MDC_Division_Participants where [Division Type] ='Guest')b
on a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] where isnull(b.[MDC Clinic Specialty],'')!='' 



GO
