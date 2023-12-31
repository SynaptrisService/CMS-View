USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_MDC_Regular_Schedule_Change_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_MDC_Regular_Schedule_Change_Report]
as
with WeekNoDay as
(
selecT * from WeekNumber_Day w left join 
	(select distinct a.provider,a.[MDC Host Division Name], a.location,a.[Clinic Type],a.[Clinic Specialty],a.[MDC Clinic Specialty],a.[Created On],a.[Schedule Updated On],
	a.[Created By],a.[Schedule Start Date], a.[Schedule End Date],a.[Schedule Frequency] as [Schedule Type],a.[Clinic Schedule Notes],a.[Division Name],a.[Division Notification]
	,a.[Division Type],a.[Clinic Template],A.[Division Approval Comments] from .dbo.[2_38_MDC Regular Schedule] a 
	Inner join
	(select [Clinic Type],[MDC Clinic Specialty],max([Schedule Updated On]) [Schedule Updated On] 
	from  .dbo.[2_38_MDC Regular Schedule] group by [Clinic Type],[MDC Clinic Specialty]) b 
	on a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.[Schedule Updated On]=b.[Schedule Updated On]
	)p on 1=1 
),
Schedule as
(
select isnull(a.provider,'') as Provider,a.[MDC Host Division Name],a.[Clinic Type],a.Location,a.[MDC Clinic Specialty],a.[Created On], a.[Schedule Updated On]
,a.[Created By], a.[Schedule Start Date],a.[Schedule End Date],a.[Schedule Frequency] as [Schedule Type],ISNULL(a.[Clinic Schedule Notes],'') AS [Clinic Schedule Notes], ISNULL(a.[Clinic Notes],'') AS [Notes to Scheduling Center],a.[Division Name],a.[Division Notification],
a.[Division Type],a.[Clinic Template],a.[Clinic Schedule Week],a.[Work Days],a.[Clinic Start Time],a.[Clinic End Time],'New' as [Record Status],
concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' To ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7),';','MOD:',a.[Mode of Delivery],';','DEP:',a.[DEP Name],';','LOC:',a.Location,';',a.Building,';',a.[FLOOR],';',a.Wing,';',a.Suite,';',a.[Room Number],';',a.[Division Name],':',case when a.[Clinic Template]='Provider' then a.provider else isnull(a.[Clinic Template],'Clinic') end,';') Detail,
concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' To ' ,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7)) as [Schedule Time],A.[Division Approval Comments]
from .dbo.[2_38_MDC Regular Schedule] A Inner join
(select [Clinic Type],[MDC Clinic Specialty],max([Schedule Updated On]) [Schedule Updated On] 
from  .dbo.[2_38_MDC Regular Schedule] group by [Clinic Type],[MDC Clinic Specialty]) b 
on a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.[Schedule Updated On]=b.[Schedule Updated On]
),
History
as
(
select a.[Clinic Type],a.[MDC Clinic Specialty],Provider,a.[MDC Host Division Name],Location,[Schedule Frequency] as [Schedule Type],[Schedule Start Date],[Schedule End Date],[Clinic Start Time],[Clinic End Time],
[Clinic Schedule Week],[Work Days],ISNULL([Clinic Schedule Notes],'') AS [Clinic Schedule Notes], ISNULL([Clinic Notes],'') AS  [Notes to Scheduling Center],a.[Division Name],[Division Type],[Division Notification],
a.[Schedule Updated On],'History' as [Record Status],concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic Start Time],100),8)),7),' To ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic End Time],100),8)),7),';','MOD:',[Mode of Delivery],';','DEP:',[DEP Name],';','LOC:',Location,';',Building,';',[FLOOR],';',Wing,';',Suite,';',[Room Number],';',a.[Division Name],': ',
case when [Clinic Template]='Provider' then provider else isnull([Clinic Template],'Clinic') end,';') Detail,
concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' To ' ,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7)) as [HSchedule Time],A.[Division Approval Comments]
from MDC_Regular_Schedule a Inner join
(select [Clinic Type],[MDC Clinic Specialty],max([Schedule Updated On]) [Schedule Updated On] 
from  MDC_Regular_Schedule group by [Clinic Type],[MDC Clinic Specialty]) b 
on a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.[Schedule Updated On]=b.[Schedule Updated On]
),
dataset as
(
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[MDC Host Division Name],a.[clinic type],a.[MDC Clinic Specialty],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek,b.Detail LiveDetails ,c.Detail  HistoryDetails,'KezavaSchedule' 'Status',b.[Clinic Start Time]
from weeknoday a left join Schedule b on a.dayoftheweek=b.[Work Days] and a.[Clinic Type]=b.[Clinic Type] and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.weekno=b.[Clinic Schedule Week]
                 inner join History c on a.dayoftheweek=c.[Work Days] and a.[Clinic Type]=c.[Clinic Type] and a.[MDC Clinic Specialty]=c.[MDC Clinic Specialty] and a.weekno=c.[Clinic Schedule Week]
                                                and isnull(b.detail,'')=isnull(c.detail,'')
union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[MDC Host Division Name],a.[clinic type],a.[MDC Clinic Specialty],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek ,b.detail LiveDetails,c.detail HistoryDetails,'KezavaAdd' 'Status',b.[Clinic Start Time]
from weeknoday a left join Schedule b on a.dayoftheweek=b.[Work Days] and a.[Clinic Type]=b.[Clinic Type] and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.weekno=b.[Clinic Schedule Week] 
                 left join History c  on a.dayoftheweek=c.[Work Days] and a.[Clinic Type]=c.[Clinic Type] and a.[MDC Clinic Specialty]=c.[MDC Clinic Specialty] and a.weekno=c.[Clinic Schedule Week]
                                               and isnull(b.detail,'')=isnull(c.detail,'') where  isnull(b.detail,'')!='' and isnull(c.detail,'')=''

union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[MDC Host Division Name],a.[clinic type],a.[MDC Clinic Specialty],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek ,c.detail LiveDetails,b.detail HistoryDetails,'KezavaRemove' 'Status',b.[Clinic Start Time]
from weeknoday a left join History b on a.dayoftheweek=b.[Work Days] and a.[Clinic Type]=b.[Clinic Type] and a.[MDC Clinic Specialty]=b.[MDC Clinic Specialty] and a.weekno=b.[Clinic Schedule Week]
                 left join Schedule c on a.dayoftheweek=c.[Work Days] and a.[Clinic Type]=c.[Clinic Type] and a.[MDC Clinic Specialty]=c.[MDC Clinic Specialty]and a.weekno=c.[Clinic Schedule Week] 
                  and isnull(b.detail,'')=isnull(c.detail,'') where isnull(b.detail,'')!='' and isnull(c.detail,'')=''

)

