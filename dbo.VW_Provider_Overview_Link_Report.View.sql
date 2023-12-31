USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Overview_Link_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[VW_Provider_Overview_Link_Report]
AS
--Provider Report Link only for Provider Schedule
WITH 
[Clinic Count Hours]
AS
(SELECT distinct  Provider,Location,[Clinic Type],[Clinic Specialty],NULL [Linked Clinic Name],0 [Link Status],
Concat(Convert(Varchar(7),cast([Clinic Start Time] as time),100),' - ',Convert(Varchar(7),cast([Clinic End Time] as time),100) )[Clinic Time],[Clinic hours]  
,cast(ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))  as nvarchar(10)) AS [Schedule Weeks] ,case when datename(weekday,[clinic date]) ='Monday' then 'BZMonday'
when datename(weekday,[clinic date]) ='Tuesday' then 'CZTuesday'
when datename(weekday,[clinic date]) ='Wednesday' then 'DZWednesday'
when datename(weekday,[clinic date]) ='Thursday' then 'EZThursday'
when datename(weekday,[clinic date]) ='Friday' then 'FZFriday'
when datename(weekday,[clinic date]) ='Saturday' then 'GZSaturday'
when datename(weekday,[clinic date]) ='Sunday' then 'AZSunday' end [Days Of The Week] 
from  VW_Clinic_Schedule_and_Changes B WHERE ISNULL(B.[Stage], '') in ('Provider Schedule'--,'Regular Linked Clinic Schedule','Irregular Provider Schedule','Irregular Linked Schedule'
) and ISNULL(provider, '') != '' --and  provider='Hibner, Julie'
and [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year]) 
) 

