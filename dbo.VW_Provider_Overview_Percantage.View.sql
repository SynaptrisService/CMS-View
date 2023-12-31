USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Overview_Percantage]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




 
CREATE view [dbo].[VW_Provider_Overview_Percantage] as 
select 
case when ToTPvrCnt=0 then 0 else round(([L86.5]*100.0)/ToTPvrCnt,0) end [L86.5Percent]
,case when ToTPvrCnt=0 then 0 else round(([86.5to90]*100.0)/ToTPvrCnt,0) end[86.5to90percent],
case when ToTPvrCnt=0 then 0 else 100-(round(([L86.5]*100.0)/ToTPvrCnt,0)+round(([86.5to90]*100.0)/ToTPvrCnt,0)) end G90percent,*
from
(
	select  sum(G90) G90,sum([86.5to90])[86.5to90],sum([L86.5]) [L86.5],max(ToTPvrCnt)ToTPvrCnt
	from 
	(
	select 
	case when percentage >= 90 then 1 else 0 end 'G90',
	case when percentage between 86.5 and 89 then 1 else 0 end '86.5to90',
	case when percentage < 86.5 then 1 else 0  end 'L86.5',(select count( provider) from VW_Provider_Overview_report_expected) ToTPvrCnt
	from
	 (
	 selecT Provider,[actual],Percentage  from VW_Provider_Overview_report_expected) x)y
)z




GO
