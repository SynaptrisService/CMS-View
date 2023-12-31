USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_MDC_Irregular_Schedule_Change_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




Create view [dbo].[VW_MDC_Irregular_Schedule_Change_Report] as
with weeknoday as
(
selecT * from WeekNumber_Day left join (select distinct provider,[Clinic Date],[Clinic Start Time],[Clinic End Time],Location,[Schedule Interval],[Clinic Type],[Clinic Specialty],[MDC Clinic Specialty],[Created On],[Schedule Updated On],[Created By],[Schedule Start Date],[Schedule End Date],[Schedule Type],[Clinic Schedule Notes],[Division Name],[Division Notification],[Division Type],[Clinic Template] from MDC_Irregular_Schedule_Detail 
--where [Provider]='Brook, Sandra' and [Clinic Date]='04/02/2020'
) p on 1=1 
)
--select * from weeknoday where [Provider]='Brook, Sandra' and [Clinic Date]='04/02/2020'
,
Live as
(
selecT distinct [Created On],[Schedule Updated On],[Created By],provider,[Clinic Date],[Clinic Type],[Clinic Specialty],[MDC Clinic Specialty],[Schedule Start Date],[Schedule End Date],[Schedule Interval],Location,
[Clinic Start Time],[Clinic End Time],[Schedule Type],[Clinic Schedule Notes],[Division Name],[Division Notification],[Division Type],[Clinic Template],
--concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic Start Time],100),8)),7),' to ' 
--,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic End Time],100),8)),7),Location,convert(varchar(8),CONVERT(date, [Clinic Date], 103) , 112),[Division Name],case when [Clinic Template]='Provider' then provider else [Clinic specialty] end,';') Detail,

[Kezava Unique ID],[Clinic Notes]
from MDC_Irregular_Schedule_Detail --where [Provider]='Brook, Sandra' and [Clinic Date]='04/02/2020'
)
,
his as  
(
select [Created On],a.[Schedule Updated On],[Created By],ISNULL(A.PROVIDER,'Clinic') Provider,[Clinic Date],a.[Clinic Type],a.[Clinic Specialty],a.[MDC Clinic Specialty],[Schedule Start Date],[Schedule End Date],[Schedule Interval],Location,
a.[Clinic Start Time],a.[Clinic End Time],[Schedule Type],[Clinic Schedule Notes],a.[Division Name],[Division Notification],[Division Type],[Clinic Template],
--concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic Start Time],100),8)),7),' to ' 
--,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic End Time],100),8)),7),Location,convert(varchar(8),CONVERT(date, [Clinic Date], 103) , 112),a.[Division Name],case when [Clinic Template]='Provider' then provider else a.[Clinic specialty] end,';') Detail,
[Kezava Unique ID],[Clinic Notes]
from MDC_Irregular_Schedule_Detail_History a inner join (select [Clinic Type],[Clinic Specialty],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time],max([Schedule Updated On]) [Schedule Updated On] 
from  MDC_Irregular_Schedule_Detail_History group by [Clinic Type],[Clinic Specialty],[MDC Clinic Specialty],[Clinic Start Time],[Clinic End Time]) b 
on a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.[Schedule Updated On]=b.[Schedule Updated On]
--where [Provider]='Brook, Sandra' and [Clinic Date]='04/02/2020'
)
,
dataset as
(
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],ISNULL(A.PROVIDER,'Clinic') Provider,FORMAT (a.[Clinic Date], 'MM/dd/yyyy')[Clinic Date],a.[Clinic Start Time],a.[Clinic End Time],a.Location,a.[Schedule Interval],A.[Clinic Type],A.[Clinic Specialty],A.[MDC Clinic Specialty],FORMAT (A.[Schedule Start Date], 'MM/dd/yyyy')[Schedule Start Date],FORMAT (A.[Schedule End Date], 'MM/dd/yyyy')[Schedule End Date],A.[Schedule Type],a.[Clinic Schedule Notes],A.[Division Name],A.[Division Notification],A.[Division Type],A.[Clinic Template],b.[Clinic Notes]
,b.[Kezava Unique ID] LiveDetails ,c.[Kezava Unique ID]  HisDetails,'Schedule' 'Status'
from weeknoday a left join live b on a.[Clinic Date]=b.[Clinic Date] and a.[Schedule Interval]=b.[Schedule Interval] and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.[Clinic Start Time]=b.[Clinic Start Time] and isnull(a.[provider],'')=isnull(b.[provider],'')
                 inner join his c on a.[Clinic Date]=c.[Clinic Date] and a.[Schedule Interval]=c.[Schedule Interval] and a.[MDC Clinic Specialty]=c.[MDC Clinic Specialty] and a.[Clinic Start Time]=c.[Clinic Start Time] and isnull(a.[provider],'')=isnull(c.[provider],'') and isnull(b.[Kezava Unique ID],'')=isnull(c.[Kezava Unique ID],'')
