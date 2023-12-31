USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Assign_Provider_Calendar]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE view [dbo].[VW_Assign_Provider_Calendar] 
AS
select distinct * from 
(
select *, '0'[Draft Record] from 
(
select [Created On],[Clinic Date]
,dateadd(MINUTE,datepart(MINUTE,[Clinic Start Time]),(dateadd(hour,datepart(hour,[Clinic Start Time]),[Clinic Date])))[Clinic Start Time],
dateadd(MINUTE,datepart(MINUTE,[Clinic end Time]),(dateadd(hour,datepart(hour,[Clinic End Time]),[Clinic Date])))[Clinic End Time]
,[Scheduled Clinic Time]
,[Clinic Duration]
, [Clinic Location]
,[Clinic Type]
,[Clinic Specialty]
,[Provider]
,[Multi Specialty Clinic]
,[Kezava Unique ID]	
,dateadd(MINUTE,datepart(MINUTE,[Assign Start Time]),(dateadd(hour,datepart(hour,[Assign Start Time]),[Clinic Date])))[Assign Start Time],
dateadd(MINUTE,datepart(MINUTE,[Assign end Time]),(dateadd(hour,datepart(hour,[Assign end Time]),[Clinic Date])))[Assign end Time] ,case when RowID=1  then '#f3ffc5'
--when RowID=2  then '#f0f0f0'
--when RowID=3 then '#d3d3d3'	
--when RowID=4 then '#c9c9c9'	  
--when RowID=5 then '#b6b6b6'	    
else '#b6fafc' end as Assigncolor,rowid,
([Provider] +' '+ FORMAT([Assign Start Time],'hh:mm tt')  +' - '+  FORMAT([Assign end Time],'hh:mm tt')) as AssignedProviderdetail --here 'NL' renamed as ' '
from (SELECT [Created On],[Clinic Date]
,[Clinic Start Time]
,[Clinic End Time]
,LTRIM([Scheduled Clinic Time]) as [Scheduled Clinic Time]
,[Clinic Duration]
,[Location] as [Clinic Location]
,[Clinic Type]
,[Clinic Specialty]
,[Provider]
,[Multi Specialty Clinic]
,[Kezava Unique ID]	
,[Assign Start Time] , [Assign End Time]
,'1' RowID
FROM [dbo].[VW_Get_Assign_Clinic_Details] with(nolock)
)x  
)a 
Union All
select *,'1'[Draft Record] from [VW_Assign_Provider_Calendar_Draft] with(nolock)
)a where not exists(select '' from ERD_Enterprise_Holiday_List h where a.[Clinic Date]=h.[Holiday Date])

GO
