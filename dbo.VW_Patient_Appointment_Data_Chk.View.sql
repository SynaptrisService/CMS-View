USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Patient_Appointment_Data_Chk]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View  [dbo].[VW_Patient_Appointment_Data_Chk] as 

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
select b.*,a.[active directory id] from ERD_Employee_Master_HL7 a join Patientdata b on charindex(b.Provider,a.prov_name)>0
)
,
Empmaster as
(
select [Full Name] as [Provider], [Clinic Date] , [Clinic Start Time] ,  [Clinic End Time] ,Appointments  ,[Cancel Reason]  [Visit Type] ,[Department],[Visit Provider],SCH_Entity_Identifier,a.[created on]
from Materhl7 a left join [Employee_Master] b on a.[active directory id]=b.[employee login id]
)
,
schedule as
(
select distinct  case when isnull(a.Provider,'')='' then 'Off Schedule' else 'Scheudle' end Stage,b.[provider],(b.[provider] +'##$$') AS [Provider Name], b.[Clinic Date] ,a.Location,a.[Room Number],a.[Room Name], b.[Clinic Start Time], b.[Clinic End Time] 
,b.Appointments AS Appointments
,b.[Visit Type],b.[Department] as [Department]
, b.[Provider] as Physician , b.[Provider] as PhysicianName,a.Location as [Clinic Location Detail], a.[Clinic Type] as [Clinic Type Detail]
, a.[Clinic Specialty] as [Clinic Speciality], a.[Clinic Duration] as [Clinic Duration]
,''[Rooms Required]
,''[Rooms Assigned]
,''[Rooms Name],SCH_Entity_Identifier,ROW_NUMBER() over(partition by [SCH_Entity_Identifier] order by b.[Created On] desc) rno  from provider_regular_schedule_detail a right join Empmaster b on a.[provider]=b.[provider]
--charindex(b.[Visit Provider],a.Provider)>0 
and  cast(a.[Clinic Date] as datE) =cast (b.[Clinic Date] as date) and b.[Clinic Start Time] between a.[Clinic Start Time] and a.[Clinic End Time]
and b.[Clinic End Time]  between a.[Clinic Start Time] and a.[Clinic End Time]
)
select * from schedule where rno=1 and isnull(provider,'')!=''

GO
