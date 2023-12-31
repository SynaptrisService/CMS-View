USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_GET_Room_Hold_Providers]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_GET_Room_Hold_Providers]
as
select distinct Provider from (
select * from (select a.*,h.[Schedule Frequency] from (SELECT distinct [Full Name] as Provider,
case when [Full Name] in (select distinct Provider ActionStatus from Provider_Room_Hold_Schedule) 
then 'Update' else 'New' end [Schedule Type],[Employee Login ID] FROM Employee_Master
where [Employee Type]= 'Provider' and isnull([User Authentication],'')!='Yes') a 
left join (select 'Recurring' [Schedule Frequency] union select 'Non Recurring') H on 1=1
left join (
select provider, [Schedule Frequency] from .[dbo].[2_32_Provider Room Hold Schedule]
union
select provider, [Schedule Frequency] from Provider_Regular_Schedule) j
on a.Provider=j.Provider and h.[Schedule Frequency]=j.[Schedule Frequency]
where isnull(j.[Schedule Frequency],'')='') Z
)a
where provider not in
(
select provider from Provider_Regular_Schedule
union
select provider from .[dbo].[2_28_Provider Regular Schedule]
)

GO
