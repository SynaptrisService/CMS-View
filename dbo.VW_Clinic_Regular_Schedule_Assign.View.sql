USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Regular_Schedule_Assign]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[VW_Clinic_Regular_Schedule_Assign] as
select top 10000000 
[Created On]      ,[Created By]      ,[Submitted By]      ,[System Submitter Name]      ,[Submitted On]      ,[WF Status]      ,[Record Modified By]      ,[Record Modified On]
      ,[Modified Section]      ,[Master System ID]      ,[Schedule ID]     ,[Scheeudle Type]      ,[Schedule Frequency]      ,[Provider]      ,[Employee Login ID]      ,[Division Name]
      ,[Clinic Type]      ,[Clinic Specialty]      ,[Location]      ,[Clinic ID]      ,[Schedule Start Date]      ,[Schedule End Date]      ,[Recurring Schedule End Date]      ,[Clinic Date]
      ,[Clinic Start Time]    ,[Clinic End Time]      ,[Work Days]      ,[Clinic Schedule Week]      ,[Clinic Hours Category]      ,[Rooms Required]      ,[Building]      ,[Floor]
      ,[Wing]      ,[Room Name]      ,[Room Number]      ,[Room Label]      ,[Clinic Notes]      ,[Originating Process]      ,[Clinic Duration]      ,[Clinic Schedule Notes]
      ,[Schedule Originating Date]     ,[Clinic Change Email Notification]      ,[Schedule Change Email Notification]      ,[MDC Clinic]      ,[MDC Host Domain]      ,[Room Hours Exception Approval]
      ,[Exception Approval Status]      ,[Exception Approval Comments]      ,[Division Approval Required]      ,[Division Approval Status]      ,[Division Approval Comments]      ,[EMR Update Status]
      ,[Schedule Confirmation Date]      ,[Room Operations Support Required]      ,[Display in Calendar]      ,[Schedule Exception Approval]      ,[Room Mandatory]      ,[Clinic Start Time Task]
      ,[Work Days Task]      ,[Clinic Schedule Week Task]      ,[Location Task]      ,[Building Task]      ,[Floor Task]      ,[Wing Task]      ,[Room Name Task]      ,[Rooms Required Task]
      ,[Clinic Schedule Week Exception]      ,[Work Days Exception]      ,[Location Exception]      ,[Clinic Specialty Exception]      ,[Clinic Duration Exception]      ,[Clinic Start Time Exception]
      ,[Clinic End Time Exception]      ,[Schedule Updated On]      ,[Room Hold Expiry Date]      ,[Room Name For Unused Days]      ,[Room Unused Days]      ,[Unused Days Exception Approval]      ,[No of Participants]
      ,[Workspaces Required]      ,[Kezava Unique ID]      ,[Schedule Confirmation Notes]      ,[Clinic End Time Task]      ,[Room Number Task]      ,[Clinic Type Exception]      ,[Exception Approval Required]
      ,[Clinic Hours Category Task]      ,[Room Name For Unused Days Task]      ,[Room Unused Days Task]      ,[Unused Days Exception Approval Task]      ,[Suite]      ,[Participant Notes]
      ,[Suite Task]      ,[Suite Exception]      ,[DEP Name]      ,[Mode of Delivery]      ,[Reference Number] 
	  ,case
	  when [Clinic Specialty] not in
 ( Select Distinct y.[Clinic Specialty]   from [Clinic_Regular_Schedule_Grid] y  where y.[Schedule End Date]>getdate()
 and   a.[Clinic Specialty]=y.[Clinic Specialty]
 )  and [Schedule End Date]= ( Select max(y.[Schedule End Date])   from [Clinic_Regular_Schedule_Grid] y  where y.[Schedule End Date]<getdate()
 and   a.[Clinic Specialty]=y.[Clinic Specialty]
 ) then 'Completed'
 when cast([Schedule End Date] as date)<=cast(getdate() as date) then 'View' else [ProcessStage] end [ProcessStage]from(
SELECT distinct
[Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],
[WF Status],[Record Modified By],'' [Record Modified On],null [Modified Section],[Master System ID],
[Schedule ID],
case when  isnull([Schedule Type],'')='New' then 'Update' else 'New' end [Scheeudle Type],
--case when [Schedule Frequency]='Recurring' then 'Non Recurring' else 
[Schedule Frequency]  ,[Provider],[Employee Login ID],
[Division Name],[Clinic Type],x.[Clinic Specialty],[Location],[Clinic ID],x.[Schedule Start Date],
x.[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time],[Clinic End Time],
[Work Days],[Clinic Schedule Week],[Clinic Hours Category],[Rooms Required],[Building],
[Floor],[Wing],[Room Name],[Room Number],[Room Label],[Clinic Notes],[Originating Process],
[Clinic Duration],[Clinic Schedule Notes],[Schedule Originating Date],[Kezava Unique ID]
[Clinic Change Email Notification],[Schedule Change Email Notification],[MDC Clinic],[MDC Host Domain],
[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments],[Division Approval Required],
[Division Approval Status],[Division Approval Comments],[EMR Update Status],[Schedule Confirmation Date],[Schedule Confirmation Notes]
[Room Operations Support Required],[Display in Calendar],[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task]
[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task],[Room Name Task],[Room Number Task]
[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception],[Clinic Type Exception]
[Clinic Specialty Exception],[Clinic Duration Exception],[Clinic Start Time Exception],[Clinic End Time Exception],[Schedule Updated On],
[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days],[Unused Days Exception Approval],[No of Participants],[Workspaces Required]
,[Kezava Unique ID],[Schedule Confirmation Notes],[Clinic End Time Task],[Room Number Task],
[Clinic Type Exception],null [Exception Approval Required], null [Clinic Hours Category Task],null [Room Name For Unused Days Task],
null [Room Unused Days Task],null [Unused Days Exception Approval Task],[Suite],[Participant Notes],[Suite Task],[Suite Exception]
,

(select top 1 [DEP Name] from (select * from [Clinic_Regular_Schedule]
union 
select * from [Clinic_Regular_Schedule_Grid]
)z where z.[Clinic Type]=x.[Clinic Type] and z.[Clinic Specialty]=x.[Clinic Specialty]
and x.[Work Days]=z.[Work Days]  and x.[Clinic Schedule Week]=z.[Clinic Schedule Week] and x.[Clinic Start Time]=z.[Clinic Start Time] and x.[Clinic End Time]=z.[Clinic end Time]
and x.[Location]=z.[Location]
 )[DEP Name],[Mode of Delivery],[Reference Number]
,Case when concat(x.[Clinic Type],x.[Clinic Specialty])=b.[Clinic Specialty] 
 then 'View' Else 'Completed'  end [ProcessStage] 
FROM [Clinic_Regular_Schedule_Grid] x 
left join
(Select Distinct concat([Clinic Type],[Clinic Specialty])[Clinic Specialty]
from [2_15_Clinic Regular Schedule]) b on concat(x.[Clinic Type],x.[Clinic Specialty])=b.[Clinic Specialty]
--where [Provider] 
--not in
-- (
--  select [Provider] 
--  from .[dbo].[2_28_Provider Regular Schedule] 
-- )
 union
 SELECT 
[Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],
[WF Status],[Record Modified By],[Record Modified On],[Modified Section],[Master System ID],
[Schedule ID], case when  isnull([Schedule Type],'')='New' then 'Update' else 'New' end [Scheeudle Type],
--case when [Schedule Frequency]='Recurring' then 'Non Recurring' else [Schedule Frequency] end 
[Schedule Frequency],[Provider],[Employee Login ID],
[Division Name],[Clinic Type],[Clinic Specialty],[Location],[Clinic ID],[Schedule Start Date],
[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time],[Clinic End Time],
[Work Days],[Clinic Schedule Week],[Clinic Hours Category],[Rooms Required],[Building],
[Floor],[Wing],[Room Name],[Room Number],[Room Label],[Clinic Notes],[Originating Process],
[Clinic Duration],[Clinic Schedule Notes],[Schedule Originating Date],[Kezava Unique ID]
[Clinic Change Email Notification],[Schedule Change Email Notification],[MDC Clinic],[MDC Host Domain],
[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments],[Division Approval Required],
[Division Approval Status],[Division Approval Comments],[EMR Update Status],[Schedule Confirmation Date],[Schedule Confirmation Notes]
[Room Operations Support Required],[Display in Calendar],[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task]
[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task],[Room Name Task],[Room Number Task]
[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception],[Clinic Type Exception]
[Clinic Specialty Exception],[Clinic Duration Exception],[Clinic Start Time Exception],[Clinic End Time Exception],getdate()[Schedule Updated On],
[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days],[Unused Days Exception Approval],[No of Participants],[Workspaces Required]
,[Kezava Unique ID],[Schedule Confirmation Notes],[Clinic End Time Task],[Room Number Task],
[Clinic Type Exception],[Exception Approval Required],[Clinic Hours Category Task],[Room Name For Unused Days Task],
[Room Unused Days Task],[Unused Days Exception Approval Task],[Suite],[Participant Notes],[Suite Task],[Suite Exception]

,

(select top 1 [DEP Name] from .[dbo].[2_15_Clinic Regular Schedule]  z where z.[Clinic Type]=x.[Clinic Type] and z.[Clinic Specialty]=x.[Clinic Specialty]
and x.[Work Days]=z.[Work Days]  and x.[Clinic Schedule Week]=z.[Clinic Schedule Week] and x.[Clinic Start Time]=z.[Clinic Start Time] and x.[Clinic End Time]=z.[Clinic end Time]
and x.[Location]=z.[Location]
 )
[DEP Name],[Mode of Delivery],[Reference Number]
,[ProcessStage]

  FROM  [dbo].[2_15_Clinic Regular Schedule]  x

--  where ProcessStage!='Create Schedule'--	In Progress

  )a order by cast([Clinic Start Time] as time)



















GO
