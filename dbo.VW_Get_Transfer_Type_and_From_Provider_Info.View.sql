USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Get_Transfer_Type_and_From_Provider_Info]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_Get_Transfer_Type_and_From_Provider_Info] 
as
select * from(select 4 ID,'Hold Schedule to Regular Schedule' [Transfer Type],[Provider] [From Provider]
from Provider_Room_Hold_Schedule_grid
where provider in (select [Full Name] from [employee_Master] where --[Employee Status]='active' and
 [Employee Type] like '%Provider%' and isnull([User authentication],'')='No' --and getdate()>isnull([inactive date],'') 
and provider not in (
select [From Provider] from dbo.[2_59_Transfer Hold Schedule])
--and getdate()<= dateadd(day,7,cast(dateadd(dd,(select top 1 [Room hold schedule hold period] from V3_ERD.dbo.[ERD_Room_Hold_Period]),[inactive date]) as date))
)--and isnull([schedule frequency],'')='Recurring'
union
select 1 ID,'Regular Schedule to Hold Schedule' [Transfer Type],[Provider] [From Provider]
from Provider_Regular_Schedule_grid
where provider in (select [Full Name] from [employee_Master] where [Employee Status]='Inactive' and  isnull([Hold Rooms],'')='Yes'
and [Employee Type] like '%Provider%' --and isnull([User authentication],'')='No' --and getdate()>isnull([inactive date],'') 
and provider not in (select [From Provider] from  Transfer_Room_Hold_Schedule
union
select [From Provider] from dbo.[2_59_Transfer Hold Schedule])
--and getdate()<= dateadd(day,7,cast(dateadd(dd,(select top 1 [Room hold schedule hold period] from V3_ERD.dbo.[ERD_Room_Hold_Period]),[inactive date]) as date))
)--and isnull([schedule frequency],'')='Recurring'
union
select 2 ID,'Hold Schedule to Hold Schedule' [Transfer Type],[Provider] [From Provider]
from Provider_Room_Hold_Schedule_grid
where provider in (select [Full Name] from [employee_Master] where --[Employee Status]='active' and
 [Employee Type] like '%Provider%' and isnull([User authentication],'')='No' --and getdate()>isnull([inactive date],'') 
and provider not in (
select [From Provider] from dbo.[2_59_Transfer Hold Schedule])
--and getdate()<= dateadd(day,7,cast(dateadd(dd,(select top 1 [Room hold schedule hold period] from V3_ERD.dbo.[ERD_Room_Hold_Period]),[inactive date]) as date))
) --and isnull([schedule frequency],'')='Recurring'

union
select 3 ID,'Date Change for Hold Schedule' [Transfer Type],[Provider] [From Provider]
from Provider_Room_Hold_Schedule_grid
where provider in (select [Full Name] from [employee_Master] where [Employee Status]='Active' 
and [Employee Type] like '%Provider%' and isnull([User authentication],'')='No' --and getdate()>isnull([inactive date],'') 
and provider not in (
select [From Provider] from dbo.[2_59_Transfer Hold Schedule])
--and getdate()<= dateadd(day,7,cast(dateadd(dd,(select top 1 [Room hold schedule hold period] from V3_ERD.dbo.[ERD_Room_Hold_Period]),[inactive date]) as date))
) --and isnull([schedule frequency],'')='Recurring'
)x



GO
