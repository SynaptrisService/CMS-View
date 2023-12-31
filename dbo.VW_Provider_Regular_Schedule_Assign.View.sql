USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Regular_Schedule_Assign]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[VW_Provider_Regular_Schedule_Assign] 
as
select distinct 
[Created On]      ,[Created By]      ,[Submitted By]      ,[System Submitter Name]      ,[Submitted On]      ,[WF Status]      ,[Record Modified By]      ,NULL [Record Modified On]      ,NULL [Modified Section]
      ,[Master System ID]      ,[Schedule ID]      ,[Schedule Type]      ,[Schedule Frequency]      ,[Provider]      ,[Employee Login ID]      ,[Division Name]      ,[Clinic Type]
      ,[Clinic Specialty]      ,[Location]      ,[Clinic ID]      ,[Schedule Start Date]      ,[Schedule End Date]      ,[Recurring Schedule End Date]      ,[Clinic Date]      ,[Clinic Start Time]
      ,[Clinic End Time]      ,[Work Days]      ,[Clinic Schedule Week]      ,[Clinic Hours Category]      ,[Rooms Required]      ,[Building]      ,[Floor]      ,[Wing]
      ,[Room Name]      ,[Room Number]      ,[Room Label]      ,[Clinic Notes]      ,[Originating Process]      ,[Clinic Duration]      ,[Schedule Updated On]      ,[Clinic Schedule Notes]
      ,[Schedule Originating Date]      ,[Kezava Unique ID]      ,[Clinic Change Email Notification]      ,[Schedule Change Email Notification]      ,[MDC Clinic]      ,[MDC Host Domain]
      ,[Room Hours Exception Approval]      ,[Exception Approval Status]      ,[Exception Approval Comments]      ,[Division Approval Required]      ,[Division Approval Status]      ,[Division Approval Comments]
      ,[EMR Update Status]      ,[Schedule Confirmation Date]      ,[Schedule Confirmation Notes]      ,[Room Operations Support Required]      ,[Display in Calendar]      ,[Schedule Exception Approval]
      ,[Room Mandatory]      ,[Clinic Start Time Task]      ,[Clinic End Time Task]      ,[Work Days Task]      ,[Clinic Schedule Week Task]      ,[Location Task]      ,[Building Task]
      ,[Floor Task]      ,[Wing Task]      ,[Room Name Task]      ,[Room Number Task]      ,[Rooms Required Task]      ,[Clinic Schedule Week Exception]      ,[Work Days Exception]
      ,[Location Exception]      ,[Clinic Type Exception]      ,[Clinic Specialty Exception]      ,[Clinic Duration Exception]      ,[Clinic Start Time Exception]      ,[Clinic End Time Exception]
      ,[Room Hold Expiry Date]      ,[Room Name For Unused Days]      ,[Room Unused Days]      ,[Unused Days Exception Approval]      ,[Exception Approval Required]      ,[Room Name For Unused Days Task]      ,[Room Unused Days Task]
      ,[Unused Days Exception Approval Task]      ,[Clinic Hours Category Task]      ,[Workspaces Required]      ,[No of Participants]      ,[Suite]      ,[Participant Notes]      ,[Suite Task]      ,[Suite Exception]
      ,[DEP Name]      ,[Mode of Delivery]      ,[Reference Number]
      ,case 
	  
	  when provider not in
 ( Select Distinct y.provider   from [Provider_Regular_Schedule_Grid] y  where y.[Schedule End Date]>getdate()
 and   d.provider=y.provider
 )  and [Schedule End Date]= ( Select max(y.[Schedule End Date])   from [Provider_Regular_Schedule_Grid] y  where y.[Schedule End Date]<getdate()
 and   d.provider=y.provider
 ) then 'Completed'when cast([Schedule End Date] as date)<=cast(getdate() as date) then 'View' else [ProcessStage] end [ProcessStage]
 from (SELECT [Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],[WF Status],[Record Modified By],''[Record Modified On]
,null [Modified Section],[Master System ID],[Schedule ID],case when  isnull([Schedule Type],'')='New' then 'Update' else 'New' end [Schedule Type],
--case when [Schedule Frequency]='Recurring' then 'Non Recurring' else [Schedule Frequency] end 
[Schedule Frequency]
,a.[Provider],[Employee Login ID],[Division Name],[Clinic Type],[Clinic Specialty],[Location],[Clinic ID],[Schedule Start Date]
,[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time],[Clinic End Time],[Work Days],[Clinic Schedule Week],[Clinic Hours Category]
,[Rooms Required],[Building],[Floor],[Wing],[Room Name],[Room Number],[Room Label],[Clinic Notes],[Originating Process],[Clinic Duration], [Schedule Updated On],[Clinic Schedule Notes]
,[Schedule Originating Date],[Kezava Unique ID],[Clinic Change Email Notification],[Schedule Change Email Notification]
,[MDC Clinic],[MDC Host Domain],[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments]
,[Division Approval Required],[Division Approval Status],[Division Approval Comments],[EMR Update Status]
,[Schedule Confirmation Date],[Schedule Confirmation Notes],[Room Operations Support Required],[Display in Calendar]
,[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task]
,[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task]
,[Room Name Task],[Room Number Task],[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception]
,[Clinic Type Exception],[Clinic Specialty Exception],[Clinic Duration Exception],[Clinic Start Time Exception]
,[Clinic End Time Exception],[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days]
,[Unused Days Exception Approval],[Exception Approval Required],[Room Name For Unused Days Task],[Room Unused Days Task]
,[Unused Days Exception Approval Task],[Clinic Hours Category Task],[Workspaces Required],[No of Participants]
,[Suite],[Participant Notes],[Suite Task],[Suite Exception]
,[DEP Name],[Mode of Delivery],[Reference Number],Case when A.provider=b.Provider then 'View' Else 'Completed'  end [ProcessStage]
FROM [Provider_Regular_Schedule_Grid] a
left join
(Select Distinct Provider from [2_28_Provider Regular Schedule]) b on a.Provider=b.Provider
--where [Provider] 
--not in
-- (
--  select [Provider] 
--  from [2_28_Provider Regular Schedule] 
-- )
union  
SELECT 
distinct [Created On],[Created By],[Submitted By],[System Submitter Name]
,[Submitted On],[WF Status],[Record Modified By],NULL [Record Modified On]
,NULL [Modified Section],[Master System ID],[Schedule ID],
case when  isnull([Schedule Type],'')='New' then 'Update' else 'New' end [Schedule Type],
--case when [Schedule Frequency]='Recurring' then 'Non Recurring' else [Schedule Frequency] end
[Schedule Frequency]
,[Provider],[Employee Login ID],[Division Name],[Clinic Type]
,[Clinic Specialty],[Location],[Clinic ID],[Schedule Start Date]
,[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time]
,[Clinic End Time],[Work Days],[Clinic Schedule Week],[Clinic Hours Category]
,[Rooms Required],[Building],[Floor],[Wing]
,[Room Name],[Room Number],[Room Label],[Clinic Notes]
,[Originating Process],[Clinic Duration],getdate() [Schedule Updated On],[Clinic Schedule Notes]
,[Schedule Originating Date],[Kezava Unique ID],[Clinic Change Email Notification],[Schedule Change Email Notification]
,[MDC Clinic],[MDC Host Domain],[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments]
,[Division Approval Required],[Division Approval Status],[Division Approval Comments],[EMR Update Status]
,[Schedule Confirmation Date],[Schedule Confirmation Notes],[Room Operations Support Required],[Display in Calendar]
,[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task]
,[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task]
,[Room Name Task],[Room Number Task],[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception]
,[Clinic Type Exception],[Clinic Specialty Exception],[Clinic Duration Exception],[Clinic Start Time Exception]
,[Clinic End Time Exception],[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days]
,[Unused Days Exception Approval],[Exception Approval Required],[Room Name For Unused Days Task],[Room Unused Days Task]
,[Unused Days Exception Approval Task],[Clinic Hours Category Task],[Workspaces Required],[No of Participants]
,[Suite],[Participant Notes],[Suite Task],[Suite Exception]
,[DEP Name],[Mode of Delivery],[Reference Number], [ProcessStage]
FROM [2_28_Provider Regular Schedule] 

  --where ProcessStage!='Create Schedule'--	In Progress

--  union
--  SELECT 
--[Created On],[Created By],[Submitted By],[System Submitter Name]
--,[Submitted On],[WF Status],[Record Modified By],[Record Modified On]
--,[Modified Section],[Master System ID],[Schedule ID],
--case when  isnull([Schedule Type],'')='New' then 'Update' else 'New' end [Schedule Type],
--case when [Schedule Frequency]='Recurring' then 'Non Recurring' else [Schedule Frequency] end[Schedule Frequency]
--,[Provider],[Employee Login ID],[Division Name],[Clinic Type]
--,[Clinic Specialty],[Location],[Clinic ID],[Schedule Start Date]
--,[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time]
--,[Clinic End Time],[Work Days],[Clinic Schedule Week],[Clinic Hours Category]
--,[Rooms Required],[Building],[Floor],[Wing]
--,[Room Name],[Room Number],[Room Label],[Clinic Notes]
--,[Originating Process],[Clinic Duration],getdate() [Schedule Updated On],[Clinic Schedule Notes]
--,[Schedule Originating Date],[Kezava Unique ID],[Clinic Change Email Notification],[Schedule Change Email Notification]
--,[MDC Clinic],[MDC Host Domain],[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments]
--,[Division Approval Required],[Division Approval Status],[Division Approval Comments],[EMR Update Status]
--,[Schedule Confirmation Date],[Schedule Confirmation Notes],[Room Operations Support Required],[Display in Calendar]
--,[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task]
--,[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task]
--,[Room Name Task],[Room Number Task],[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception]
--,[Clinic Type Exception],[Clinic Specialty Exception],[Clinic Duration Exception],[Clinic Start Time Exception]
--,[Clinic End Time Exception],[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days]
--,[Unused Days Exception Approval],[Exception Approval Required],[Room Name For Unused Days Task],[Room Unused Days Task]
--,[Unused Days Exception Approval Task],[Clinic Hours Category Task],[Workspaces Required],[No of Participants]
--,[Suite],[Participant Notes],[Suite Task],[Suite Exception]
--,[DEP Name],[Mode of Delivery],[Reference Number], 'Create Schedule_TASK' [ProcessStage]

--  FROM [2_28_Provider Regular Schedule_task] 
--  and provider not in (select provider  FROM [2_28_Provider Regular Schedule] 

--  where ProcessStage!='Create Schedule')
--  --where ProcessStage!='Create Schedule'
)d

GO
