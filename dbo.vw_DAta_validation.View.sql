USE [V3_Neurology]
GO
/****** Object:  View [dbo].[vw_DAta_validation]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * into neurology_calendar_data from vw_calendar_data
 
CREATE view [dbo].[vw_DAta_validation] as 
with 

ActualPRSdetail as (select * from 
		(
		select	
		
		[Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],[WF Status],
		[Record Modified By],[Record Modified On],[Modified Section],[Master System ID],[Schedule ID],
		[Schedule Type],[Schedule Frequency],[Provider],[Employee Login ID],[Division Name],[Clinic Type],[Clinic Specialty],
		[Location],[Clinic ID],[Schedule Start Date],[Schedule End Date],[Recurring Schedule End Date],
		CONVERT(date, Clinic_Date, 103)[Clinic Date],dateadd(hour,datepart(HOUR,[Clinic Start Time]),
		dateadd(MINUTE, datepart(MINUTE,[Clinic Start Time]),CONVERT(datetime, Clinic_Date, 103))) [Clinic Start Time],
		dateadd(hour,datepart(HOUR,[Clinic End Time]),dateadd(MINUTE, datepart(MINUTE,[Clinic End Time]),
		CONVERT(datetime, Clinic_Date, 103))) [Clinic End Time],[Work Days],[Clinic Schedule Week],[Clinic Hours Category],[Rooms Required],
		[Building],[Floor],[Wing],[Room Name],[Room Number],[Room Label],[Clinic Notes],[Originating Process],[Clinic Duration],
		[Schedule Updated On],[Clinic Schedule Notes],[Schedule Originating Date],
		replace(replace(isnull([Employee Login ID],'')+isnull(Provider,'')+
					isnull([Clinic Type],'')+isnull([Clinic Specialty],'')+isnull([Location],'')
					+isnull(cast(cast([Clinic Start Time] as time)as varchar(5)),'')
					+isnull(cast(cast([Clinic end Time] as time) as varchar(5)),'')
					+isnull(convert(varchar(8),
					CONVERT(date, DT.Clinic_Date, 103) , 112),''),',',''),' ','')[Kezava Unique ID],[Clinic Change Email Notification],
		[Schedule Change Email Notification],[MDC Clinic],[MDC Host Domain],[Room Hours Exception Approval],[Exception Approval Status],
		[Exception Approval Comments],[Division Approval Required],[Division Approval Status],[Division Approval Comments],[EMR Update Status],
		[Schedule Confirmation Date],[Schedule Confirmation Notes],[Room Operations Support Required],[Display in Calendar],[Schedule Exception Approval],
		[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task],[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],
		[Floor Task],[Wing Task],[Room Name Task],[Room Number Task],[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],
		[Location Exception],[Clinic Type Exception],[Clinic Specialty Exception],[Clinic Duration Exception],[Clinic Start Time Exception],
		[Clinic End Time Exception],[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days],[Unused Days Exception Approval],
		[No of Participants],[Workspaces Required],[Suite],[Participant Notes],[Suite Task],[Suite Exception],[DEP Name],[Mode of Delivery]
		
		from	Provider_Regular_Schedule_grid PR
		left join 
			( 
				SELECT   Clinic_Date 
				FROM [V3_Allergy-Immunology].dbo.[datetable] 
			) DT on 1 = 1 
		where	CHARINDEX(cast(ceiling(cast(right(CONVERT(Date, DT.Clinic_Date, 103),2)
				as float)/7.00)as nvarchar(10)),PR.[Clinic Schedule Week])>0 
		and		CHARINDEX(left(datename(weekday,CONVERT(Date, DT.Clinic_Date, 103)),3),
				PR.[Work Days])> 0 
		and		PR.Provider = provider 
		--and		PR.[Created On] = @CreatedOn 
		and dt.Clinic_Date between pr.[Schedule Start Date] and pr.[Schedule End Date]
	and CONVERT(date, Clinic_Date, 103) not in (select  [Clinic date] from [VW_Provider_Regular_Scheduler_Overlaps_Detail] h 
	where h.[req provider]=pr.provider 
	and 
	
	(cast(h.[Start Time] as time) between  cast(pr.[Clinic Start Time] as time) and cast( pr.[Clinic End Time] as time)
		or   cast(h.[End Tine]  as time) between  cast(pr.[Clinic Start Time] as time) and cast( pr.[Clinic End Time] as time)
		or cast(pr.[Clinic Start Time]  as time) between  cast(h.[Start Time] as time) and cast( h.[End Tine]  as time)
		or  cast(pr.[Clinic End Time]  as time) between cast(h.[Start Time] as time) and cast( h.[End Tine]  as time) 
		--			or 
		--			(select top 1 [Clinic Hours Category] from [dbo].ERD_Clinic_Hours_Category
		--where (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) 
		--and cast([Start Time Maximum Value] as time)
		--and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time)
		-- and cast([End Time Maximum Value] as time)))='All Day'
		)
		and (cast(pr.[Clinic End Time]  as time)!= cast(h.[Start Time] as time) and  (cast(pr.[Clinic Start Time]  as time)!= cast(h.[End Tine] as time) ))
				and h.[Clinic date]=CONVERT(date, Clinic_Date, 103)
	 ) 
	)a ),
--Processdetail
Processdetail as (select   [Created On],[Created By],[Schedule Updated On],[Clinic Schedule Week] ,provider ,[Work Days],[Originating Process],[clinic hours category] 
,[Schedule Start Date] ,[Schedule end Date], [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location ,[DEP Name],[Room Number] from   Provider_Regular_Schedule_Detail
 where [Clinic Date]>getdate()-30   
union
select  [Created On],[Created By],[Schedule Updated On],[Clinic Schedule Week] ,[Room Only Schedule Provider] ,[Work Days],[Originating Process],[clinic hours category] 
,[Schedule Start Date] ,[Schedule end Date], [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location,[DEP Name],[Room Number]
from   Room_Only_Regular_Schedule_detail   where [Clinic Date]>getdate()-30 
 
union
select  [Created On],[Created By],[Created On] [Schedule Updated On],null [Clinic Schedule Week] , provider  ,null [Work Days],[Originating Process],[clinic hours category] 
,null [Schedule Start Date] ,null [Schedule end Date], [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location,[DEP Name],[Room Number]
from   Add_Provider_Clinic   where [Clinic Date]>getdate()-30  
union
 
 
select  [Created On],[Created By],[Created On] [Schedule Updated On],null [Clinic Schedule Week] , provider  ,null [Work Days],[Originating Process],[clinic hours category] 
,null [Schedule Start Date] ,null [Schedule end Date], [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location,[DEP Name],[Room Number]
from   Edit_Provider_Clinic_Specialty   where [Clinic Date]>getdate()-30  
)
--Divisioncal
 , Divisioncalendar as (select  [Provider or Room Only Name],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time] ,Location

 from   neurology_calendar_data   where [Clinic Date]>getdate()-30   )


 --cancel
 , cancel as (select [Created On],  [Provider],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category] ,Location
from   Cancel_Provider_Clinic   where [Clinic Date]>getdate()-30 
union
select [Created On], [Room Only Schedule Provider],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],[Clinic Hours Category] ,Location
from   Cancel_Room_Only_Schedule   where [Clinic Date]>getdate()-30

   )
   --RAD
 , rad as (select  distinct  [Provider],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time] ,[Room Number] 
from   Room_Assignment_Detail   where [Clinic Date]>getdate()-30  
and [Division Name] =(select top 1 [Division Name] from Division_Detail)


   ),


     ROC as (select  distinct  [Provider],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],Location
from   Room_Occupancy_Details   where [Clinic Date]>getdate()-30  and [Division Name] =(select top 1 [Division Name] from Division_Detail)

and [Room Status]='occupied'
   )
      ,
	     CCALTable as (select  distinct  [Provider],[Originating Process] 
, [Clinic Date],[Clinic Start Time],[Clinic End Time],Location
from   clinic_calendar   where [Clinic Date]>getdate()-30   
   )

      
      ,

   
   final as (

select z.*,
case when isnull(a.[clinic date],'')='' then 'No' else 'Yes' end 'PRS Detail'
,
case when isnull(b.[clinic date],'')='' then 'No' else 'Yes' end 'Division Calendar'
 ,case when isnull(c.[clinic date],'')='' then 'No' else 'Yes' end 'Cancel'
 ,case when isnull(d.[clinic date],'')='' then 'No' else 'Yes' end 'RAD'
 ,case when isnull(e.[clinic date],'')='' then 'No' else 'Yes' end 'ROC'
 --,case when isnull(f.[clinic date],'')='' then 'No' else f.[Originating Process] end 'Clinic calendar Table'
 ,case when isnull(h.[clinic date],'')='' then 'No' else h.[Originating Process] end    'Clinic calendar Org'
 ,case when isnull(j.[clinic date],'')='' then 'No' else 'YEs' end    'will overlap'


 

 
 
 ,l.[Room Mandatory DEP] [Room Mandatory1]
 ,case when isnull(o.[clinic date],'')='' then 'No' else 'Yes' end 'Less 20  Percent'
 ,

 case when isnull(h.[clinic date],'')='' then 'No' else (select top 1 [Clinic Hours Category] from [V3_ERD].[dbo].Clinic_Hours_Category
where (cast(h.[clinic start time] as time) BETWEEN cast([Start Time Minimum Value] as time) and cast([Start Time Maximum Value] as time)
and cast(h.[clinic end time] as time) BETWEEN cast([End Time Minimum Value] as time) and cast([End Time Maximum Value] as time))) end    'Clinic calendar CHC'


  from
  ActualPRSdetail z left join Processdetail a  on 
  a.[Clinic Date]=z.[Clinic Date]
  and cast(a.[Clinic Start Time] as timE)= cast(z.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(z.[Clinic End Time] as timE)
 and a.Provider=z.[Provider]
  left join Divisioncalendar b
 on a.[Clinic Date]=b.[Clinic Date]
  and cast(a.[Clinic Start Time] as timE)= cast(b.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(b.[Clinic End Time] as timE)
 and a.Provider=b.[Provider or Room Only Name]
 and (a.[Originating Process]=b.[Originating Process] or b.[Originating Process]='Provider Regular Schedule Inprogress')
 left join cancel c
 on a.[Clinic Date]=c.[Clinic Date] and a.[Clinic Hours Category]=c.[Clinic Hours Category] and a.Provider=c.[Provider]
 --and a.[Originating Process]=b.[Originating Process]
 AND A.[Created On]<C.[Created On]


  left join rad d
 on a.[Clinic Date]=d.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(d.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(d.[Clinic End Time] as timE) and a.Provider=d.[Provider]

--ROC
 left join ROC e
 on a.[Clinic Date]=e.[Clinic Date] and cast(a.[Clinic Start Time] as timE)= cast(e.[Clinic Start Time] as  time)

and cast(a.[Clinic End Time] as timE)=cast(e.[Clinic End Time] as timE) and a.Provider=e.[Provider]
 
--cliniccaletable
-- left join CCALTable f
-- on a.[Clinic Date]=f.[Clinic Date]  and a.Provider=f.[Provider]

--and (cast(a.[Clinic Start Time] as time) between cast(f.[Clinic Start Time] as time) and cast(f.[Clinic End Time] as time)
--	or cast(a.[Clinic End Time] as time) between cast(f.[Clinic Start Time] as time) and cast(f.[Clinic End Time] as time)
--	or cast(f.[Clinic Start Time] as time) between cast(a.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)
--	or cast(f.[Clinic End Time] as time) between cast(a.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time))
--	and (cast(f.[Clinic End Time]  as time)!= cast(a.[Clinic Start Time] as time) 
--	and  (cast(f.[Clinic Start Time]  as time)!= cast(a.[Clinic Start Time] as time))
--	)
--	 and a.[Originating Process]!=f.[Originating Process]

--cliniccalendarotherentry
  left join Divisioncalendar h
 on a.[Clinic Date]=h.[Clinic Date]

and (cast(a.[Clinic Start Time] as time) between cast(h.[Clinic Start Time] as time) and cast(h.[Clinic End Time] as time)
	or cast(a.[Clinic End Time] as time) between cast(h.[Clinic Start Time] as time) and cast(h.[Clinic End Time] as time)
	or cast(h.[Clinic Start Time] as time) between cast(a.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)
	or cast(h.[Clinic End Time] as time) between cast(a.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)
	or ((cast(a.[Clinic Start Time] as time)=cast(h.[Clinic Start Time] as time)
	and cast(a.[Clinic End Time] as time)=cast(h.[Clinic End Time] as time) )) 
	and (cast(h.[Clinic End Time]  as time)!= cast(a.[Clinic Start Time] as time) 
	and  (cast(h.[Clinic Start Time]  as time)!= cast(a.[Clinic Start Time] as time)
	 
	)))
	  
 and a.Provider=h.[Provider or Room Only Name]
 and a.[Originating Process]!=h.[Originating Process]

 left join VW_Provider_Regular_Scheduler_Overlaps_Detail o on a.provider=o.[Req Provider] and a.[Clinic Date]=o.[Clinic Date]
 left join ERD_Dep_Report l on a.[DEP Name]=l.[Department Name]
   left join rad j
 on a.[Clinic Date]=j.[Clinic Date]

and (cast(a.[Clinic Start Time] as time) between cast(j.[Clinic Start Time] as time) and cast(j.[Clinic End Time] as time)
	or cast(a.[Clinic End Time] as time) between cast(j.[Clinic Start Time] as time) and cast(j.[Clinic End Time] as time)
	or cast(j.[Clinic Start Time] as time) between cast(a.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)
	or cast(j.[Clinic End Time] as time) between cast(a.[Clinic Start Time] as time) and cast(a.[Clinic End Time] as time)
	or ((cast(a.[Clinic Start Time] as time)=cast(j.[Clinic Start Time] as time)
	and cast(a.[Clinic End Time] as time)=cast(j.[Clinic End Time] as time) )) 
	and (cast(j.[Clinic End Time]  as time)!= cast(a.[Clinic Start Time] as time) 
	and  (cast(j.[Clinic Start Time]  as time)!= cast(a.[Clinic Start Time] as time)
	 
	)))
	and a.[Room Number] like '%'+j.[room number]+'%'
	and a.provider!=j.Provider

 )


 

 

 select * from [final] where ([Division Calendar]='no' or [RAD]='no' or [ROC]='no'  or [PRS Detail]='no' )
  
 and 
 [Clinic Date] not in (
 select [Holiday Date] from .[ERD_Enterprise_Holiday_List] )
 
 and  [Clinic Date]>(cast(getdate()-2 as date)) and 
 ([Division Calendar]='no' or  [PRS Detail]='no'  or ( rad='no'  and [Room Mandatory]='yes' and cancel='no')
 or ( roc='no'  and [Room Mandatory]='yes' and cancel='no')  
 or ( [Division Calendar]='yes'  and [Less 20  Percent]='yes' ) )
 and [Clinic calendar Org]='no' 
 --and [Less 20  Percent]='no'









GO
