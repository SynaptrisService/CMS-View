USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_MDC_Clinic_Schedule_and_Changes_All]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_MDC_Clinic_Schedule_and_Changes_All] 
AS 
select DISTINCT T.[Created On] ,T.[Created By],'MDC Regular Schedule' [Stage],[Originating Process], '' Legend, provider  ,T.[Clinic Type],T.[MDC Clinic Specialty] as[Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today' ,
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,0 [No of Appointments Scheduled] , choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
,0 [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year], '' [Reason For Cancellation],Location ,'' [Limit Type]
,[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null   [Kezava Employee ID],[Mode of Delivery],Isnull([DEP Name],'') [DEP Name],[No of Participants],
[MDC Host Division Name],T.[Division Name],S.[MDC Notification Status]
from [dbo].[MDC_Regular_Schedule_Detail] t LEFT JOIN Define_MDC_Division_Participants S 
ON T.[MDC Clinic Specialty]=S.[MDC Clinic Specialty] AND T.[Division Name]=S.[Division Name]
 where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])

UNION ALL

select DISTINCT  T.[Created On],T.[Created By] ,'Cancel' [Stage],[Originating Process],'canceled' Legend,provider  ,T.[Clinic Type],T.[MDC Clinic Specialty] AS [Clinic Specialty],[Clinic Duration], [Clinic Date] ,[Clinic Start Time] ,[Clinic End Time]
,casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60  [Clinic Hours] ,case when [Clinic Date]<=getdate() then 'Yes' else 'No' end 'Today',
case when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) > 240 then 2
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 0 then 0 
when DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time]) <= 240 then 1 end [Clinic Half Days]
,isnull([No of Appointments Scheduled],0) [No of Appointments Scheduled], choose(datepart(weekday,t.[Clinic Date]-1),t.[Clinic Date],t.[Clinic Date]-1,t.[Clinic Date]-2,t.[Clinic Date]-3,t.[Clinic Date]-4,t.[Clinic Date]-5,t.[Clinic Date]-6,t.[Clinic Date]-7) [Week start Date]
 , isnull([request notice period in weeks],0) [request notice period in weeks]
,case when Month([Clinic Date]) in (7,8,9) then 'Quarter 1 - July To September'
when Month([Clinic Date]) in (10,11,12) then 'Quarter 2 - October To December'
when Month([Clinic Date]) in (1,2,3) then 'Quarter 3 - January To March'
when Month([Clinic Date]) in (4,5,6) then  'Quarter 4 - April To June'
end [Financial Quarter month] ,case when Month([Clinic Date]) in (7,8,9) then 1
when Month([Clinic Date]) in (10,11,12) then 2
when Month([Clinic Date]) in (1,2,3) then 3
when Month([Clinic Date]) in (4,5,6) then  4
end [Financial Quarter month order],case when Month([Clinic Date]) >= 7 then 'FY' + right(year([Clinic Date])+1,2) 
when Month([Clinic Date]) <= 6 then 'FY' + right(year([Clinic Date]),2) end as [Financial Year],[Reason For Cancellation],Location,'' [Limit Type]
,''[Rooms Required] ,Building,Floor,wing,[Room Name] [Room Name],[Kezava Unique ID],null [Kezava Employee ID],Null [Mode of Delivery],NULL [DEP Name] ,[No of Participants],
[MDC Host Division Name],T.[Division Name],S.[MDC Notification Status]
from [dbo].Cancel_MDC_Clinic_Detail t LEFT JOIN Define_MDC_Division_Participants S 
ON T.[MDC Clinic Specialty]=S.[MDC Clinic Specialty] AND T.[Division Name]=S.[Division Name]
where [clinic date] not in (select [Holiday date] from [dbo].[ERD_Enterprise_Holiday_List])


GO
