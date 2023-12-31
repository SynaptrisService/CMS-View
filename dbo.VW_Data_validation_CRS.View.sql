USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Data_validation_CRS]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[VW_Data_validation_CRS] as 
with 
--Processdetail
Processdetail as (select   [Created On],[Created By],[Schedule Updated On],[Clinic Schedule Week] ,[Clinic Type],[Clinic Specialty] ,[Work Days],[Originating Process],[clinic hours category] 
,[Schedule Start Date] ,[Schedule end Date], [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location from   Clinic_Regular_Schedule_Detail
 where [Clinic Date]>getdate()-30   
 
union
select  [Created On],[Created By],[Created On] [Schedule Updated On],null [Clinic Schedule Week] , [Clinic Type],[Clinic Specialty]  ,null [Work Days],[Originating Process],[clinic hours category] 
,null [Schedule Start Date] ,null [Schedule end Date], [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location
from   Add_Clinic   where [Clinic Date]>getdate()-30    )
--Divisioncal
 , Divisioncalendar as (select  [Clinic Type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location

 from   VW_Calendar_data   where [Clinic Date]>getdate()-30 and (isnull([Provider or Room Only Name],'')='' or [Originating Process]='Assign Provider Clinic')  )


 --cancel
 , cancel as (select  [Clinic Type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category] ,Location
from   Cancel_Clinic   where [Clinic Date]>getdate()-30 


   )
   --RAD
 , rad as (select  distinct  [Clinic Type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time]
from   Room_Assignment_Detail   where [Clinic Date]>getdate()-30  and [Division Name] =(select top 1 [Division Name] from Division_Detail)
and isnull([Provider],'')=''


   ),


     ROC as (select  distinct  [Clinic Type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],Location
from   Room_Occupancy_Details   where [Clinic Date]>getdate()-30  and [Division Name] =(select top 1 [Division Name] from Division_Detail)

and [Room Status]='occupied' and isnull([Provider],'')=''
   )
      ,
	     CCALTable as (select  distinct  [Clinic Type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],Location
from   clinic_calendar   where [Clinic Date]>getdate()-30  and isnull([Provider],'')='' 
   )

      
      ,

   
   final as (

select a.*,case when isnull(b.[clinic date],'')='' then 'No' else 'Yes' end 'Division Calendar'
 ,case when isnull(c.[clinic date],'')='' then 'No' else 'Yes' end 'Cancel'
 ,case when isnull(d.[clinic date],'')='' then 'No' else 'Yes' end 'RAD'
 ,case when isnull(e.[clinic date],'')='' then 'No' else 'Yes' end 'ROC'
 ,case when isnull(f.[clinic date],'')='' then 'No' else f.[Originating Process] end 'Clinic calendar Table'
 ,case when isnull(h.[clinic date],'')='' then 'No' else h.[Originating Process] end    'Clinic calendar Org' ,l.[Room Mandatory]




  from Processdetail a   left join Divisioncalendar b
 on a.[Clinic Date]=b.[Clinic Date]
  and cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE)
 and a.[Clinic Type]=b.[Clinic Type] and a.[Clinic Specialty]=b.[Clinic Specialty]
 left join cancel c
 on a.[Clinic Date]=c.[Clinic Date] and a.[Clinic Hours Category]=c.[Clinic Hours Category] and a.[Clinic Type]=c.[Clinic Type] and a.[Clinic Specialty]=c.[Clinic Specialty]
 --and a.[Originating Process]=b.[Originating Process]


  left join rad d
 on a.[Clinic Date]=d.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(d.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(d.[Clinic End Time] as timE) and a.[Clinic Type]=d.[Clinic Type] and a.[Clinic Specialty]=d.[Clinic Specialty]

--ROC
 left join ROC e
 on a.[Clinic Date]=e.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(e.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(e.[Clinic End Time] as timE) and a.[Clinic Type]=e.[Clinic Type] and a.[Clinic Specialty]=e.[Clinic Specialty]
 
--cliniccaletable
 left join CCALTable f
 on a.[Clinic Date]=f.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(f.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(f.[Clinic End Time] as timE) and a.[Clinic Type]=f.[Clinic Type] and a.[Clinic Specialty]=f.[Clinic Specialty]
--cliniccalendarotherentry
  left join Divisioncalendar h
 on a.[Clinic Date]=h.[Clinic Date]
--  and cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

--and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE)
 and a.[Clinic Type]=h.[Clinic Type] and a.[Clinic Specialty]=h.[Clinic Specialty]
 and a.[Originating Process]!=h.[Originating Process]
 left join ERD_Location_Master l on a.Location=l.Location

 )


 

 

 select *,(select top 1 [Division Name] from [Division_Detail])[division] from [final] where ([Division Calendar]='no' or [RAD]='no' or [ROC]='no' or [Clinic calendar Table]='no')
 and [Clinic Date] not in (
 select [Holiday Date] from .[ERD_Enterprise_Holiday_List] )
 


GO
