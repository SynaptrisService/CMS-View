USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Cancel_MDC_Clinic]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[VW_Cancel_MDC_Clinic] as
with [mdc value]
as
(
select  top 10000 [created on],[created by],[clinic date],isnull([MDC provider name],'Clinic')[MDC provider name]
,[Clinic notes],[Reason For Cancellation],[location]
,concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic Start Time],100),8)),7),' To ' ,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic End Time],100),8)),7))[Schedule Clinic Time]
,[division name],[Clinic Type]as [Host Division Name],[mdc clinic specialty]
,case when isnull([MDC provider name],'')<>'' then 'Provider'
else 'Clinic' end [MDC Detail] 
,CONCAT([clinic date],concat(RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic Start Time],100),8)),7),' To ' ,RIGHT('0'+LTRIM(RIGHT(CONVERT(varchar,[Clinic End Time],100),8)),7)),[location],[Clinic notes],[mdc clinic specialty])as[Unique]
from [Cancel_MDC_Clinic]  group by [clinic date],[mdc clinic specialty],[MDC provider name],[division name],[created on],[created by],[Clinic notes]
,[Reason For Cancellation],[location],[Clinic Type],[Clinic Start Time],[Clinic End Time]
order by [CLINIC DATE], [Clinic Start Time],[Clinic End Time],[division name]
),
[mdc Final] as
(
select b.* ,dense_rank() over(order by [Unique] ) RNo 
,row_number() over(partition by [Unique] order by [Unique] )[Sort]
from [mdc value] b
 )
select  [created on], [created by],[MDC provider name]
,case when [Sort]=1 then  [Clinic notes] else null end as [Clinic notes]
,case when [Sort]=1 then  [Schedule Clinic Time] else null end as [Schedule Clinic Time]
,case when [Sort]=1 then  [location] else null end as [location]
,case when [Sort]=1 then  [clinic date] else NUll end as [clinic date]
,[Reason For Cancellation],[division name],[Host Division Name],[mdc clinic specialty] from [mdc Final]


GO
