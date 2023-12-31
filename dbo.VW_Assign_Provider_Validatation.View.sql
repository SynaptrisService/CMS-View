USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Assign_Provider_Validatation]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE View [dbo].[VW_Assign_Provider_Validatation]
As
with 
--Processdetail
Processdetail as (

select   [Created On],[Created By],[Schedule Updated On],provider ,[Clinic Type],[Clinic Specialty],[Originating Process],isnull((select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time)
and cast([Start Time Maximum Value] as time)
and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
and cast([End Time Maximum Value] as time))),'All Day') [Clinic Hours Category]  
,[Clinic Start Date][Schedule Start Date] ,[Clinic End Date][Schedule end Date], [Clinic Date],[Assign Start Time][Clinic Start Time],[Assign End Time] [Clinic End Time],Location from   [Provider_Assigned_Clinics] a
 where [Clinic Date]>getdate()-30   
)
--Divisioncal
 , Divisioncalendar as (select  [Provider or Room Only Name],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location

 from   VW_Calendar_data   where [Clinic Date]>getdate()-30   )


 --cancel
 , cancel as (select  [Provider],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category] ,Location
from   Cancel_Provider_Clinic   where [Clinic Date]>getdate()-30 
),
cancelclinic as (select  [Clinic Type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category] ,Location
from   Cancel_Clinic   where [Clinic Date]>getdate()-30 
  )
  
      ,
	     CCALTable as (select  distinct  [Provider],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],Location
from   clinic_calendar   where [Clinic Date]>getdate()-30   
   )

      
      ,

   
   final as (

select a.*,case when isnull(b.[clinic date],'')='' then 'No' else 'Yes' end 'Division Calendar'
 ,case when isnull(c.[clinic date],'')='' then 'No' else 'Yes' end 'Cancel'
 ,case when isnull(d.[clinic date],'')='' then 'No' else 'Yes' end 'Cancelclinic'
  ,case when isnull(f.[clinic date],'')='' then 'No' else f.[Originating Process] end 'Clinic calendar Table'
 ,case when isnull(h.[clinic date],'')='' then 'No' else h.[Originating Process] end    'Clinic calendar Org' ,l.[Room Mandatory]
 ,case when isnull(o.[clinic date],'')='' then 'No' else 'Yes' end 'Less 20  Percent'





  from Processdetail a   left join Divisioncalendar b
 on a.[Clinic Date]=b.[Clinic Date]
  and cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE)
 and a.Provider=b.[Provider or Room Only Name]
 left join cancel c
 on a.[Clinic Date]=c.[Clinic Date] and a.[Clinic Hours Category]=c.[Clinic Hours Category] and a.Provider=c.[Provider]
left join cancelclinic d
 on a.[Clinic Date]=d.[Clinic Date] and d.[Clinic Hours Category]=d.[Clinic Hours Category] and a.[Clinic Type]=d.[Clinic Type]
 and a.[Clinic Specialty]=d.[Clinic Specialty]

 
--cliniccaletable
 left join CCALTable f
 on a.[Clinic Date]=f.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(f.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(f.[Clinic End Time] as timE) and a.Provider=f.[Provider]
--cliniccalendarotherentry
  left join Divisioncalendar h
 on a.[Clinic Date]=h.[Clinic Date]
  and cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE)
 and a.Provider=h.[Provider or Room Only Name]
 and a.[Originating Process]=h.[Originating Process]

 left join VW_Provider_Regular_Scheduler_Overlaps_Detail o on a.provider=o.[Req Provider] and a.[Clinic Date]=o.[Clinic Date]
 left join ERD_Location_Master l on a.Location=l.Location

 )


 

 

 select * from [final] where ([Division Calendar]='no' or [Clinic calendar Table]='no')
 and [Clinic Date] not in (
 select [Holiday Date] from .[ERD_Enterprise_Holiday_List] )
 




GO
