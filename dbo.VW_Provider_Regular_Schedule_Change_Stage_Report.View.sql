USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Regular_Schedule_Change_Stage_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[VW_Provider_Regular_Schedule_Change_Stage_Report]
as 
with weeknoday as
(
selecT * from WeekNumber_Day w left join (select distinct provider,[Clinic Type],[Created On],[Schedule Updated On],[Created By],[Schedule Start Date],[Schedule End Date]
,[Schedule Type],[Clinic Schedule Notes] from Provider_Regular_Schedule
union
select distinct provider,[Clinic Type],[Created On],[Schedule Updated On],[Created By],[Schedule Start Date],[Schedule End Date]
,[Schedule Type],[Clinic Schedule Notes] from .[2_28_Provider Regular Schedule]  where isnull([Clinic Type],'')!=''


) p on 1=1 -- where provider='Jack, Alayna'
),

live as
(
selecT Provider,[created by],[Schedule Updated On],[Schedule Start Date],[Schedule End Date],[Schedule Type],[Clinic Schedule Notes],[Clinic Schedule Week],[Work Days] ,[Clinic Start Time],[Clinic End Time],concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic Start Time],100),8)),7),' to ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic End Time],100),8)),7),';',Location,';',[Clinic Type],' - ',[Clinic Specialty],';',case when isnull([Clinic Notes],'')!='' then 'Notes:'+[Clinic Notes] else '' end) Detail,[Employee Login ID]
from .[2_28_Provider Regular Schedule]   where isnull([Clinic Type],'')!='' --and provider='Jack, Alayna'
),
his as  
(
select a.Provider,[created by],a.[Schedule Updated On],[Schedule Start Date],[Schedule End Date],[Schedule Type],[Clinic Schedule Notes],a.[Clinic Schedule Week],a.[Work Days],[Clinic Start Time],[Clinic End Time],concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic Start Time],100),8)),7),' to ' 
,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,a.[Clinic End Time],100),8)),7),';',a.Location,';',a.[Clinic Type],' - ',a.[Clinic Specialty],';',case when isnull(a.[Clinic Notes],'')!='' then 'Notes:'+a.[Clinic Notes] else '' end) Detail,[Employee Login ID]
from Provider_Regular_Schedule a --where provider='Jack, Alayna'