,
finaldata as
(
select *,case when Status='KezavaAdd' then replace(CONCAT(LiveDetails,Status),';;','') when Status='KezavaRemove' then replace(CONCAT(HistoryDetails,Status),';;','') else replace(CONCAT(LiveDetails,Status),';;','')  end as final,
row_number() over(partition by [clinic type],[MDC Clinic Specialty],[dayoftheweek],weekno order by weekno,[clinic start time]) Rowno from dataset
)


,
finaldataset1 as
(
select distinct g.[Created On],g.[MDC Host Division Name],g.[clinic type],g.[MDC Clinic Specialty],g.[created by],g.[Schedule Updated On],g.[Schedule Start Date],g.[Schedule End Date],g.[Clinic Notes],g.[Clinic Schedule Notes],g.[Division Approval Comments],g.[Schedule Type],a.Weekno,a.Rowno
,isnull(b.Final,'') Monday,isnull(c.Final,'') Tuesday ,isnull(d.Final,'') Wednesday,isnull(e.Final,'') Thursday,isnull(f.Final,'') Friday,isnull(h.Final,'') Sunday,isnull(i.Final,'') Saturday from weeknorowno a 
left join 
(
select  [Created On],[clinic type],[MDC Host Division Name],[MDC Clinic Specialty],[created by],[Schedule Updated On],[Schedule Start Date],[Schedule End Date],[Clinic Schedule Notes][Clinic Notes],[Clinic Schedule Notes],[Division Approval Comments],[Schedule Type],weekno,DayoftheWeek,Rowno,final from finaldata
) g on a.Weekno=g.Weekno
left join finaldata b on a.Weekno=b.Weekno and a.Rowno=b.Rowno and b.dayoftheweek='Monday' and b.[Clinic Type]=g.[Clinic Type] and b.[MDC Clinic Specialty]=g.[MDC Clinic Specialty] 
left join finaldata c on a.Weekno=c.Weekno and a.Rowno=c.Rowno and c.dayoftheweek='Tuesday' and c.[Clinic Type]=g.[Clinic Type] and c.[MDC Clinic Specialty]=g.[MDC Clinic Specialty]  
left join finaldata d on a.Weekno=d.Weekno and a.Rowno=d.Rowno and d.dayoftheweek='Wednesday' and d.[Clinic Type]=g.[Clinic Type] and d.[MDC Clinic Specialty]=g.[MDC Clinic Specialty]  
left join finaldata e on a.Weekno=e.Weekno and a.Rowno=e.Rowno and e.dayoftheweek='Thursday' and e.[Clinic Type]=g.[Clinic Type] and e.[MDC Clinic Specialty]=g.[MDC Clinic Specialty]
left join finaldata f on a.Weekno=f.Weekno and a.Rowno=f.Rowno and f.dayoftheweek='Friday' and f.[Clinic Type]=g.[Clinic Type] and f.[MDC Clinic Specialty]=g.[MDC Clinic Specialty]  
left join finaldata h on a.Weekno=h.Weekno and a.Rowno=h.Rowno and h.dayoftheweek='Sunday' and h.[Clinic Type]=g.[Clinic Type] and h.[MDC Clinic Specialty]=g.[MDC Clinic Specialty]  
left join finaldata i on a.Weekno=i.Weekno and a.Rowno=i.Rowno and i.dayoftheweek='Saturday' and i.[Clinic Type]=g.[Clinic Type] and i.[MDC Clinic Specialty]=g.[MDC Clinic Specialty]  
)
select distinct * from finaldataset1 where concat(Monday,Tuesday,Wednesday,Thursday,Friday,Sunday,Saturday)!=''



GO
