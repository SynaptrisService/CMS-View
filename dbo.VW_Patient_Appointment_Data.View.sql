USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Patient_Appointment_Data]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View  [dbo].[VW_Patient_Appointment_Data]
as 
with Patientdata
as
(
	select [Visit Provider] as Provider ,[Appointment Date] AS [Clinic Date],[Visit Provider]
	,[Appointment Date] [Clinic Start Time],
	DateAdd(MINUTE,cast(SCH_Appt_Duration as int),[Appointment Date]) AS [Clinic End Time],
	RIGHT(CONVERT(varchar,cast( case when datediff(minute,0,cast([Appointment Time] as time))%60 in (10,40) then dateadd(minute,20,[Appointment Time])
	else [Appointment Time] end as datetime), 100),8) + ': ' + [Visit Type] +', '+ [Department]  AS Appointments,[Visit Type] ,[Department],[Cancel Reason],SCH_Entity_Identifier,[created on]
	from [Patient_Appointment_Data_HL7] where (isnull([Visit Type],'')!='' and   isnull([Visit Type],'')!='NULL') and len([Visit Provider])>1
),
Materhl7 as
(
select b.*,a.[active directory id] from ERD_Employee_Master_HL7 a inner join Patientdata b  on 1=1
 where charindex(rtrim(ltrim(b.[Visit Provider])),rtrim(ltrim(a.prov_name)))>0
)
,
Empmaster as
(
--select distinct [Full Name] as [Provider], [Clinic Date] , [Clinic Start Time] ,  [Clinic End Time] ,Appointments 
-- ,[Cancel Reason]  [Visit Type] ,[Department],[Visit Provider],SCH_Entity_Identifier,a.[created on]
--from Materhl7 a inner join employee_master b on a.[active directory id]=b.[employee login id]
select b.[Provider], [Clinic Date] , [Clinic Start Time] ,  [Clinic End Time] ,Appointments 
 ,[Cancel Reason]  [Visit Type] ,[Department],[Visit Provider],SCH_Entity_Identifier,a.[created on]
from Materhl7 a inner join (Select distinct Rtrim([Full Name]) as Provider, [employee login id] from employee_master where [Employee Status]='Active'
 and isnull([User Authentication],'No')='Yes' AND [employee type] = 'Provider') b 
on  a.Provider=b.Provider where a.[active directory id]=b.[employee login id]
)
,
schedule as
(
select * from (
select 
/*Originating process, created on and division name column are added for KEDW ETL propose Date: 20230620*/
'Off Schedule Hours' as [Originating Process], b.[Created On],(SELECT TOP 1 [Division Name] FROM DIVISION_DETAIL) AS[Division Name],
case when isnull(a.Provider,'')='' then 'Off Schedule' else 'Scheudle' end Stage,b.[provider],(b.[provider] +'##$$') AS [Provider Name], 
b.[Clinic Date] ,a.Location,a.[Room Number],a.[Room Name], b.[Clinic Start Time], b.[Clinic End Time] 
,b.Appointments AS Appointments
,b.[Visit Type],b.[Department] as [Department]
, b.[Provider] as Physician , b.[Provider] as PhysicianName,a.Location as [Clinic Location Detail], a.[Clinic Type] as [Clinic Type Detail]
, a.[Clinic Specialty] as [Clinic Speciality], a.[Clinic Duration] as [Clinic Duration]
,''[Rooms Required]
,''[Rooms Assigned]
,[Room Name][Rooms Name],SCH_Entity_Identifier,ROW_NUMBER() over(partition by [SCH_Entity_Identifier] order by b.[Created On] desc) rno 
 from Provider_Regular_Schedule_Detail a right join Empmaster b on a.[provider]=b.[provider]
--charindex(b.[Visit Provider],a.Provider)>0 
and  cast(a.[Clinic Date] as datE) =cast (b.[Clinic Date] as date) and b.[Clinic Start Time] between a.[Clinic Start Time] and a.[Clinic End Time]
and b.[Clinic End Time]  between a.[Clinic Start Time] and a.[Clinic End Time]
)a where not exists(select '' from 
   cancel_provider_clinic b where a.provider=b.provider and cast(a.[clinic date] as date)=cast(b.[clinic date] as date) 
   and cast(a.[Clinic start time] as time)=cast(b.[Clinic start time] as time) and cast(a.[clinic end time] as time)=cast(b.[clinic end time] as time)) 
)
select *,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float) [Off Schedule Hours] from schedule 
where rno=1 and isnull(provider,'')!=''






GO