union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],ISNULL(A.PROVIDER,'Clinic') Provider,FORMAT (a.[Clinic Date], 'MM/dd/yyyy')[Clinic Date],a.[Clinic Start Time],a.[Clinic End Time],a.Location,a.[Schedule Interval],A.[Clinic Type],A.[Clinic Specialty],A.[MDC Clinic Specialty],FORMAT (A.[Schedule Start Date], 'MM/dd/yyyy')[Schedule Start Date],FORMAT (A.[Schedule End Date], 'MM/dd/yyyy')[Schedule End Date],A.[Schedule Type],a.[Clinic Schedule Notes],A.[Division Name],A.[Division Notification],A.[Division Type],A.[Clinic Template],b.[Clinic Notes]
,b.[Kezava Unique ID] LiveDetails,c.[Kezava Unique ID] HisDetails,'Add' 'Status'
from weeknoday a left join live b on a.[Clinic Date]=b.[Clinic Date] and a.[Schedule Interval]=b.[Schedule Interval] and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.[Clinic Start Time]=b.[Clinic Start Time] and isnull(a.[provider],'')=isnull(b.[provider],'')
                 left join his c on a.[Clinic Date]=c.[Clinic Date] and a.[Schedule Interval]=c.[Schedule Interval]  and a.[MDC Clinic Specialty]=c.[MDC Clinic Specialty] and a.[Clinic Start Time]=c.[Clinic Start Time] and isnull(a.[provider],'')=isnull(c.[provider],'') and isnull(b.[Kezava Unique ID],'')=isnull(c.[Kezava Unique ID],'') where  isnull(b.[Kezava Unique ID],'')!='' and isnull(c.[Kezava Unique ID],'')=''
union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],ISNULL(A.PROVIDER,'Clinic') Provider,FORMAT (a.[Clinic Date], 'MM/dd/yyyy')[Clinic Date],a.[Clinic Start Time],a.[Clinic End Time],a.Location,a.[Schedule Interval],A.[Clinic Type],A.[Clinic Specialty],A.[MDC Clinic Specialty],FORMAT (A.[Schedule Start Date], 'MM/dd/yyyy')[Schedule Start Date],FORMAT (A.[Schedule End Date], 'MM/dd/yyyy')[Schedule End Date],A.[Schedule Type],a.[Clinic Schedule Notes],A.[Division Name],A.[Division Notification],A.[Division Type],A.[Clinic Template],b.[Clinic Notes]
,c.[Kezava Unique ID] LiveDetails,b.[Kezava Unique ID] HisDetails,'Remove' 'Status'
from weeknoday a left join His b on a.[Clinic Date]=b.[Clinic Date] and a.[Schedule Interval]=b.[Schedule Interval]  and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.[Clinic Start Time]=b.[Clinic Start Time] and isnull(a.[provider],'')=isnull(b.[provider],'')
                 left join Live c on a.[Clinic Date]=c.[Clinic Date] and a.[Schedule Interval]=c.[Schedule Interval] and a.[MDC Clinic Specialty]=c.[MDC Clinic Specialty] and a.[Clinic Start Time]=c.[Clinic Start Time] and isnull(a.[provider],'')=isnull(c.[provider],'') and isnull(b.[Kezava Unique ID],'')=isnull(c.[Kezava Unique ID],'') where isnull(b.[Kezava Unique ID],'')!='' and isnull(c.[Kezava Unique ID],'')=''
)


,
finaldata as
(
select distinct *,case when Status='Add' then CONCAT([Clinic Date],';',Status) when Status='Remove' then CONCAT([Clinic Date],';',Status) else CONCAT([Clinic Date],';',Status) end as final from dataset
)
select distinct * from finaldata



GO