, [Clinic Count Hours1] as (
select distinct Provider,Location,[Clinic Type],[Clinic Specialty],[Linked Clinic Name],[Clinic Time],[Clinic hours],[Days Of The Week],[Link Status],
Weeks=
STUFF((SELECT distinct ', ' +[Schedule Weeks] FROM [Clinic Count Hours] y where b.[Provider]=y.[Provider] and b.Location=y.Location and b.[Clinic Time]=y.[Clinic Time] --and b.[Schedule Updated On]=y.[Schedule Updated On] 
and b.[Link Status]=Y.[Link Status] and isnull(b.[linked Clinic Name],'')=isnull(y.[linked Clinic Name],'') and b.[Days Of The Week]=y.[Days Of The Week]  and b.[Clinic Specialty]=y.[Clinic Specialty] FOR XML PATH ('')), 1, 2,'')
from [Clinic Count Hours] b)
,[Clinic Count Hours2] as (
seleCT distinct  [Provider]
,Case when isnull(b.[Linked Clinic Name],'')='' then b.[Clinic Specialty] ELSE b.[Linked Clinic Name] End As [Clinic Specialty]
,[Linked Clinic Name]
,[Clinic Type]
,[Location]
,null [Schedule Period]
,[Clinic Time],[Clinic hours]
,Weeks [Schedule Weeks]
,[Days Of The Week]=
STUFF((SELECT distinct ', ' +[Days Of The Week] FROM [Clinic Count Hours1] y where b.[Provider]=y.[Provider] and b.Location=y.Location and b.[Clinic Time]=y.[Clinic Time] --and b.[Schedule Updated On]=y.[Schedule Updated On] 
and b.[Link Status]=Y.[Link Status] and isnull(b.[linked Clinic Name],'')=isnull(y.[linked Clinic Name],'') and b.Weeks=y.Weeks  and b.[Clinic Specialty]=y.[Clinic Specialty]  FOR XML PATH ('')), 1, 2,'')
   
,(selecT min([Clinic Date]) from   VW_Clinic_Schedule_and_Changes y WHERE ISNULL(y.[Stage], '') in ('Provider Schedule'--,'Regular Linked Clinic Schedule','Irregular Provider Schedule','Irregular Linked Schedule'
) and ISNULL(provider, '') != '' 
and [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
and 
b.[Provider]=y.[Provider] and b.Location=y.Location and b.[Clinic Time]=Concat(Convert(Varchar(7),cast(y.[Clinic Start Time] as time),100),' - ',Convert(Varchar(7),cast(y.[Clinic End Time] as time),100) ) --and b.[Schedule Updated On]=y.[Schedule Updated On] 
--and isnull(b.[linked Clinic Name],'')=isnull(y.[linked Clinic Name],'')
)  [MINDATE]
,(selecT max([Clinic Date]) from   VW_Clinic_Schedule_and_Changes y WHERE ISNULL(y.[Stage], '') in ('Provider Schedule'--,'Regular Linked Clinic Schedule','Irregular Provider Schedule','Irregular Linked Schedule'
) and ISNULL(provider, '') != '' 
and [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
and 
b.[Provider]=y.[Provider] and b.Location=y.Location and b.[Clinic Time]=Concat(Convert(Varchar(7),cast(y.[Clinic Start Time] as time),100),' - ',Convert(Varchar(7),cast(y.[Clinic End Time] as time),100) )-- and b.[Schedule Updated On]=y.[Schedule Updated On] 
--and isnull(b.[linked Clinic Name],'')=isnull(y.[linked Clinic Name],'') 
) [MAXDATE]  from [Clinic Count Hours1] b
)

seleCT [Provider]
,[Clinic Specialty]
,[Linked Clinic Name]
,[Clinic Type]
,[Location]
,CONCAT(CONVERT(VARCHAR(10),MINDATE,101),' - ',CONVERT(VARCHAR(10),MAXDATE,101)) [Schedule Period]
,[Clinic Time]
,[Schedule Weeks]
,[Days Of The Week]
, (selecT count([Clinic Date]) from VW_Clinic_Schedule_and_Changes y WHERE ISNULL(y.[Stage], '') in ('Provider Schedule'--,'Regular Linked Clinic Schedule','Irregular Provider Schedule','Irregular Linked Schedule'
) and ISNULL(provider, '') != '' 
and [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
and b.[Provider]=y.[Provider] and b.Location=y.Location and b.[Clinic Time]=Concat(Convert(Varchar(7),cast(y.[Clinic Start Time] as time),100),' - ',Convert(Varchar(7),cast(y.[Clinic End Time] as time),100) )
--and isnull(b.[linked Clinic Name],'')=isnull(y.[linked Clinic Name],'')
and CHARINDEX(cast(ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))  as nvarchar(10)),b.[Schedule Weeks])>0
and CHARINDEX(datename(weekday,[clinic date]),[Days Of The Week])>0 ) [No of Clinics]   
,(selecT count([Clinic Date]) from   VW_Clinic_Schedule_and_Changes y WHERE ISNULL(y.[Stage], '') 
in ('Provider Schedule'--,'Regular Linked Clinic Schedule','Irregular Provider Schedule','Irregular Linked Schedule'
) and ISNULL(provider, '') != '' 
and [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
and b.[Provider]=y.[Provider] and b.Location=y.Location and b.[Clinic Time]=Concat(Convert(Varchar(7),cast(y.[Clinic Start Time] as time),100),' - ',Convert(Varchar(7),cast(y.[Clinic End Time] as time),100) )
--and isnull(b.[linked Clinic Name],'')=isnull(y.[linked Clinic Name],'') 
and b.[Clinic Specialty]=y.[Clinic Specialty]
and CHARINDEX(cast(ceiling(cast(datepart(day,[Clinic Date])/7.00 as float))  as nvarchar(10)),b.[Schedule Weeks])>0 
and CHARINDEX(datename(weekday,[clinic date]),[Days Of The Week])>0)*[Clinic hours] as [Clinic hours]
,[MINDATE] ,[MAXDATE]  from [Clinic Count Hours2] b







GO
