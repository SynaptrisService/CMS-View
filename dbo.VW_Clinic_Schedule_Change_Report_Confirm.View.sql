USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Schedule_Change_Report_Confirm]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Clinic_Schedule_Change_Report_Confirm] as
 
with weeknoday as
(
selecT * from WeekNumber_Day w left join (select distinct [clinic type],[Clinic Specialty],[Created On],[Schedule Updated On],[System Submitter Name] as[Created By],[Schedule Start Date],[Schedule End Date],[Schedule Type],[Clinic Schedule Notes],[Division Approval Comments] from Clinic_Regular_Schedule) p on 1=1 
),
---Due to Clinic Schedule change report Duplicate issue,Notes columns removed from report and added Schedule notes columun
live as
(
selecT [clinic type],[Clinic Specialty],[System Submitter Name] as[Created By],[Schedule Updated On],[Schedule Start Date],
[Schedule End Date],[Schedule Frequency] as [Schedule Type],[Clinic Schedule Notes],[Division Approval Comments]
,[Clinic Schedule Week],[Work Days] ,[Clinic Start Time],[Clinic End Time],
concat(a.[Clinic Type],' - ',a.[Clinic Specialty],';',RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' To ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7),';','MOD:',a.[Mode of Delivery],';','DEP:',a.[DEP Name],';','LOC:',a.Location,';', +case when isnull(a.Building,'')!='' then a.Building else a.Building end ,
case when isnull(a.[FLOOR],'')!='' then '>>'+a.[FLOOR] else a.[FLOOR] end ,
case when isnull(a.Wing,'')!='' then '>>'+a.Wing else a.Wing end ,
case when isnull(a.Suite,'')!='' then '>>'+a.Suite else a.Suite end ,
case when isnull( a.[Room Name] ,'')!='' then '>>'+ a.[Room Name] else '' end,
case when isnull(a.[Clinic Notes],'')!='' then ';Notes: '+a.[Clinic Notes] else '' end) Detail
from Clinic_Regular_Schedule a
),
his as  
(
select a.[clinic type],a.[Clinic Specialty],a.[System Submitter Name] as[Created By],a.[Schedule Updated On],a.[Schedule Start Date],
a.[Schedule End Date],a.[Schedule Frequency] as [Schedule Type],a.[Clinic Schedule Notes],a.[Division Approval Comments]
,a.[Clinic Schedule Week],a.[Work Days],a.[Clinic Start Time],a.[Clinic End Time],concat(a.[Clinic Type],' - ',a.[Clinic Specialty],';',RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' To ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7),';','MOD:',a.[Mode of Delivery],';','DEP:',a.[DEP Name],';','LOC:',a.Location,';', +case when isnull(a.Building,'')!='' then a.Building else a.Building end ,
case when isnull(a.[FLOOR],'')!='' then '>>'+a.[FLOOR] else a.[FLOOR] end ,
case when isnull(a.Wing,'')!='' then '>>'+a.Wing else a.Wing end ,
case when isnull(a.Suite,'')!='' then '>>'+a.Suite else a.Suite end ,
case when isnull( a.[Room Name] ,'')!='' then '>>'+ a.[Room Name] else '' end)
--,case when isnull(a.[Clinic Notes],'')!='' then ';Notes: '+a.[Clinic Notes] else '' end) 
Detail
from Clinic_Regular_Schedule_Before_Update a 
--inner join (select [clinic type],[Clinic Specialty], max([Schedule Updated On]) [Schedule Updated On] from  Clinic_Regular_Schedule_History group by [clinic type],[Clinic Specialty]) b on a.[Clinic Type]=b.[Clinic Type] 
-- and a.[Clinic Specialty]=b.[Clinic Specialty] and a.[Schedule Updated On]=b.[Schedule Updated On] 
inner join dbo.Clinic_Regular_Schedule b  on a.[Clinic Type]=b.[Clinic Type] 
 and a.[Clinic Specialty]=b.[Clinic Specialty]
-- and( a.[Schedule Start Date] between b.[Schedule Start Date] and b.[Schedule End Date]
--or a.[Schedule End Date] between b.[Schedule Start Date] and b.[Schedule End Date])

)
,
dataset as
(
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[clinic type],a.[Clinic Specialty],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek,b.Detail LiveDetails ,c.Detail  HisDetails,'KezavaSchedule' 'Status',b.[Clinic Start Time]
from weeknoday a left join live b on a.dayoftheweek=b.[Work Days] and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] and a.weekno=b.[Clinic Schedule Week]
                 inner join his c on a.dayoftheweek=c.[Work Days] and a.[Clinic Type]=c.[Clinic Type] and a.[Clinic Specialty]=c.[Clinic Specialty] and a.weekno=c.[Clinic Schedule Week]
				 and isnull(b.detail,'')=isnull(c.detail,'')
