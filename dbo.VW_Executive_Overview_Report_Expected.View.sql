USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Executive_Overview_Report_Expected]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW  [dbo].[VW_Executive_Overview_Report_Expected] 
As
WITH ScheduleHrs
AS 
(
SELECT  [Clinic Type],[Clinic Specialty],Round(SUM([Clinic Hours]),0) [Schedule Hours],[Originating Process]
FROM [VW_Clinic_Schedule_and_Changes] a left join [Employee_Master] b on a.[provider]=b.[Full Name]
WHERE ISNULL([Stage], '') IN ('Clinic Schedule','Provider Schedule','Irregular Provider Schedule','Regular Linked Clinic Schedule','Assign Provider To Clinic')
AND [clinic date] NOT IN (SELECT [holiday date]	FROM [dbo].[ERD_Enterprise_Holiday_List]) and charindex(b.[Employee Type],'Provider')>0
gROUP BY [Clinic Type],[Clinic Specialty],[Originating Process]
),
ScheduleChangeHrs
AS 
(
select [Clinic Type],[Clinic Specialty] ,isnull(sum([Schedule Change Hours]),0) [Schedule Change Hours]
from (SELECT [Clinic Type],[Clinic Specialty] ,	case when [Stage] in ('Cancel Provider Hours','Cancel','Cancel Clinic Hours','Cancel Clinic Schedule') then Round(SUM([Clinic Hours]),0)*-1 else  Round(SUM([Clinic Hours]),0) end [Schedule Change Hours]	
FROM [VW_Clinic_Schedule_and_Changes] A left join [Employee_Master] b on a.[provider]=b.[Full Name]
WHERE ISNULL([Stage], '') IN ('Add', 'Self Reported','Cancel Provider Hours','Cancel','Add Clinic', 'Cancel Clinic Hours','Cancel Clinic Schedule')
AND [clinic date] NOT IN (SELECT [holiday date]	FROM [dbo].[ERD_Enterprise_Holiday_List]) and charindex(b.[Employee Type],'Provider')>0
GROUP BY [Clinic Type],[Clinic Specialty],stage )z

group by [Clinic Type],[Clinic Specialty]
),
CountsofScheduleChanges
AS 
(select a.[Clinic Type],a.[Clinic Specialty] , isnull(sum([Cancel]),0)  [Cancel], isnull(sum([Cancellations Less than 8 Weeks]),0) [Cancellations Less than 8 Weeks]
,isnull(sum([Total Displaced Patients]),0) [Total Displaced Patients],isnull(sum([Displaced Patients Less than 8 Weeks]),0) [Displaced Patients Less than 8 Weeks],
isnull(sum([Cancel Displaced Less than 8 Weeks]),0) [Cancel Displaced Less than 8 Weeks], isnull(sum([Add Less than 8 Weeks]),0) [Add Less than 8 Weeks]
,isnull(sum([Add Displaced Less than 8 Weeks]),0) [Add Displaced Less than 8 Weeks]
,isnull(sum([Limit Less than 8 Weeks]),0)[Limit Less than 8 Weeks], isnull(sum([Limit Displaced Less than 8 Weeks]),0) [Limit Displaced Less than 8 Weeks],	isnull(sum([Add Total]),0)[Add Total]
,isnull(sum([Limit Total]),0) [Limit Total]
from (
select [Clinic Type],[Clinic Specialty]  ,[request notice period in weeks],stage
,sum([No of Appointments Scheduled])  [Total Displaced Patients]
,case when  [request notice period in weeks]<8 then sum([No of Appointments Scheduled]) else 0 end [Displaced Patients Less than 8 Weeks]
,case when stage in('Cancel Clinic Schedule','Cancel') then  sum([Clinic Hours])else 0 end  [Cancel]
,case when stage in('Add Clinic' ,'Add','Self Reported' ) then  round(sum([Clinic Hours]),0) else 0 end  [Add Total]
,case when stage in('Cancel Clinic Hours' ,'Cancel Provider Hours') then  sum([Clinic Hours]) else 0 end  [Limit Total]
,case when stage in('Cancel Clinic Schedule','Cancel')  and  [request notice period in weeks]<8 then  sum([Clinic Hours]) else 0 end 'Cancellations Less than 8 Weeks' 
,case when  stage in('Cancel Clinic Schedule', 'Cancel') and [request notice period in weeks]<8 then  sum([No of Appointments Scheduled]) else 0 end 'Cancel Displaced Less than 8 Weeks'
,case when stage in('Add Clinic' ,'Add','Self Reported') and  [request notice period in weeks]<8 then  round(sum([Clinic Hours]),0) else 0 end 'Add Less than 8 Weeks' 
,case when  stage in('Add Clinic' ,'Add','Self Reported')and [request notice period in weeks]<8 then  sum([No of Appointments Scheduled]) else 0 end 'Add Displaced Less than 8 Weeks'
,case when stage in('Cancel Clinic Hours' ,'Cancel Provider Hours')and  [request notice period in weeks]<8 then  sum([Clinic Hours]) else 0 end 'Limit Less than 8 Weeks' 
,case when  stage in('Cancel Clinic Hours' ,'Cancel Provider Hours') and [request notice period in weeks]<8 then  sum([No of Appointments Scheduled]) else 0 end 'Limit Displaced Less than 8 Weeks'
FROM [dbo].[VW_Clinic_Schedule_and_Changes] A left join [Employee_Master] b on a.[provider]=b.[Full Name] where
stage in ('Cancel Clinic Schedule','Add Clinic','Self Reported','Cancel Clinic Hours','Cancel','Add','Cancel Provider Hours') --and provider='Knisely, Colin'
and [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [dbo].[VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [dbo].[VW_Financial_Year])
and [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 
and charindex(b.[Employee Type],'Provider')>0

group by  [request notice period in weeks] ,[Clinic Type],[Clinic Specialty],[No of Appointments Scheduled],stage) a 
group by a.[Clinic Type],a.[Clinic Specialty]
),
Clinic_Schedule
as
(
select a.[Clinic Type],a.[Clinic Specialty],Round(sum([Regular Schedule Hours]),0)[Regular Schedule Hours],Round(sum([Assign Provider To Clinic]),0) [Assign Provider To Clinic]
,Round(sum([Limit Schedules]),0)[Limit Schedules],Round(sum([Add Clinic]),0) [Add Clinic],Round(sum([Cancel Clinic]),0) [Cancel Clinic]
from (select [Clinic Type],[Clinic Specialty],stage
,case when stage in('Clinic Schedule','Provider Schedule','MDC Schedule') then  sum([Clinic Hours]) else 0 end 'Regular Schedule Hours' 
,case when stage='Assign Provider To Clinic' then  sum([Clinic Hours]) else 0 end 'Assign Provider To Clinic' 
,case when stage in('Limit Clinic Schedule','Limit Provider Schedule')  then  sum([Clinic Hours]) else 0 end 'Limit Schedules'
,case when stage in('Add Clinic','Add','Self Reported') then sum([Clinic Hours]) else 0 end 'Add Clinic'
,case when stage in('Cancel Clinic Schedule','cancel') then  sum([Clinic Hours]) else 0 end 'Cancel Clinic'
FROM [dbo].[VW_Clinic_Schedule_and_Changes]  A left join [Employee_Master] b on a.[provider]=b.[Full Name] where --and provider='Knisely, Colin'
[Clinic Date] between (SELECT TOP 1 [START DATE] FROM [dbo].[VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [dbo].[VW_Financial_Year])
and [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 
and charindex(b.[Employee Type],'Provider')>0
group by  [request notice period in weeks] ,[Clinic Type],[Clinic Specialty] ,[No of Appointments Scheduled],stage) a 
group by a.[Clinic Type],a.[Clinic Specialty] 
),
[Cancel Clinic Hours]
AS
(
selecT [Clinic Type],[Clinic Specialty],[Originating Process],sum([Cancel Clinic Hours]) [Cancel Clinic Hours], sum([Cancel Clinic Hours 8 Weeks])[Cancel Clinic Hours 8 Weeks] 
from (select [Clinic Type],[Clinic Specialty] ,[Originating Process],
case when [Originating Process] in('Cancel Clinic Hours','Cancel Provider Hours' )then sum([Clinic Hours]) else 0 end 'Cancel Clinic Hours',
case when  [request notice period in weeks]<8 then  sum([Clinic Hours]) else 0 end 'Cancel Clinic Hours 8 Weeks'   
from 
(select [Clinic Type],[Clinic Specialty] ,[Originating Process],casT((DATEDIFF(MINUTE,[Cancel Start Time],[Cancel End Time])) as float)/60  [Clinic Hours] ,[request notice period in weeks]
FROM [dbo].[Shorten_Provider_Clinic] A left join [Employee_Master] b on a.[provider]=b.[Full Name] where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [dbo].[VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [dbo].[VW_Financial_Year])
and [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List])
and charindex(b.[Employee Type],'Provider')>0
union all
select [Clinic Type],[Clinic Specialty],[Originating Process],casT((DATEDIFF(MINUTE,[Cancel Start Time],[Cancel End Time])) as float)/60  [Clinic Hours] ,[request notice period in weeks]
FROM [dbo].[Shorten_Provider_Clinic_Detail] A left join [Employee_Master] b on a.[provider]=b.[Full Name]  where [Clinic Date] between (SELECT TOP 1 [START DATE] FROM [dbo].[VW_Financial_Year]) and (SELECT TOP 1 [end DATE] FROM [dbo].[VW_Financial_Year])
and [clinic date] not in (select [holiday date] from [dbo].[ERD_Enterprise_Holiday_List]) 
and charindex(b.[Employee Type],'Provider')>0
)a Group by [Clinic Type],[Clinic Specialty],[Originating Process],[request notice period in weeks]) s
group by [Clinic Type],[Clinic Specialty],[Originating Process]
)

select M.[Clinic Type],M.[Clinic Specialty],round(isnull(SH.[Schedule Hours],0),0) [Schedule Hours] ,isnull(SH.[Schedule Hours]*14/100,0) [Allowable Cancel Percent]
,isnull(SH.[Schedule Hours]*14/100 + (SH.[Schedule Hours]*14/100)*10/100,0) [Allowable Cancel Limit]
,(isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)-isnull(SH.[Schedule Hours]*14/100,0)-isnull(SH.[Schedule Hours]*14/100+(SH.[Schedule Hours]*14/100)*10/100,0)) [More Than Cancel Limit]
,round(isnull(isnull(SH.[Schedule Hours],0)+isnull(SCH.[Schedule Change Hours],0),0),0) [Actual],
isnull(ROUND(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0)-ISNULL(SH.[Schedule Hours], 0) ,0),0) Different, 
casT(case when isnull(SH.[Schedule Hours],0)=0 then 0 else  isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)/isnull(SH.[Schedule Hours],0)*100  end as int) Percentage
,Case when casT(case when isnull(SH.[Schedule Hours],0)=0 then 0 else  isnull(SH.[Schedule Hours]+isnull(SCH.[Schedule Change Hours],0),0)/isnull(SH.[Schedule Hours],0)*100  end as int) >=86 then 'No' Else 'Yes' End [Show Status]  
,CASE WHEN ISNULL(SH.[Schedule Hours], 0) < ISNULL(SCH.[Schedule Change Hours], 0) THEN 'Shortage' ELSE 'Excess' END 'ExcessShortage'
,CASE WHEN ROUND(ISNULL(SH.[Schedule Hours],0) - ISNULL(SCH.[Schedule Change Hours],0),0) >= 0 THEN 'At or Above Expected'
WHEN ROUND(ISNULL(SH.[Schedule Hours],0) - ISNULL(SCH.[Schedule Change Hours],0),0) BETWEEN -15 AND -1 THEN 'Shortage less than 16 Hours'
WHEN ROUND(ISNULL(SH.[Schedule Hours],0) - ISNULL(SCH.[Schedule Change Hours],0),0) <= -16 THEN 'Shortage greater than or equal 16 Hours' END Hourstaus
,round(isnull([Cancel],0),0) [Cancel],  isnull([Cancellations Less than 8 Weeks],0) [Cancellations Less than 8 Weeks]
,case when (isnull([Cancellations Less than 8 Weeks],0)!=0 and isnull([Cancel],0)!=0) then round((isnull([Cancellations Less than 8 Weeks],0)/(isnull([Cancel],0))*100),2,0) else 0 end  [Cancel Percentage] 
,isnull([Total Displaced Patients],0) [Total Displaced Patients],round(isnull([Displaced Patients Less than 8 Weeks],0),0) [Displaced Patients Less than 8 Weeks]
,round(Case when isnull([Total Displaced Patients],0)!='0' then  isnull([Displaced Patients Less than 8 Weeks],0)*100/isnull([Total Displaced Patients],0) else 0 end,0) [Total Displaced Patients Percentage]
,isnull([Cancel Displaced Less than 8 Weeks],0) [Cancel Displaced Less than 8 Weeks],isnull([Add Total],0) [Add Total] ,isnull([Add Less than 8 Weeks],0) [Add Less than 8 Weeks]
,case when (isnull([Add Less than 8 Weeks],0)!=0 and isnull([Add Total],0)!=0) then  round((isnull([Add Less than 8 Weeks],0)/(isnull([Add Total],0))*100),2,0) else 0 end [Add Percentage]
,isnull([Add Displaced Less than 8 Weeks],0) [Add Displaced Less than 8 Weeks]
,isnull([Cancel Clinic Hours],0) [Limit Total],isnull([Cancel Clinic Hours 8 Weeks],0) [Limit Less than 8 Weeks]
,case when (isnull([Cancel Clinic Hours 8 Weeks],0)!=0 and isnull([Cancel Clinic Hours],0)!=0) then round((isnull([Cancel Clinic Hours 8 Weeks],0)/(isnull([Cancel Clinic Hours],0))*100),2,0) else 0 end [Limit Percentage]
,isnull([Limit Displaced Less than 8 Weeks],0) [Limit Displaced Less than 8 Weeks],ISNULL(PS.[Regular Schedule Hours],0)[Regular Schedule Hours],round(ISNULL(PS.[Assign Provider To Clinic],0),0)[Assign Provider To Clinic]
,isnull(CPH.[Cancel Clinic Hours],0) [Cancel Clinic Hours],ISNULL(PS.[Limit Schedules],0)[Limit Schedules]
,round(ISNULL(PS.[Add Clinic],0),0)[Add Clinic],ISNULL(PS.[Cancel Clinic],0) [Cancel Clinic]
,--ISNULL(DS.[Display Name],'') AS 
m.[Clinic Specialty] [Display Name],
--CASE WHEN DS.[Display Name]!='' THEN 'Yes' Else 'No' End as
 'Yes'[Display Status], [display order] [Rank]
