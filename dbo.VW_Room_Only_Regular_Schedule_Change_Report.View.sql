USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Only_Regular_Schedule_Change_Report]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Room_Only_Regular_Schedule_Change_Report]
as
with weeknoday as
(
selecT * from WeekNumber_Day w left join
 (select distinct a.[Room Only Schedule Provider],[Created On],a.[Schedule Updated On],[System Submitter Name] as[Created By],[Schedule Start Date]
 ,[Schedule End Date],[Schedule Type],[Clinic Schedule Notes],[Division Approval Comments] 
 from [2_50_Room Only Regular Schedule] a
 inner join
 (select [Room Only Schedule Provider], max([Schedule Updated On]) [Schedule Updated On] from  [2_50_Room Only Regular Schedule] group by [Room Only Schedule Provider]) b on  
 a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.[Schedule Updated On]=b.[Schedule Updated On] 
 ) p on 1=1 
),
---Due to Clinic Schedule change report Duplicate issue,Notes columns removed from report and added Schedule notes columun
live as
(
selecT a.[Room Only Schedule Provider],a.[System Submitter Name] as[Created By],a.[Schedule Updated On],[Schedule Start Date],[Schedule End Date],[Schedule Frequency] as [Schedule Type],[Clinic Schedule Notes],[Division Approval Comments],[Clinic Schedule Week],[Work Days] ,[Clinic Start Time],[Clinic End Time],
concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' To ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7),';','DEP:',a.[DEP Name],';','LOC:',a.Location,';', +case when isnull(a.Building,'')!='' then a.Building else a.Building end ,
case when isnull(a.[FLOOR],'')!='' then '>>'+a.[FLOOR] else a.[FLOOR] end ,
case when isnull(a.Wing,'')!='' then '>>'+a.Wing else a.Wing end ,
case when isnull(a.Suite,'')!='' then '>>'+a.Suite else a.Suite end ,
case when isnull( a.[Room Name] ,'')!='' then '>>'+ a.[Room Name]  else  a.[Room Name]  end,
case when isnull([Clinic Notes],'')!='' then ';Notes: '+[Clinic Notes] else '' end,';','Notification:',a.[Schedule Notification]) Detail
from [2_50_Room Only Regular Schedule] a  inner join
 (select [Room Only Schedule Provider], max([Schedule Updated On]) [Schedule Updated On] from  [2_50_Room Only Regular Schedule] group by [Room Only Schedule Provider]) b on  
 a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.[Schedule Updated On]=b.[Schedule Updated On] 
),
his as  
(
select a.[Room Only Schedule Provider],a.[System Submitter Name] as[Created By],a.[Schedule Updated On],a.[Schedule Start Date]
,a.[Schedule End Date],a.[Schedule Frequency] as [Schedule Type],a.[Clinic Schedule Notes],a.[Division Approval Comments]
,a.[Clinic Schedule Week],a.[Work Days],a.[Clinic Start Time],a.[Clinic End Time],
concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' To ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7),';','DEP:',a.[DEP Name],';','LOC:',a.Location,';', +case when isnull(a.Building,'')!='' then a.Building else a.Building end ,
case when isnull(a.[FLOOR],'')!='' then '>>'+a.[FLOOR] else a.[FLOOR] end ,
case when isnull(a.Wing,'')!='' then '>>'+a.Wing else a.Wing end ,
case when isnull(a.Suite,'')!='' then '>>'+a.Suite else a.Suite end ,
case when isnull( a.[Room Name] ,'')!='' then '>>'+ a.[Room Name]  else  a.[Room Name] end,
--case when isnull(a.[Clinic Notes],'')!='' then ';Notes: '+a.[Clinic Notes] else '' end,
';','Notification:',a.[Schedule Notification]) Detail
from Room_Only_Regular_Schedule_Before_Update a inner join [2_50_Room Only Regular Schedule] b on  
a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider]
--(select [Room Only Schedule Provider], max([Schedule Updated On]) [Schedule Updated On]
-- from  [Room_Only_Regular_Schedule] group by [Room Only Schedule Provider]) b on  
-- a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.[Schedule Updated On]=b.[Schedule Updated On] 
)
,
dataset as
(
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[Room Only Schedule Provider],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek,b.Detail LiveDetails ,c.Detail  HisDetails,'KezavaSchedule' 'Status',b.[Clinic Start Time]
from weeknoday a left join live b on a.dayoftheweek=b.[Work Days] and  a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.weekno=b.[Clinic Schedule Week]
                 inner join his c on a.dayoftheweek=c.[Work Days] and a.[Room Only Schedule Provider]=c.[Room Only Schedule Provider] and a.weekno=c.[Clinic Schedule Week]
                                                and isnull(b.detail,'')=isnull(c.detail,'')
union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[Room Only Schedule Provider],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek ,b.detail LiveDetails,c.detail HisDetails,'KezavaAdd' 'Status',b.[Clinic Start Time]
from weeknoday a left join live b on a.dayoftheweek=b.[Work Days] and  a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.weekno=b.[Clinic Schedule Week] 
                 left join his c  on a.dayoftheweek=c.[Work Days] and a.[Room Only Schedule Provider]=c.[Room Only Schedule Provider] and a.weekno=c.[Clinic Schedule Week]
                                               and isnull(b.detail,'')=isnull(c.detail,'') where  isnull(b.detail,'')!='' and isnull(c.detail,'')=''

union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.[Room Only Schedule Provider],A.[Schedule Start Date],A.[Schedule End Date],A.[Schedule Type],A.[Clinic Schedule Notes],A.[Division Approval Comments],a.weekno,a.dayoftheweek ,c.detail LiveDetails,b.detail HisDetails,'KezavaRemove' 'Status',b.[Clinic Start Time]
from weeknoday a left join His b on a.dayoftheweek=b.[Work Days] and  a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.weekno=b.[Clinic Schedule Week]
                 left join Live c on a.dayoftheweek=c.[Work Days] and a.[Room Only Schedule Provider]=c.[Room Only Schedule Provider]and a.weekno=c.[Clinic Schedule Week] 
                  and isnull(b.detail,'')=isnull(c.detail,'') where isnull(b.detail,'')!='' and isnull(c.detail,'')=''

),
finaldata as
(
select *,case when Status='KezavaAdd' then replace(CONCAT(LiveDetails,Status),';;','') when Status='KezavaRemove' then replace(CONCAT(HisDetails,Status),';;','') else replace(CONCAT(LiveDetails,Status),';;','') end as final,
row_number() over(partition by [Room Only Schedule Provider],[dayoftheweek],weekno order by weekno,[clinic start time]) rno from dataset
)


