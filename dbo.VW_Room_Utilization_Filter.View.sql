USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Utilization_Filter]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_Room_Utilization_Filter] as 
select  distinct Top 100000000 Location,Building,[Floor],s.Suite from VW_Clinic_Schedule_and_Changes a
cross apply(select  splitdata as [Suite] from fnSplitString([Suite],';'))s
where Location in (SELECT Location FROM ERD_Location_Master WHERE ISNULL([Room Mandatory],'No')='Yes')  and isnull(a.[Suite],'')!=''
and  isnull(Building,'')!='' order by Location,Suite,[Floor],Building

GO
