USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Overview_Report_Expected]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW  [dbo].[VW_Provider_Overview_Report_Expected]
AS 
----1.Provider Regular and Irrgular Schedule   (As requestd by Murali, we have added Assign Provider To Clinic records to Schedule)
WITH ScheduleHrs
AS 
(
SELECT Provider ,SUM(isnull([Clinic Hours],0)) [Schedule Hours]
FROM [VW_Clinic_Schedule_and_Changes]
WHERE ISNULL([Stage], '') IN ('Provider Schedule', 'Assign Provider To Clinic') AND ISNULL(provider, '') != ''
AND [clinic date] NOT IN (SELECT [holiday date]	FROM [ERD_Enterprise_Holiday_List]) gROUP BY provider
),
Expected
AS 
(
SELECT DISTINCT [Full Name] Provider ,isnull(round(SUM([Contracted Hours]) over(PARTITION by [Full Name] order by [Full Name]),0),0)  [Expected Hours],'Yes' [Define Contracted Hours],
isnull(count([Full Name]) over(PARTITION by [Employee Type] order by [Employee Type]),0) [Bar Graph Count] 
FROM Employee_Master a 
Left join  (select distinct provider from [VW_Clinic_Schedule_and_Changes]) b
 on a.[Full Name]=b.provider where [Employee Status]='Active' and isnull([User Authentication],'No')='Yes'
 AND [employee type] ='Provider' and isnull([Contracted Hours],0)>0
),
----2.Provider:Add+AssignProviderClinic-(Cancel+Limit)
ScheduleChangeHrs
AS 
(
select provider,isnull(sum([Schedule Change Hours]),0) [Schedule Change Hours]
from (SELECT Provider,	case when [Stage] in ('Cancel Provider Hours','Cancel') then SUM([Clinic Hours])*-1 else  SUM([Clinic Hours]) end [Schedule Change Hours]	
FROM [VW_Clinic_Schedule_and_Changes] 
WHERE ISNULL([Stage], '') IN ('Add', 'Self Reported','Cancel Provider Hours','Cancel')
AND ISNULL(provider, '') != ''	AND [clinic date] NOT IN (SELECT [holiday date]	FROM [ERD_Enterprise_Holiday_List])GROUP BY provider,stage )z
group by provider
),
----3.Count of Cancel-Add-limit and Patient displaced
CountsofScheduleChanges
AS 
(select a.provider, isnull(sum([Cancel]),0)  [Cancel], isnull(sum([Cancellations Less than 8 Weeks]),0) [Cancellations Less than 8 Weeks], isnull(sum([Total Displaced Patients]),0) [Total Displaced Patients],isnull(sum([Displaced Patients Less than 8 Weeks]),0) [Displaced Patients Less than 8 Weeks],
isnull(sum([Cancel Displaced Less than 8 Weeks]),0) [Cancel Displaced Less than 8 Weeks], isnull(sum([Add Less than 8 Weeks]),0) [Add Less than 8 Weeks], isnull(sum([Add Displaced Less than 8 Weeks]),0) [Add Displaced Less than 8 Weeks]
,isnull(sum([Limit Less than 8 Weeks]),0)[Limit Less than 8 Weeks], isnull(sum([Limit Displaced Less than 8 Weeks]),0) [Limit Displaced Less than 8 Weeks],	isnull(sum([Add Total]),0)[Add Total]
,isnull(sum([Limit Total]),0) [Limit Total],isnull(sum([Cancel Surgery Total]),0) [Cancel Surgery Total],isnull(sum([Surgery Cancellations Less than 8 Weeks]),0) [Surgery Cancellations Less than 8 Weeks]
,isnull(sum([Limit Surgery Total]),0) [Limit Surgery Total],isnull(sum([Surgery Limit Less than 8 weeks]),0) [Surgery Limit Less than 8 weeks]
from (
select provider ,[request notice period in weeks],stage
,sum([No of Appointments Scheduled])  [Total Displaced Patients]
,case when  [request notice period in weeks]<8 then sum([No of Appointments Scheduled]) else 0 end [Displaced Patients Less than 8 Weeks]
,case when stage='Cancel' and [Reason For Cancellation]!='Surgery' then  sum([Clinic Hours])else 0 end  [Cancel]
,case when stage in('Add','Self Reported') then  round(sum([Clinic Hours]),0) else 0 end  [Add Total]
,case when stage='Cancel Provider Hours' and [Reason For Cancellation]!='Surgery' then sum([Clinic Hours]) else 0 end  [Limit Total]
,case when stage='Cancel' and [Reason For Cancellation]='Surgery' then  sum([Clinic Hours]) else 0 end  [Cancel Surgery Total]
,case when stage='Cancel' and [Reason For Cancellation]='Surgery' and [request notice period in weeks]<8  then  sum([Clinic Hours]) else 0 end  [Surgery Cancellations Less than 8 Weeks]
,case when stage='Cancel Provider Hours' and [Reason For Cancellation]='Surgery' then  sum([Clinic Hours]) else 0 end  [Limit Surgery Total]
,case when stage='Cancel Provider Hours' and [Reason For Cancellation]='Surgery' and  [request notice period in weeks]<8 then  sum([Clinic Hours]) else 0 end  [Surgery Limit Less than 8 weeks]
,case when stage='Cancel' and [Reason For Cancellation]!='Surgery' and [request notice period in weeks]<8 then  sum([Clinic Hours]) else 0 end 'Cancellations Less than 8 Weeks' 
,case when  stage='Cancel' and [request notice period in weeks]<8 then  sum([No of Appointments Scheduled]) else 0 end 'Cancel Displaced Less than 8 Weeks'
,case when stage in('Add','Self Reported') and  [request notice period in weeks]<8 then  round(sum([Clinic Hours]),0) else 0 end 'Add Less than 8 Weeks' 
,case when  stage in('Add','Self Reported') and [request notice period in weeks]<8 then  sum([No of Appointments Scheduled]) else 0 end 'Add Displaced Less than 8 Weeks'
,case when stage='Cancel Provider Hours' and [Reason For Cancellation]!='Surgery' and  [request notice period in weeks]<8 then  sum([Clinic Hours]) else 0 end 'Limit Less than 8 Weeks' 
,case when  stage='Cancel Provider Hours' and [request notice period in weeks]<8 then  sum([No of Appointments Scheduled]) else 0 end 'Limit Displaced Less than 8 Weeks'
FROM [dbo].[VW_Clinic_Schedule_and_Changes]  where
stage in ('Cancel','Add','Self Reported','Cancel Provider Hours') and isnull(provider,'')!=''
and [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [dbo].[VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [dbo].[VW_Financial_Year])
and [clinic date] not in (select [holiday date] from [ERD_Enterprise_Holiday_List]) group by  [request notice period in weeks] ,provider,[No of Appointments Scheduled],stage,[Reason For Cancellation]
) a group by a.provider),
----4.Provider Schedule summary Report
Provider_Schedule
as
(
select a.provider,round(sum([Regular Schedule Hours]),0)[Regular Schedule Hours],round(sum([Assign Provider To Clinic]),0) [Assign Provider To Clinic],round(sum([Irregular Schedule Hours]),0) [Irregular Schedule Hours]
,round(sum([Self Reported]),0) [Self Reported],round(sum([Limit Schedules]),0)[Limit Schedules],round(sum([Add Clinic]),0)[Add Clinic],round(sum([Cancel Clinic]),0) [Cancel Clinic]
from (
select provider,stage
,case when ISNULL([Stage], '') in ('Provider Schedule') then  sum([Clinic Hours]) else 0 end 'Regular Schedule Hours' 
,case when stage='Assign Provider To Clinic' then  sum([Clinic Hours]) else 0 end 'Assign Provider To Clinic' 
,case when stage='Irregular Provider Schedule' then  sum([Clinic Hours]) else 0 end 'Irregular Schedule Hours'
,case when stage='Self Reported' then  sum([Clinic Hours]) else 0 end 'Self Reported'
--,case when  stage='Cancel Provider Hours'  then sum([Clinic Hours]) else 0 end 'Cancel Provider Hours'
,case when stage='Limit Provider Schedule'  then  count([Clinic Hours]) else 0 end 'Limit Schedules'
,case when stage in('Add','Self Reported') then sum([Clinic Hours]) else 0 end 'Add Clinic'
,case when stage='Cancel' then  sum([Clinic Hours]) else 0 end 'Cancel Clinic'
FROM [dbo].[VW_Clinic_Schedule_and_Changes]  where isnull(provider,'')!='' and
[clinic date] not in (select [holiday date] from [ERD_Enterprise_Holiday_List]) group by  [request notice period in weeks] ,provider,[No of Appointments Scheduled],stage
) a group by a.provider
),
[Cancel Provider Hours]
AS
(
 selecT Provider,[Originating Process],Round(sum(isnull([Cancel Provider Hours],0)),0) [Cancel Provider Hours], Round(sum(isnull([Cancel Provider Hours 8 Weeks],0)),0)[Cancel Provider Hours 8 Weeks] 
  from (select Provider,[Originating Process],
	case when [Originating Process]='Cancel Provider Hours' then sum([Clinic Hours]) else 0 end 'Cancel Provider Hours',
	case when  [request notice period in weeks]<8 then  sum([Clinic Hours]) else 0 end 'Cancel Provider Hours 8 Weeks'   
	 from 
	(
	select provider,[Originating Process],casT((DATEDIFF(MINUTE,[Cancel Start Time],[Cancel End Time])) as float)/60  [Clinic Hours] ,[request notice period in weeks]
	FROM [dbo].[Shorten_Provider_Clinic]  where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [dbo].[VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [dbo].[VW_Financial_Year])
	and [clinic date] not in (select [holiday date] from [ERD_Enterprise_Holiday_List]) 
	)a Group by provider,[Originating Process],[request notice period in weeks]) s
	group by Provider,[Originating Process]
),
Off_Schedule_Hrs
as
(
select Provider,Round(SUM([Off Schedule Hours])/60,0)  [Off Schedule Adds] 
 from VW_Patient_Appointment_Data where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [VW_Financial_Year]) 
 and (SELECT TOP 1 [end DATE] FROM [VW_Financial_Year])
 and Stage ='Off Schedule' GROUP BY Provider
)
----Final Select 
select ex.Provider
,isnull(ex.[Expected Hours],0) [Expected Hours] 
,round(isnull(SH.[Schedule Hours],0),0) [Schedule Hours],isnull(SH.[Schedule Hours]*14/100,0) [Allowable Cancel Percent]
,isnull(SH.[Schedule Hours]*14/100 + (SH.[Schedule Hours]*14/100)*10/100,0) [Allowable Cancel Limit]
,(isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)-isnull(SH.[Schedule Hours]*14/100,0)-isnull(SH.[Schedule Hours]*14/100+(SH.[Schedule Hours]*14/100)*10/100,0)) [More Than Cancel Limit]
,round(isnull(isnull(SH.[Schedule Hours],0)+isnull(SCH.[Schedule Change Hours],0),0),0) [Actual],
isnull(ROUND(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0)-ISNULL(SH.[Schedule Hours], 0) ,0),0) Different, 
round((case when isnull(ex.[Expected Hours],0)=0 then 0 else  isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)/isnull(ex.[Expected Hours],0)*100 end ),0) Percentage
,(case when isnull(ex.[Expected Hours],0)=0 then 0 else  isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)/isnull(ex.[Expected Hours],0)*100 end ) ProvPercentage
--case when isnull(SH.[Schedule Hours],0)=0 then 0 else round( isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)/isnull(sh.[Schedule Hours],0)*100,0)  end Percentage
,Case when casT(case when isnull(ex.[Expected Hours],0)=0 then 0 else  isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)/isnull(ex.[Expected Hours],0)*100  end as int) >=86 then 'No' Else 'Yes' End [Show Status]  
,Case WHEN ex.[Bar Graph Count] >='5' then 'Yes' ELSE 'No' End as [Show Bar Graph Status]
,CASE WHEN ISNULL(SH.[Schedule Hours], 0) < ISNULL(SCH.[Schedule Change Hours], 0) THEN 'Shortage' ELSE 'Excess' END 'ExcessShortage'
,CASE WHEN ROUND(ISNULL(SH.[Schedule Hours],0) - ISNULL(SCH.[Schedule Change Hours],0),0) >= 0 THEN 'At or Above Expected'
WHEN ROUND(ISNULL(SH.[Schedule Hours],0) - ISNULL(SCH.[Schedule Change Hours],0),0) BETWEEN -15 AND -1 THEN 'Shortage less than 16 Hours'
WHEN ROUND(ISNULL(SH.[Schedule Hours],0) - ISNULL(SCH.[Schedule Change Hours],0),0) <= -16 THEN 'Shortage greater than or equal 16 Hours 'END Hourstaus
,round(isnull([Cancel],0),0) [Cancel],  isnull([Cancellations Less than 8 Weeks],0) [Cancellations Less than 8 Weeks],Isnull([Cancel Surgery Total],0)[Cancel Surgery Total],isnull([Surgery Cancellations Less than 8 Weeks],0)[Surgery Cancellations Less than 8 Weeks]
,case when (isnull([Cancellations Less than 8 Weeks],0)!=0 and isnull([Cancel],0)!=0) then round((isnull([Cancellations Less than 8 Weeks],0)/(isnull([Cancel],0))*100),2,0) else 0 end  [Cancel Percentage] 
,case when (isnull([Surgery Cancellations Less than 8 Weeks],0)!=0 and isnull([Cancel Surgery Total],0)!=0) then round((isnull([Surgery Cancellations Less than 8 Weeks],0)/(isnull([Cancel Surgery Total],0))*100),2,0) else 0 end  [Surgery Cancel Percentage] 
,isnull([Total Displaced Patients],0) [Total Displaced Patients],round(isnull([Displaced Patients Less than 8 Weeks],0),0) [Displaced Patients Less than 8 Weeks]
,Case when isnull([Total Displaced Patients],0)!='0' then  isnull([Displaced Patients Less than 8 Weeks],0)*100/isnull([Total Displaced Patients],0) else 0 end [Total Displaced Patients Percentage]
,isnull([Cancel Displaced Less than 8 Weeks],0) [Cancel Displaced Less than 8 Weeks],isnull([Add Total],0) [Add Total] ,isnull([Add Less than 8 Weeks],0) [Add Less than 8 Weeks]
,case when (isnull([Add Less than 8 Weeks],0)!=0 and isnull([Add Total],0)!=0) then  round((isnull([Add Less than 8 Weeks],0)/(isnull([Add Total],0))*100),2,0) else 0 end [Add Percentage]
,isnull([Add Displaced Less than 8 Weeks],0) [Add Displaced Less than 8 Weeks]
--,isnull([Cancel Provider Hours],0) [Limit Total],isnull([Cancel Provider Hours 8 Weeks],0) [Limit Less than 8 Weeks],isnull([Limit Surgery Total],0) [Limit Surgery Total] ,isnull([Surgery Limit Less than 8 weeks],0) [Surgery Limit Less than 8 weeks]
--,case when (isnull([Cancel Provider Hours 8 Weeks],0)!=0 and isnull([Cancel Provider Hours],0)!=0) then round((isnull([Cancel Provider Hours 8 Weeks],0)/(isnull([Cancel Provider Hours],0))*100),2,0) else 0 end [Limit Percentage]
,round(isnull([Limit Total],0),0) [Limit Total],isnull([Limit Less than 8 Weeks],0) [Limit Less than 8 Weeks]
,isnull([Limit Surgery Total],0) [Limit Surgery Total] ,isnull([Surgery Limit Less than 8 weeks],0) [Surgery Limit Less than 8 weeks]
,case when (isnull([Limit Less than 8 Weeks],0)!=0 and isnull([Limit Total],0)!=0) then round((isnull([Limit Less than 8 Weeks],0)/(isnull([Limit Total],0))*100),2,0) else 0 end [Limit Percentage]
,case when (isnull([Surgery Limit Less than 8 weeks],0)!=0 and isnull([Limit Surgery Total],0)!=0) then round((isnull([Surgery Limit Less than 8 weeks],0)/(isnull([Limit Surgery Total],0))*100),2,0) else 0 end [Surgery Limit Percentage]
,isnull([Limit Displaced Less than 8 Weeks],0) [Limit Displaced Less than 8 Weeks],ISNULL(PS.[Regular Schedule Hours],0)[Regular Schedule Hours],ISNULL(PS.[Assign Provider To Clinic],0)[Assign Provider To Clinic]
,isnull(PS.[Irregular Schedule Hours],0)[Irregular Schedule Hours],PS.[Self Reported],isnull(CPH.[Cancel Provider Hours],0) [Cancel Provider Hours],ISNULL(PS.[Limit Schedules],0)[Limit Schedules]
,ISNULL(PS.[Add Clinic],0)[Add Clinic],ISNULL(PS.[Cancel Clinic],0) [Cancel Clinic],ISNULL([Off Schedule Adds],0) AS [Off Schedule Adds],case when ISNULL([Off Schedule Adds],0) =0 then 0 Else 100 end as [Off Schedule Adds Percentage]
from Expected ex left join ScheduleHrs SH on Ex.provider=sh.provider  
left join Off_Schedule_Hrs o on  ex.provider=O.provider
left join ScheduleChangeHrs SCH on Ex.provider=SCH.provider  
left join CountsofScheduleChanges CSCH on Ex.provider=CSCH.provider
left join Provider_Schedule PS on Ex.provider=ps.provider
Left join [Cancel Provider Hours] CPH ON Ex.provider=CPH.Provider

GO