,
finaldataset1 as
(
select distinct g.[Created On],g.[Room Only Schedule Provider],g.[created by],g.[Schedule Updated On],g.[Schedule Start Date],g.[Schedule End Date],g.[Clinic Schedule Notes] as [Clinic Notes],g.[Clinic Schedule Notes],g.[Division Approval Comments],g.[Schedule Type],a.Weekno,a.Rowno
,case when isnull(b.Final,'') like'%Notification:No%' then '' else isnull(b.Final,'') end as Monday
,case when isnull(c.Final,'') like'%Notification:No%' then '' else isnull(c.Final,'') end as Tuesday
,case when isnull(d.Final,'') like'%Notification:No%' then '' else isnull(d.Final,'') end as Wednesday
,case when isnull(e.Final,'') like'%Notification:No%' then '' else isnull(e.Final,'') end as Thursday
,case when isnull(f.Final,'') like'%Notification:No%' then '' else isnull(f.Final,'') end as Friday
,case when isnull(h.Final,'') like'%Notification:No%' then '' else isnull(h.Final,'') end as Sunday
,case when isnull(i.Final,'') like'%Notification:No%' then '' else isnull(i.Final,'') end as Saturday
--,isnull(c.Final,'') Tuesday
--,isnull(d.Final,'') Wednesday
--,isnull(e.Final,'') Thursday
--,isnull(f.Final,'') Friday
--,isnull(h.Final,'') Sunday
--,isnull(i.Final,'') Saturday 
from weeknorowno a 
left join 
(
select  [Created On],[Room Only Schedule Provider],[created by],[Schedule Updated On],[Schedule Start Date]
,[Schedule End Date],[Clinic Schedule Notes][Clinic Notes],[Clinic Schedule Notes],[Division Approval Comments]
,[Schedule Type],weekno,DayoftheWeek,rno,final from finaldata
) g on a.Weekno=g.Weekno
left join finaldata b on a.Weekno=b.Weekno and a.Rowno=b.rno and b.dayoftheweek='Monday' and b.[Room Only Schedule Provider]=g.[Room Only Schedule Provider] 
left join finaldata c on a.Weekno=c.Weekno and a.Rowno=c.rno and c.dayoftheweek='Tuesday' and c.[Room Only Schedule Provider]=g.[Room Only Schedule Provider]  
left join finaldata d on a.Weekno=d.Weekno and a.Rowno=d.rno and d.dayoftheweek='Wednesday' and d.[Room Only Schedule Provider]=g.[Room Only Schedule Provider]  
left join finaldata e on a.Weekno=e.Weekno and a.Rowno=e.rno and e.dayoftheweek='Thursday' and e.[Room Only Schedule Provider]=g.[Room Only Schedule Provider]
left join finaldata f on a.Weekno=f.Weekno and a.Rowno=f.rno and f.dayoftheweek='Friday' and f.[Room Only Schedule Provider]=g.[Room Only Schedule Provider]  
left join finaldata h on a.Weekno=h.Weekno and a.Rowno=h.rno and h.dayoftheweek='Sunday' and h.[Room Only Schedule Provider]=g.[Room Only Schedule Provider]  
left join finaldata i on a.Weekno=i.Weekno and a.Rowno=i.rno and i.dayoftheweek='Saturday' and i.[Room Only Schedule Provider]=g.[Room Only Schedule Provider]  
)
select distinct *,(select Distinct [Division Name] from [Division_Detail])[Division Name] from finaldataset1 
where concat(Monday,Tuesday,Wednesday,Thursday,Friday,Sunday,Saturday)!=''


GO
