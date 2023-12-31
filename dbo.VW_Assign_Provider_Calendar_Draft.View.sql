USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Assign_Provider_Calendar_Draft]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create view [dbo].[VW_Assign_Provider_Calendar_Draft] 
AS
select * from (

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
dateadd(MINUTE,datepart(MINUTE,[Assign end Time]),(dateadd(hour,datepart(hour,[Assign end Time]),[Clinic Date])))[Assign end Time] ,case when RowID=1  then '#d3d3d3'
when RowID=2  then '#d3d3d3'
when RowID=3 then '#d3d3d3'	
when RowID=4 then '#d3d3d3'	  
when RowID=5 then '#d3d3d3'	    
else '#d3d3d3' end as Assigncolor,rowid,
([Provider] +' '+ FORMAT([Assign Start Time],'hh:mm tt')  +' - '+  FORMAT([Assign end Time],'hh:mm tt')) as AssignedProviderdetail --here 'NL' renamed as ' '
from (SELECT  [Created On],[Clinic Date]
,[Clinic Start Time]
,[Clinic End Time]
,(replace(replace(right(Convert(VARCHAR(20),[Clinic Start Time],100),8),'AM',' AM'),'PM',' PM')+ ' To ' +replace(replace(right(Convert(VARCHAR(20),[Clinic End Time],100),8),'AM',' AM'),'PM',' PM'))[Scheduled Clinic Time]
---,LTRIM([Scheduled Clinic Time]) as [Scheduled Clinic Time]
,[Clinic Duration]
,[Location] as [Clinic Location]
,[Clinic Type]
,[Clinic Specialty]
,[Provider]
,NULL [Multi Specialty Clinic]
,[Kezava Unique ID]	
,[Assign Start Time] , [Assign End Time]
,DENSE_RANK()over(partition by [Clinic Date],[Clinic Specialty] order by cast([Clinic Start Time]as time),cast([Clinic end Time]as time) asc) RowID
FROM [2_53_Assign Provider to Clinic] with(nolock)
)x where not exists
	(Select  * from 
		(
		Select [Clinic Type],[Clinic Specialty],Location,[Clinic Date], [Kezava Unique ID] from Cancel_Provider_Clinic with(nolock)
		union
		Select [Clinic Type],[Clinic Specialty],Location,[Clinic Date], [Kezava Unique ID] from [2_34_Cancel Provider Clinic] with(nolock)
	)C where x.[Kezava Unique ID]=c.[Kezava Unique ID])
)a where exists
(
select '' from [Clinic_Regular_Schedule_Detail] b
where a.[Clinic Date]=b.[Clinic Date]
and a.[Clinic Type]=b.[Clinic Type]
and a.[Clinic Specialty]=b.[Clinic Specialty]
and a.[Clinic Location]=b.[Location]
and cast(ceiling(cast(right(CONVERT(Date,a.[Clinic Date],103), 2) as float) / 7.00) as nvarchar(10))=b.[Clinic Schedule Week]
and datename(weekday,CONVERT(Date,a.[Clinic Date],103))=b.[Work Days]
)
GO
