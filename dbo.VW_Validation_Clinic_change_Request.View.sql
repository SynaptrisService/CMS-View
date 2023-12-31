USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Validation_Clinic_change_Request]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE View [dbo].[VW_Validation_Clinic_change_Request] as

 with Divisioncalendar as (
 select  [Provider or Room Only Name][Provider],[clinic type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location
 from   VW_Calendar_data   where [Clinic Date]>getdate()-30 
 and [Originating Process] in('Edit Provider Clinic','Shorten Provider Clinic','Shorten Clinic','Limit Provider Schedule','Limit Clinic Schedule')
   )
   --RAD
 , rad as (select  distinct  [Provider],[clinic type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time]
from   Room_Assignment_Detail   where [Clinic Date]>getdate()-30  and [Division Name] =(select top 1 [Division Name] from Division_Detail)
 and [Originating Process] in('Edit Provider Clinic','Shorten Provider Clinic','Shorten Clinic','Limit Provider Schedule','Limit Clinic Schedule')


   ),


     ROC as (select  distinct  [Provider],[clinic type],[Clinic Specialty],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],Location
from   Room_Occupancy_Details   where [Clinic Date]>getdate()-30  and [Division Name] =(select top 1 [Division Name] from Division_Detail)
 and [Originating Process] in('Edit Provider Clinic','Shorten Provider Clinic','Shorten Clinic','Limit Provider Schedule','Limit Clinic Schedule')

and [Room Status]='occupied'
   )
     

      
      ,

   
   final as (

select a.*,case when isnull(a.[clinic date],'')='' then 'No' else 'Yes' end 'Division Calendar'
 ,case when isnull(d.[clinic date],'')='' then 'No' else 'Yes' end 'RAD'
 ,case when isnull(e.[clinic date],'')='' then 'No' else 'Yes' end 'ROC'
 ,case when isnull(h.[clinic date],'')='' then 'No' else h.[Originating Process] end    'Clinic calendar Org' ,l.[Room Mandatory]
 ,d.[Originating Process][RAD Org]
 from Divisioncalendar a   left join rad d
 on a.[Clinic Date]=d.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(d.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(d.[Clinic End Time] as timE) and isnull(a.Provider,'')=isnull(d.[Provider],'')
and isnull(a.[clinic type],'')=isnull(d.[clinic type],'')
and isnull(a.[Clinic Specialty],'')=isnull(d.[Clinic Specialty],'')


--ROC
 left join ROC e
 on a.[Clinic Date]=e.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(e.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(e.[Clinic End Time] as timE) 
and isnull(a.Provider,'')=isnull(e.[Provider],'')
and isnull(a.[clinic type],'')=isnull(e.[clinic type],'')
and isnull(a.[Clinic Specialty],'')=isnull(e.[Clinic Specialty],'')

--cliniccalendarotherentry
  left join Divisioncalendar h
 on a.[Clinic Date]=h.[Clinic Date]
--  and cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

--and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE)
 and isnull(a.Provider,'')=isnull(h.[Provider],'')
 and isnull(a.[clinic type],'')=isnull(h.[clinic type],'')
and isnull(a.[Clinic Specialty],'')=isnull(h.[Clinic Specialty],'')
 left join ERD_Location_Master l on a.Location=l.Location

 )


 

 

 select * from [final] 
 --where [Originating Process]='Limit Clinic Schedule'
 where ([Division Calendar]='no' or [RAD]='no' 
 or [ROC]='no' 
 )
 and [Clinic Date] not in (
 select [Holiday Date] from .[ERD_Enterprise_Holiday_List] )
 and [clinic date]>=getdate()
 








GO
