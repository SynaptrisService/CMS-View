USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Only_Regular_Schedule_Assign]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VW_Room_Only_Regular_Schedule_Assign] as
select [Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],[WF Status],[Record Modified By],[Record Modified On],[Modified Section],[Master System ID],[Schedule ID]
,[Schedule Type],[Schedule Frequency],[Room Only Schedule Provider],[Division Name],[Location],[Clinic ID],[Schedule Start Date],[Schedule End Date],[Recurring Schedule End Date]
,[Clinic Date],[Clinic Start Time],[Clinic End Time],[Work Days],[Clinic Schedule Week],[Clinic Hours Category],[Rooms Required],[Building],[Floor],[Wing],[Room Name],[Room Number]
,[Room Label],[Clinic Notes],[Originating Process],[Clinic Duration],[Clinic Schedule Notes],[Schedule Originating Date],[Clinic Change Email Notification],[Schedule Change Email Notification]
,[MDC Clinic],[MDC Host Domain],[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments],[Division Approval Required],[Division Approval Status],[Division Approval Comments]
,[EMR Update Status],[Schedule Confirmation Date],[Room Operations Support Required],[Display in Calendar],[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Work Days Task]
,[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task],[Room Name Task],[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception]
,[Clinic Duration Exception],[Clinic Start Time Exception],[Clinic End Time Exception],[Schedule Updated On],[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days],[Unused Days Exception Approval]
,[No of Participants],[Workspaces Required],[Kezava Unique ID],[Schedule Confirmation Notes],[Clinic End Time Task],[Room Number Task],[Exception Approval Required],[Clinic Hours Category Task]
,[Room Name For Unused Days Task],[Room Unused Days Task],[Unused Days Exception Approval Task],[Suite],[Participant Notes],[Suite Task],[Suite Exception],[DEP Name],[Mode of Delivery]
,[Reference Number],
case  
when [Room Only Schedule Provider] not in
 ( Select Distinct y.[Room Only Schedule Provider]   from [Room_Only_Regular_Schedule_grid] y  where y.[Schedule End Date]>getdate()
 and   x.[Room Only Schedule Provider]=y.[Room Only Schedule Provider]
 )  and [Schedule End Date]= ( Select max(y.[Schedule End Date])   from [Room_Only_Regular_Schedule_grid] y  where y.[Schedule End Date]<getdate()
 and   x.[Room Only Schedule Provider]=y.[Room Only Schedule Provider]
 ) then 'Completed'
when cast([Schedule End Date] as date)<=cast(getdate() as date) then 'View' else [ProcessStage] end [ProcessStage]
,[Schedule Notification]
from (
SELECT 
[Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],
[WF Status],[Record Modified By],''[Record Modified On],null [Modified Section],[Master System ID],
[Schedule ID],
case when  isnull([Schedule Type],'')='New' then 'Update' else 'New' end [Schedule Type]
,
--case when [Schedule Frequency]='Recurring' then 'Non Recurring' else [Schedule Frequency] end 
[Schedule Frequency],a.[Room Only Schedule Provider],
[Division Name],[Location],[Clinic ID],[Schedule Start Date],
[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time],[Clinic End Time],
[Work Days],[Clinic Schedule Week],[Clinic Hours Category],[Rooms Required],[Building],
[Floor],[Wing],[Room Name],[Room Number],[Room Label],[Clinic Notes],[Originating Process],
[Clinic Duration],[Clinic Schedule Notes],[Schedule Originating Date],[Kezava Unique ID]
[Clinic Change Email Notification],[Schedule Change Email Notification],[MDC Clinic],[MDC Host Domain],
[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments],[Division Approval Required],
[Division Approval Status],[Division Approval Comments],[EMR Update Status],[Schedule Confirmation Date],[Schedule Confirmation Notes]
[Room Operations Support Required],[Display in Calendar],[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task]
[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task],[Room Name Task],[Room Number Task]
[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception],
[Clinic Duration Exception],[Clinic Start Time Exception],[Clinic End Time Exception],[Schedule Updated On],
[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days],[Unused Days Exception Approval],[No of Participants],[Workspaces Required]
,[Kezava Unique ID],[Schedule Confirmation Notes],[Clinic End Time Task],[Room Number Task],
null [Exception Approval Required], null [Clinic Hours Category Task],null [Room Name For Unused Days Task],
null [Room Unused Days Task],null [Unused Days Exception Approval Task],[Suite],[Participant Notes],[Suite Task],[Suite Exception],  [DEP Name]
      ,[Mode of Delivery]
      ,[Reference Number] ,Case when A.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] then 'View' Else 'Completed'  end  [ProcessStage]
	  ,case when isnull([Schedule Notification],'')='Yes' then 'Yes' Else 'No' End as [Schedule Notification]
FROM [Room_Only_Regular_Schedule_Grid] a
left join
(Select Distinct [Room Only Schedule Provider] from [2_50_Room Only Regular Schedule]) b on a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider]
union
SELECT 
[Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],
[WF Status],[Record Modified By],[Record Modified On],[Modified Section],[Master System ID],
[Schedule ID], case when  isnull([Schedule Type],'')='New' then 'Update' else 'New' end [Schedule Type]
,--case when [Schedule Frequency]='Recurring' then 'Non Recurring' else [Schedule Frequency] end
 [Schedule Frequency],[Room Only Schedule Provider],
[Division Name],[Location],[Clinic ID],[Schedule Start Date],
[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time],[Clinic End Time],
[Work Days],[Clinic Schedule Week],[Clinic Hours Category],[Rooms Required],[Building],
[Floor],[Wing],[Room Name],[Room Number],[Room Label],[Clinic Notes],[Originating Process],
[Clinic Duration],[Clinic Schedule Notes],[Schedule Originating Date],[Kezava Unique ID]
[Clinic Change Email Notification],[Schedule Change Email Notification],[MDC Clinic],[MDC Host Domain],
[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments],[Division Approval Required],
[Division Approval Status],[Division Approval Comments],[EMR Update Status],[Schedule Confirmation Date],[Schedule Confirmation Notes]
[Room Operations Support Required],[Display in Calendar],[Schedule Exception Approval],[Room Mandatory],[Clinic Start Time Task],[Clinic End Time Task]
[Work Days Task],[Clinic Schedule Week Task],[Location Task],[Building Task],[Floor Task],[Wing Task],[Room Name Task],[Room Number Task]
[Rooms Required Task],[Clinic Schedule Week Exception],[Work Days Exception],[Location Exception],
[Clinic Duration Exception],[Clinic Start Time Exception],[Clinic End Time Exception],getdate()[Schedule Updated On],
[Room Hold Expiry Date],[Room Name For Unused Days],[Room Unused Days],[Unused Days Exception Approval],[No of Participants],[Workspaces Required]
,[Kezava Unique ID],[Schedule Confirmation Notes],[Clinic End Time Task],[Room Number Task],
[Exception Approval Required],[Clinic Hours Category Task],[Room Name For Unused Days Task],
[Room Unused Days Task],[Unused Days Exception Approval Task],[Suite],[Participant Notes],[Suite Task],[Suite Exception]  ,[DEP Name]
      ,[Mode of Delivery]
      ,[Reference Number], ProcessStage,case when isnull([Schedule Notification],'')='Yes' then 'Yes' Else 'No' End as [Schedule Notification]
FROM [dbo].[2_50_Room Only Regular Schedule] )x



















GO
