
ALTER View [dbo].[VW_Assign_Provider_Clinic_Report]
As
with Assigndetail as
(
select [Created On],[Created By],[Clinic Start Date],[Clinic End Date],[Provider],a.[Clinic Type],a.[Clinic Specialty],[Location],a.[Clinic Date],a.[Clinic Start Time],a.[Clinic End Time],[Assign Start Time],[Assign End Time],[Clinic Notes],
concat(isnull([Provider],''),isnull(convert(varchar(8),CONVERT(date, a.[Clinic Date], 103),112),''),isnull(cast(cast([Assign Start Time] as time)as varchar(5)),''),isnull(cast(cast([Assign End Time] as time)as varchar(5)),'')) as [Detail]
from [Provider_Assigned_Clinics] a inner join [Assigned_Clinic_Date] b 
on a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time)
and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty]--where [Clinic Date] in(select [Clinic Date] from [Assigned_Clinic_Date])
)
,
Assigndetailhistory as
(
select a.* from 
(
select [Created On],isnull(a.[Schedule Updated On],[Record Modified On])[Schedule Updated On],[Created By],a.[Provider],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Date],a.[Clinic Start Time],a.[Clinic End Time],[Assign Start Time],[Assign End Time],[Clinic Notes],
concat(isnull(a.[Provider],''),isnull(convert(varchar(8),CONVERT(date, a.[Clinic Date], 103),112),''),isnull(cast(cast([Assign Start Time] as time)as varchar(5)),''),isnull(cast(cast([Assign End Time] as time)as varchar(5)),'')) as [Detail]
,dense_rank()over( partition by a.[clinic type],a.[Clinic Specialty], a.[clinic date],a.[assign start time],a.[assign end time]  
order by a.[clinic type],a.[Clinic Specialty], a.[clinic date],a.[Schedule Updated On]desc ,a.[Record Modified On] desc ) rno
from [Provider_Assigned_Clinics_History] a 
inner join (select [Clinic type],[Clinic Specialty],[Clinic Date],cast([Clinic Start Time] as time)[Clinic Start Time],
cast([Clinic End Time] as time)[Clinic End Time],max(isnull([Schedule Updated On],[Record Modified On])) [Schedule Updated On], provider
from [Provider_Assigned_Clinics_History] where isnull([Division Approval Comments],'')!='Not Required' 
--and [Clinic Date] in(select [Clinic Date] from [Assigned_Clinic_Date]) 
group by [clinic type],[Clinic Specialty],[Clinic Date],cast([Clinic Start Time] as time),
cast([Clinic End Time] as time),provider )b on a.[Clinic Type]=b.[Clinic Type] 
and a.[Clinic Specialty]=b.[Clinic Specialty] and isnull(a.[Schedule Updated On],[Record Modified On])=isnull(b.[Schedule Updated On],[Record Modified On]) 
and a.[Clinic Date]=b.[Clinic Date] and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time)
and a.provider=b.provider

where isnull([Division Approval Comments],'')!='Not Required'
)a inner join [Assigned_Clinic_Date] b on a.[Clinic Date]=b.[Clinic Date] 
and cast(a.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
and cast(a.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time)
and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty]
where a.rno=1
)
,
Dataset as
(
select a.[Created On],b.[Schedule Updated On],a.[Created By],a.[Provider],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Date],cast(a.[Clinic Start Time] as time)[Clinic Start Time],cast(a.[Clinic End Time] as time)[Clinic End Time],
a.[Assign Start Time],a.[Assign End Time],a.[Clinic Notes],a.Detail as Livedetail,b.Detail Hisdetail,'KezavaSchedule' as 'Status'
from Assigndetail a inner join Assigndetailhistory b on a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] 
and isnull(a.detail,'')=isnull(b.detail,'') 
Union
select a.[Created On],b.[Schedule Updated On],a.[Created By],a.[Provider],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Date],cast(a.[Clinic Start Time] as time),cast(a.[Clinic End Time] as time),
a.[Assign Start Time],a.[Assign End Time],a.[Clinic Notes],a.Detail as Livedetail,b.Detail Hisdetail,'KezavaAdd' as 'Status'
from Assigndetail a left join Assigndetailhistory b on a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] 
and isnull(a.detail,'')=isnull(b.detail,'') where  isnull(a.detail,'')!='' and isnull(b.detail,'')=''
Union
select a.[Created On],a.[Schedule Updated On],a.[Created By],a.[Provider],a.[Clinic Type],a.[Clinic Specialty],a.[Location],a.[Clinic Date],cast(a.[Clinic Start Time] as time),cast(a.[Clinic End Time] as time),
a.[Assign Start Time],a.[Assign End Time],a.[Clinic Notes],b.Detail as Livedetail,a.Detail Hisdetail,'KezavaRemove' as 'Status'
from Assigndetailhistory a Left join Assigndetail b on a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty] 
and isnull(a.detail,'')=isnull(b.detail,'') where isnull(a.detail,'')!='' and isnull(b.detail,'')=''
)
select 
(select top 1 [Created On] from Provider_Assigned_Clinics a where a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Date]=b.[Clinic Date] 
and a.[Clinic Specialty]=b.[Clinic Specialty] 
AND cast(A.[Clinic Start Time] as time)=cast(b.[Clinic Start Time] as time)
AND cast(A.[Clinic End Time] as time)=cast(b.[Clinic End Time] as time)
) [Created On]
,[Schedule Updated On],[Created By],[Assign Start Time],[Assign End Time],cast([Clinic Start Time] as datetime)[Clinic Start Time],cast([Clinic End Time] as datetime)[Clinic End Time]
,concat([Provider],[Status])[Provider],[Clinic Type],[Clinic Specialty],[Location],concat([Location],[Status])[Location_Display],format([Clinic Date],'MM/dd/yyyy')[Clinic Date]
,concat(replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic Start Time],100),8),'AM',' AM'),'PM',' PM'),' To ',replace(replace(RIGHT(Convert(VARCHAR(20),[Clinic End Time],100),8),'AM',' AM'),'PM',' PM'),[Status])[Clinic Scheduled Time]
,concat(replace(replace(RIGHT(Convert(VARCHAR(20),[Assign Start Time],100),8),'AM',' AM'),'PM',' PM'),' To ',replace(replace(RIGHT(Convert(VARCHAR(20),[Assign End Time],100),8),'AM',' AM'),'PM',' PM'),[Status])[Provider Assigned Time]
,concat([Clinic Notes],[Status])[Clinic Notes]
,concat(format([Clinic Date],'MM/dd/yyyy'),[Status])[Org Clinic Date],concat(datename(dw,[Clinic Date]),[Status])[Work Days]
from Dataset  b --where [Clinic Date] in(select [Clinic Date] from [Assigned_Clinic_Date])
GO


