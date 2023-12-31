USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Calendar_data1]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
create view [dbo].[VW_Calendar_data1] as  

selecT [Created On]
      ,[Originating Process]
      ,[Clinic Date]
      ,provider [Provider or Room Only Name]
      ,[Clinic Type]
      ,[Clinic Specialty]
      ,[Location]
      ,[Clinic Duration]
      ,[Clinic Start Time]
      ,[Clinic End Time]
      ,[Ranks]
      ,[Rooms Required]
      ,[Building]
      ,[Floor]
      ,[Wing]
      ,[Room Name]
      ,[Kezava Unique ID]
      ,[Employee Login ID]
      ,[Linked Clinic Name]
      ,[RowID]
      ,[Legends]
      ,[Color code]
      ,[Userid]
      ,[CalendarOrder]
      ,[Display in Calendar]
      ,[Room Number]
      ,[Suite]
      ,[Mode of Delivery]
      ,null [Stage]
      ,null [Schedule Type]
      ,0 [No of Appointments Scheduled] from [clinic_Caelndar_iprogress]
GO