union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[clinic type],a.[Clinic Specialty],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek ,b.detail LiveDetails,c.detail HisDetails,'KezavaAdd' 'Status',b.[Clinic Start Time]
from weeknoday a left join live b on a.dayoftheweek=b.[Work Days] and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] and a.weekno=b.[Clinic Schedule Week] 
                 left join his c  on a.dayoftheweek=c.[Work Days] and a.[Clinic Type]=c.[Clinic Type] and a.[Clinic Specialty]=c.[Clinic Specialty] and a.weekno=c.[Clinic Schedule Week]
				 --and(b.[Schedule Start Date] between c.[Schedule Start Date] and c.[Schedule End Date]
				 --or b.[Schedule End Date] between c.[Schedule Start Date] and c.[Schedule End Date])
                 and isnull(b.detail,'')=isnull(c.detail,'') where  isnull(b.detail,'')!='' and isnull(c.detail,'')=''

union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[clinic type],a.[Clinic Specialty],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek ,c.detail LiveDetails,b.detail HisDetails,'KezavaRemove' 'Status',b.[Clinic Start Time]
from weeknoday a left join His b on a.dayoftheweek=b.[Work Days] and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] and a.weekno=b.[Clinic Schedule Week]
                 left join Live c on a.dayoftheweek=c.[Work Days] and a.[Clinic Type]=c.[Clinic Type] and a.[Clinic Specialty]=c.[Clinic Specialty]and a.weekno=c.[Clinic Schedule Week] 
				 --and (b.[Schedule Start Date] between c.[Schedule Start Date] and c.[Schedule End Date]
				 --or b.[Schedule End Date] between c.[Schedule Start Date] and c.[Schedule End Date])
                 and isnull(b.detail,'')=isnull(c.detail,'') where isnull(b.detail,'')!='' and isnull(c.detail,'')=''

),
finaldata as
(
select *,case when Status='KezavaAdd' then replace(CONCAT(LiveDetails,Status),';;','') when Status='KezavaRemove' then replace(CONCAT(HisDetails,Status),';;','') else replace(CONCAT(LiveDetails,Status),';;','') end as final,
row_number() over(partition by [clinic type],[Clinic Specialty],[dayoftheweek],weekno order by weekno,[clinic start time]) rno from dataset
)
,
finaldataset1 as
(
select distinct g.[Created On],g.[clinic type],g.[Clinic Specialty],g.[created by],g.[Schedule Updated On],g.[Schedule Start Date],g.[Schedule End Date],g.[Clinic Notes],g.[Clinic Schedule Notes],g.[Division Approval Comments],g.[Schedule Type],a.Weekno,a.Rowno
,isnull(b.Final,'') Monday,isnull(c.Final,'') Tuesday ,isnull(d.Final,'') Wednesday,isnull(e.Final,'') Thursday,isnull(f.Final,'') Friday,isnull(h.Final,'') Sunday,isnull(i.Final,'') Saturday from weeknorowno a 
left join 
(
select  [Created On],[clinic type],[Clinic Specialty],[created by],[Schedule Updated On],[Schedule Start Date],[Schedule End Date],[Clinic Schedule Notes][Clinic Notes],[Clinic Schedule Notes],[Division Approval Comments],[Schedule Type],weekno,DayoftheWeek,rno,final from finaldata
) g on a.Weekno=g.Weekno
left join finaldata b on a.Weekno=b.Weekno and a.Rowno=b.rno and b.dayoftheweek='Monday' and b.[Clinic Type]=g.[Clinic Type] and b.[Clinic Specialty]=g.[Clinic Specialty] 
left join finaldata c on a.Weekno=c.Weekno and a.Rowno=c.rno and c.dayoftheweek='Tuesday' and c.[Clinic Type]=g.[Clinic Type] and c.[Clinic Specialty]=g.[Clinic Specialty]  
left join finaldata d on a.Weekno=d.Weekno and a.Rowno=d.rno and d.dayoftheweek='Wednesday' and d.[Clinic Type]=g.[Clinic Type] and d.[Clinic Specialty]=g.[Clinic Specialty]  
left join finaldata e on a.Weekno=e.Weekno and a.Rowno=e.rno and e.dayoftheweek='Thursday' and e.[Clinic Type]=g.[Clinic Type] and e.[Clinic Specialty]=g.[Clinic Specialty]
left join finaldata f on a.Weekno=f.Weekno and a.Rowno=f.rno and f.dayoftheweek='Friday' and f.[Clinic Type]=g.[Clinic Type] and f.[Clinic Specialty]=g.[Clinic Specialty]  
left join finaldata h on a.Weekno=h.Weekno and a.Rowno=h.rno and h.dayoftheweek='Sunday' and h.[Clinic Type]=g.[Clinic Type] and h.[Clinic Specialty]=g.[Clinic Specialty]  
left join finaldata i on a.Weekno=i.Weekno and a.Rowno=i.rno and i.dayoftheweek='Saturday' and i.[Clinic Type]=g.[Clinic Type] and i.[Clinic Specialty]=g.[Clinic Specialty]  
)
select distinct * from finaldataset1 where concat(Monday,Tuesday,Wednesday,Thursday,Friday,Sunday,Saturday)!=''





GO