from 
--ScheduleHrs  SH left join ScheduleChangeHrs SCH on SH.[Clinic Type]=SCH.[Clinic Type] and SH.[Clinic Specialty]=SCH.[Clinic Specialty]   
--left join CountsofScheduleChanges CSCH on sh.[Clinic Type]=CSCH.[Clinic Type] and sh.[Clinic Specialty]=CSCH.[Clinic Specialty]   
--left join Clinic_Schedule PS on sh.[Clinic Type]=ps.[Clinic Type] and sh.[Clinic Specialty]=ps.[Clinic Specialty] 
--Left join [Cancel Clinic Hours] CPH ON SH.[Clinic Type]=CPH.[Clinic Type] and SH.[Clinic Specialty]=CPH.[Clinic Specialty]
--LEFT join Define_Executive_Overview_Specialty DS ON SH.[Clinic Type]=DS.[Clinic Type] AND SH.[Clinic Specialty]=DS.[Clinic Specialty] where ISNULL(DS.[Display Name],'') !=''
[Clinic_Specialty] M left join  ScheduleHrs  SH on m.[Clinic Specialty]=sh.[Clinic Specialty]and m.[Clinic Type]=sh.[Clinic Type]
left  join ScheduleChangeHrs SCH on M.[Clinic Type]=SCH.[Clinic Type] and M.[Clinic Specialty]=SCH.[Clinic Specialty]   
left join CountsofScheduleChanges CSCH on M.[Clinic Type]=CSCH.[Clinic Type] and M.[Clinic Specialty]=CSCH.[Clinic Specialty]   
left join Clinic_Schedule PS on M.[Clinic Type]=ps.[Clinic Type] and M.[Clinic Specialty]=ps.[Clinic Specialty] 
Left join [Cancel Clinic Hours] CPH ON M.[Clinic Type]=CPH.[Clinic Type] and M.[Clinic Specialty]=CPH.[Clinic Specialty]
--LEFT join Define_Executive_Overview_Specialty DS ON M.[Clinic Type]=DS.[Clinic Type] AND M.[Clinic Specialty]=DS.[Clinic Specialty]
where ISNULL(m.[Clinic Specialty],'') !=''

GO
