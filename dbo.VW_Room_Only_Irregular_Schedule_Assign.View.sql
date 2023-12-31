USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Only_Irregular_Schedule_Assign]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















CREATE VIEW  [dbo].[VW_Room_Only_Irregular_Schedule_Assign] as
SELECT [Created On],[Created By],[Submitted By],[System Submitter Name],[Submitted On],[WF Status],[Record Modified By],[Record Modified On],[Modified Section]
,[Master System ID],[Schedule ID],[Schedule Type],[Schedule Frequency],[Employee Login ID],[Division Name],[Clinic Type],[Clinic Specialty]
,[Location],[Clinic ID],[Schedule Start Date],[Schedule End Date],[Recurring Schedule End Date],[Clinic Date],[Clinic Start Time],[Clinic End Time]
,[Work Days],[Clinic Schedule Week],[Clinic Hours Category],[Rooms Required],[Building],[Floor],[Wing],[Room Name],[Room Number],[Room Label],[Clinic Notes]
,[Originating Process],[Clinic Duration],[Schedule Updated On],[Clinic Schedule Notes],[Schedule Originating Date],[Kezava Unique ID],[Clinic Change Email Notification]
,[Schedule Change Email Notification],[MDC Clinic],[MDC Host Domain],[MDC Division Type],[MDC Clinic Template],[Schedule Interval],[Weekly Frequency]
,[Weekly Day of Week],[Date in Selected Months],[Selected Months for Date],[Date in Month Frequency],[Month Frequency for Date],[Week Number Selected Months]
,[Day of Week in Selected Months],[Selected Months for Day of Week],[Week Number Month Frequency],[Day of Week in Month Frequency],[Month Frequency for Day of Week]
,[Custom Clinic Dates],[Room Hours Exception Approval],[Exception Approval Status],[Exception Approval Comments],[Division Approval Required],[Division Approval Status]
,[Division Approval Comments],[EMR Update Status],[Schedule Confirmation Date],[Schedule Confirmation Notes],[Room Operations Support Required],[Display in Calendar]
,[Schedule Exception Approval],[Room Mandatory]
,[Custom Clinic Dates Task],[Weekly Frequency Task],[Weekly Day of Week Task],[Day of Week in Selected Months Task]
,[Week Number Selected Months Task],[Selected Months for Day of Week Task],[Day of Week in Month Frequency Task],[Week Number Month Frequency Task]
,[Month Frequency for Day of Week Task],[Clinic Start Time Task],[Clinic End Time Task],[Location Task],[Building Task],[Floor Task],[Wing Task],[Rooms Required Task]
,[Room Name Task],[Custom Clinic Dates Exception],[Weekly Frequency Exception],[Weekly Day of Week Exception],[Day of Week in Selected Months Exception]
,[Week Number Selected Months Exception],[Selected Months for Day of Week Exception],[Day of Week in Month Frequency Exception],[Week Number Month Frequency Exception]
,[Month Frequency for Day of Week Exception],[Clinic Start Time Exception],[Clinic End Time Exception],[Clinic Type Exception],[Clinic Specialty Exception]
,[Clinic Duration Exception],[Location Exception],[Room Name For Unused Days],[Room Unused Days],[Unused Days Exception Approval],[Exception Approval Required]
,[Room Name For Unused Days Task],[Room Unused Days Task],[Unused Days Exception Approval Task],[Clinic Hours Category Task],[Workspaces Required],[No of Participants]
,[Suite],[Participant Notes],[Suite Task],[Suite Exception] ,[Room Hold Expiry Date],[DEP Name],[Mode of Delivery],[Reference Number],[Room Only Schedule Provider]
FROM [dbo].[Room_Only_Irregular_Schedule]
--where [Provider] not in (select [Provider] 
--from [Kezava_DM_V3_Neurology].[dbo].[2_18_Provider Irregular Schedule] 
 --)











GO
