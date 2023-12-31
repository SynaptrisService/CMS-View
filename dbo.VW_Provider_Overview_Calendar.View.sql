USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Overview_Calendar]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View  [dbo].[VW_Provider_Overview_Calendar] 
as 
select [Clinic Date],PhysicianName,CASE WHEN [Type]='3' THEN '0' ELSE [No of Appointments Scheduled] END [No of Appointments Scheduled],[Type]
from 
(
select distinct  [Clinic Date], PhysicianName
, case when 
		case when count([Clinic Date]) > 1 then '2' else max([type]) end='3' then sum(isnull([No of Appointments Scheduled],0))  else   
(select count(distinct [Appointment Time]) from ( select distinct a.*,b.[Full Name] from Patient_Appointment_Data_rank_table a
 , (select  a.PROV_NAME,b.[Employee Login ID],b.[Full Name] from ERD_Employee_Master_HL7 a join employee_master b
 on isnull(a.[active directory id],'')=isnull(b.[Employee Login ID],''))b
 where charindex(a.[Visit Provider],b.prov_name)>0 and ltrim(rtrim(isnull([Visit Provider],',')))!=',') z where --isnull([Visit Type],'')!=''
z.[Full Name]=a.PhysicianName and len(z.[Visit Provider])>1 and cast(z.[Appointment Date] as date)=cast(a.[clinic date] as date)
) end [No of Appointments Scheduled]
,  max([type])  [type]
from 
(select distinct  max(t.[Created On]) [Created On]  ,t.[Clinic Date],t.provider PhysicianName 
,sum([No of Appointments Scheduled]) [No of Appointments Scheduled] 
,case when stage in ('Provider Schedule','Irregular Provider Schedule','Limit','Assign Provider To Clinic')  then '1' when stage='Add' then '2'
when stage='Cancel' then '3'    when stage in ('Limit Hours','Cancel In Progress','Cancel Provider Hours') then '4'  
 when stage in ('Limit Provider Schedule') then '5'  else 0  end 'Type' 
from [VW_Clinic_Schedule_and_Changes_All] t  
inner join
(Select max([Created On]) [Created On],provider,[clinic date]  from [VW_Clinic_Schedule_and_Changes_All]
where isnull(provider,'')!='' Group by provider,[clinic date])m on t.[Created On]=m.[Created On]
and t.provider=m.provider
and t.[clinic date]=m.[clinic date] 
where isnull(t.provider,'')!='' and isnull([Stage],'') not in ('Clinic Schedule' ) and isnull(t.[Clinic Date],'')!='' 
and cast(t.[clinic date] as date) between cast(DATEADD(DAY, -DATEPART(DAY,GETDATE())+1,GETDATE()) as date)
 and cast(DATEADD(DAY, -DATEPART(DAY,GETDATE())+95,GETDATE()) as date)
and t.[Clinic Date] not in (select [Holiday Date] from [erd_Enterprise_Holiday_List])
group by t.[Clinic Date],t.provider ,stage )a 
where isnull(PhysicianName,'')!=''
group by [Clinic Date],PhysicianName
)x
/*

select [Clinic Date],PhysicianName,CASE WHEN [Type]='3' THEN '0' ELSE [No of Appointments Scheduled] END [No of Appointments Scheduled],[Type]
from 
(
select distinct  [Clinic Date], PhysicianName
, case when 
		case when count([Clinic Date]) > 1 then '2' else max([type]) end='3' then sum(isnull([No of Appointments Scheduled],0))  else   
''  end [No of Appointments Scheduled] 
,  max([type])  [type]
from 
(select distinct  max([Created On]) [Created On]  ,[Clinic Date],provider PhysicianName 
,sum([No of Appointments Scheduled]) [No of Appointments Scheduled] 
,case when stage in ('Provider Schedule','Irregular Provider Schedule','Limit','Assign Provider To Clinic')  then '1' when stage='Add' then '2'
when stage='Cancel' then '3'    when stage in ('Limit Hours','Cancel In Progress','Cancel Provider Hours') then '4'  else 0  end 'Type' 
from [VW_Clinic_Schedule_and_Changes_All] t  
where isnull(provider,'')!='' and isnull([Stage],'') not in ('Clinic Schedule' ) and isnull([Clinic Date],'')!='' 
and cast([clinic date] as date) between cast(DATEADD(DAY, -DATEPART(DAY,GETDATE())+1,GETDATE()) as date)
 and cast(DATEADD(DAY, -DATEPART(DAY,GETDATE())+95,GETDATE()) as date)
and [Clinic Date] not in (select [Holiday Date] from [erd_Enterprise_Holiday_List])
group by [Clinic Date],provider ,stage )a 
where isnull(PhysicianName,'')!=''
group by [Clinic Date],PhysicianName
)x
*/

GO
