USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Cancel_Clinics]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--***** Script for SelectTopNRows command from SSMS  ******/
CREATE view [dbo].[VW_Cancel_Clinics] as
SELECT  [Created On],[Created By],[Submitted By],[System Submitter Name] ,[Submitted On],[WF Status]
 ,[Record Modified By] ,[Record Modified On] ,[Modified Section] ,[Master System ID]
 ,null [Schedule Type]  ,null [Schedule Frequency] ,[Provider] ,[Division Name] ,[Clinic Type] ,[Clinic Specialty]
 ,[Location] ,null [Clinic ID] ,[Clinic Date][Schedule Start Date] ,[Clinic Date][Schedule End Date] ,[Clinic Date][Recurring Schedule End Date]
 ,[Clinic Date] ,[Clinic Start Time] ,[Clinic End Time] ,null [Work Days] ,null [Clinic Schedule Week] ,[Clinic Hours Category]
 , Isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required]
 ,[Building] ,[Floor] ,[Wing] ,[Room Name] ,[Room Number] ,[Room Label] ,[Clinic Notes]
 ,[Originating Process] ,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Duration]
  ,null [Schedule Updated On] ,null[Clinic Schedule Notes] ,null [Schedule Originating Date]
 ,[Kezava Unique ID] ,null[Room Hold Expiry Date] ,null[Schedule Workflow Status] ,[Suite] ,null[Workspaces Required] ,[No of Participants]
 , null[ProcessStatus] ,null [ProcessStage] ,null [Wrok Flow Ststus] ,null[Backup Date]
  FROM [Cancel_Provider_Clinic] c
  union
  SELECT  [Created On],[Created By],[Submitted By],[System Submitter Name] ,[Submitted On],[WF Status]
 ,[Record Modified By] ,[Record Modified On] ,[Modified Section] ,[Master System ID]
 ,null [Schedule Type]  ,null [Schedule Frequency] ,[Provider] ,[Division Name] ,[Clinic Type] ,[Clinic Specialty]
 ,[Location] ,null [Clinic ID] ,[Clinic Date][Schedule Start Date] ,[Clinic Date][Schedule End Date] ,[Clinic Date][Recurring Schedule End Date]
 ,[Clinic Date] ,[Clinic Start Time] ,[Clinic End Time] ,null [Work Days] ,null [Clinic Schedule Week] ,[Clinic Hours Category]
 ,Isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required]
 ,[Building] ,[Floor] ,[Wing] ,[Room Name] ,[Room Number] ,nULL [Room Label] ,[Clinic Notes]
 ,[Originating Process] ,casT((DATEDIFF(MINUTE,CAST([Cancel start time] AS TIME),CAST([Cancel End time] AS TIME))) as float)/60  [Clinic Duration] ,null [Schedule Updated On] ,null[Clinic Schedule Notes] ,null [Schedule Originating Date]
 ,[Kezava Unique ID] ,null[Room Hold Expiry Date] ,null[Schedule Workflow Status] ,[Suite] ,null[Workspaces Required] ,[No of Participants]
 , null[ProcessStatus] ,null [ProcessStage] ,null [Wrok Flow Ststus] ,null[Backup Date]
  FROM [Shorten_Provider_Clinic] c
  union
  SELECT  [Created On],[Created By],[Submitted By],[System Submitter Name] ,[Submitted On],[WF Status]
 ,[Record Modified By] ,[Record Modified On] ,[Modified Section] ,[Master System ID]
 ,null [Schedule Type]  ,null [Schedule Frequency] ,[Room Only Schedule Provider][Provider] ,[Division Name] ,''[Clinic Type] ,''[Clinic Specialty]
 ,[Location] ,null [Clinic ID] ,[Clinic Date][Schedule Start Date] ,[Clinic Date][Schedule End Date] ,[Clinic Date][Recurring Schedule End Date]
 ,[Clinic Date] ,[Clinic Start Time] ,[Clinic End Time] ,null [Work Days] ,null [Clinic Schedule Week] ,[Clinic Hours Category]
 ,Isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required]
 ,[Building] ,[Floor] ,[Wing] ,[Room Name] ,[Room Number] ,[Room Label] ,[Clinic Notes]
 ,[Originating Process] ,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Duration] ,null [Schedule Updated On] ,null[Clinic Schedule Notes] ,null [Schedule Originating Date]
 ,[Kezava Unique ID] ,null[Room Hold Expiry Date] ,null[Schedule Workflow Status] ,[Suite] ,null[Workspaces Required] ,[No of Participants]
 , null[ProcessStatus] ,null [ProcessStage] ,null [Wrok Flow Ststus] ,null[Backup Date]
  FROM [Room_Only_Cancel] c
  union
  SELECT  [Created On],[Created By],[Submitted By],[System Submitter Name] ,[Submitted On],[WF Status]
 ,[Record Modified By] ,[Record Modified On] ,[Modified Section] ,[Master System ID]
 ,null [Schedule Type]  ,null [Schedule Frequency] ,[Provider] ,[Division Name] ,[Clinic Type] ,[Clinic Specialty]
 ,[Location] ,null [Clinic ID] ,[Clinic Date][Schedule Start Date] ,[Clinic Date][Schedule End Date] ,[Clinic Date][Recurring Schedule End Date]
 ,[Clinic Date] ,[Clinic Start Time] ,[Clinic End Time] ,null [Work Days] ,null [Clinic Schedule Week] ,[Clinic Hours Category]
 ,Isnull(LEN([Room Name]) - LEN(REPLACE([Room Name], ';', ''))+1,0) as [Rooms Required]
 ,[Building] ,[Floor] ,[Wing] ,[Room Name] ,[Room Number] ,[Room Label] ,[Clinic Notes]
 ,[Originating Process] ,casT((DATEDIFF(MINUTE,CAST([Clinic Start Time] AS TIME),CAST([Clinic End Time] AS TIME))) as float)/60  [Clinic Duration] ,null [Schedule Updated On] ,null[Clinic Schedule Notes] ,null [Schedule Originating Date]
 ,[Kezava Unique ID] ,null[Room Hold Expiry Date] ,null[Schedule Workflow Status] ,[Suite] ,null[Workspaces Required] ,[No of Participants]
 , null[ProcessStatus] ,null [ProcessStage] ,null [Wrok Flow Ststus] ,null[Backup Date]
  FROM [Cancel_Clinic] c







GO