--inner join (select Provider, max([Schedule Updated On]) [Schedule Updated On] from  .[2_28_Provider Regular Schedule] group by provider) b on a.Provider=b.Provider and a.[Schedule Updated On]=b.[Schedule Updated On] 

)
,
dataset as
(
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.Provider,A.[Clinic Type],A.[Schedule Start Date],A.[Schedule End Date]
,A.[Schedule Type],a.[Clinic Schedule Notes],a.weekno,a.dayoftheweek,b.Detail LiveDetails 
,c.Detail  HisDetails,'Schedule' 'Status',b.[Clinic Start Time]
from weeknoday a left join live b on a.dayoftheweek=b.[Work Days] and a.Provider=b.Provider and a.weekno=b.[Clinic Schedule Week]
                 inner join his c on a.dayoftheweek=c.[Work Days] and a.Provider=c.Provider and a.weekno=c.[Clinic Schedule Week] 
				 and isnull(b.detail,'')=isnull(c.detail,'')
union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.Provider,A.[Clinic Type],A.[Schedule Start Date],A.[Schedule End Date]
,A.[Schedule Type],a.[Clinic Schedule Notes],a.weekno,a.dayoftheweek ,b.detail LiveDetails,c.detail HisDetails,'Add' 'Status'
,b.[Clinic Start Time]
from weeknoday a left join live b on a.dayoftheweek=b.[Work Days] and a.Provider=b.Provider and a.weekno=b.[Clinic Schedule Week] 
                 left join his c on a.dayoftheweek=c.[Work Days] and a.Provider=c.Provider and a.weekno=c.[Clinic Schedule Week]
				  and isnull(b.detail,'')=isnull(c.detail,'') where  isnull(b.detail,'')!='' and isnull(c.detail,'')=''

union
seleCT A.[Created On],A.[Schedule Updated On],A.[Created By],a.Provider,A.[Clinic Type],A.[Schedule Start Date],A.[Schedule End Date]
,A.[Schedule Type],a.[Clinic Schedule Notes],a.weekno,a.dayoftheweek ,c.detail LiveDetails,b.detail HisDetails,'Remove' 'Status'
,b.[Clinic Start Time]
from weeknoday a left join His b on a.dayoftheweek=b.[Work Days] and a.Provider=b.Provider and a.weekno=b.[Clinic Schedule Week]
                 left join Live c on a.dayoftheweek=c.[Work Days] and a.Provider=c.Provider and a.weekno=c.[Clinic Schedule Week] 
				 and isnull(b.detail,'')=isnull(c.detail,'') where isnull(b.detail,'')!='' and isnull(c.detail,'')=''
) ,
finaldata as
(
select *,case when Status='Add' then CONCAT(LiveDetails,Status) when Status='Remove' then CONCAT(HisDetails,Status) else CONCAT(LiveDetails,Status) end as final,
case when Status='Add' then CONCAT(dayoftheweek,Status) when Status='Remove' then CONCAT(dayoftheweek,Status) else CONCAT(dayoftheweek,Status) end as [WorkDaysStatus],
row_number() over(partition by provider,[dayoftheweek],weekno order by weekno,[clinic start time]) rno from dataset
),
finaldataset1 as
(
select distinct g.[created on],g.Provider,g.[Clinic Type],g.[created by],g.[Schedule Updated On],g.[Schedule Start Date],g.[Schedule End Date]
,isnull(g.[Clinic Notes],'') [Clinic Notes],isnull(g.[Clinic Schedule Notes],'') [Clinic Schedule Notes] ,g.[Schedule Type],a.Weekno--,a.Rowno
--,isnull(b.Final,'') Monday,isnull(c.Final,'') Tuesday ,isnull(d.Final,'') Wednesday,isnull(e.Final,'') Thursday,isnull(f.Final,'') Friday,
,g.final,g.DayoftheWeek,g.[WorkDaysStatus] from weeknorowno a 
left join 
(
select  [created on],Provider,[Clinic Type],[created by],[Schedule Updated On],[Schedule Start Date],[Schedule End Date],[Clinic Schedule Notes][Clinic Notes]
,[Clinic Schedule Notes],[Schedule Type],weekno,DayoftheWeek,rno,final,[WorkDaysStatus] from finaldata
) g on a.Weekno=g.Weekno and a.Rowno=g.rno

)

--select distinct f.* ,w.DayOrder from finaldataset1 F left join WeekNumber_Day w on f.DayoftheWeek=w.DayoftheWeek where
-- concat(final,'')!=''
--and Provider in (selecT provider    from .[2_28_Provider Regular Schedule]) 
,
finalresultset as
(

select distinct f.[Provider],f.[Clinic Type],f.[created by],f.[Schedule Updated On],it.[Schedule Start Date],it.[Schedule End Date],f.[Clinic Notes]
      ,			f.[Clinic Schedule Notes],f.[Schedule Type],f.[Weekno],f.[final],f.[DayoftheWeek],f.[WorkDaysStatus],w.DayOrder 
	  from finaldataset1 F left join WeekNumber_Day w on f.DayoftheWeek=w.DayoftheWeek
							inner join 
							(
								selecT * from .[2_28_Provider Regular Schedule]
							)IT
							on f.provider=it.provider and f.[created on]=it.[created on]
							where concat(final,'')!=''


)
select a.* from finalresultset a inner join (select Provider, max([Schedule Updated On]) [Schedule Updated On] from finalresultset group by Provider)b on a.provider=b.provider and a.[Schedule Updated On]=b.[Schedule Updated On]







GO
