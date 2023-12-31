USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Overeview_Appointment_VisitType]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View  [dbo].[VW_Provider_Overeview_Appointment_VisitType]
as 
select distinct  x.[Full Name] [Visit Provider],[Appointment Date],StartTime,EndTime,SCH_Appt_Duration,
[Visit Type]=(select   stuff((
	select ';'+u.[Cancel Reason]+' - '+u.SCH_Entity_Identifier
		from Patient_Appointment_Data_rank_table u
	where u.[Visit Provider] = x.[Visit Provider] and  u.[Appointment Date] = x.[Appointment Date] 
	and u.StartTime =  x.StartTime  	 and u.EndTime= x.EndTime 
for xml path('') ),1,1,''))
,isnull((select top 1 [Clinic Hours Category] from [V3_ERD].[dbo].Clinic_Hours_Category
where (cast([CLinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) and cast([Start Time Maximum Value] as time)
and cast([CLinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time) and cast([End Time Maximum Value] as time))),format([CLinic Start Time],'tt'))
[Clinic Hours Category],format([CLinic Start Time],'hh:mm tt')[CLinic Start Time],format([CLinic End Time],'hh:mm tt') [CLinic End Time]
 from ( select distinct a.*,b.[Full Name] from Patient_Appointment_Data_rank_table a
 join employee_master b on dbo.funRemoveLeadingZeros(a.[AIP_3.1])=dbo.funRemoveLeadingZeros(b.upir)
 where ltrim(rtrim(isnull([Visit Provider],',')))!=',') x  
 left join (select * from Clinic_calendar
 where [CLinic Date]>'2021-06-30' and [Originating Process] not like '%inprogress%' and  [Originating Process] not like '%Cancel%') c
 on x.[Full Name]=c.Provider and cast(x.[Appointment Date] as date)=c.[Clinic Date] and
  cast(StartTime as time) between cast([CLinic Start Time] as time) and cast([CLinic End Time] as time)
  and cast(Endtime as time) between cast([CLinic Start Time] as time) and cast([CLinic End Time] as time)




GO
