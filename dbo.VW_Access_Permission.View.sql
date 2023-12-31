USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Access_Permission]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[VW_Access_Permission] as 
WITH Access_Permission 
as

(
selecT  a.gru_user_seq_id user_seq_id ,c.usr_last_name+', '+c.usr_first_name [User Name],
d.[User Group],
--Case when [User Group] in ('Calendar Viewer','Clinic Delegate','Clinical Staffing Manager','Provider','Provider Delegate') then 'Calendar'
--	 when [User Group] in ('Division Approver') then 'Scheduler'
--	  when [User Group] in ('Executive Team') then 'Overview' 
--	    Else 'Scheduler' End
		  d.[Default screen][Default] 

,d.Module [Custom Application1], d.[sub module]  [Custom Sub Application1],d.Rank,a.gru_user_seq_id
from [gru_group_user] a
left join [grp_group] b on a.gru_group_seq_id=b.grp_group_seq_id 
Left join usr_user c on a.gru_user_seq_id=c.usr_user_seq_id
left join (select [First Name],[Last Name],eg.splitdata [Employee Group] 
 from employee_master f cross apply [fnSplitString](f.[Employee Group],';') eg) e
   on c.usr_first_name=e.[First Name] and c.usr_last_name=e.[Last Name]
LEFT join 
 V3_ERD.[dbo].[Employee_Group_Access]  d on e.[Employee Group]=ISNULL(d.[Employee Group] ,'')
 --where c.usr_last_name+', '+c.usr_first_name ='ProvDel17, Patty'
)
selecT DISTINCT a.user_seq_id,a.[User Name] 
,(SELECT top 1 isnull([User Group],'') from Access_Permission b where a.[User Name]=b. [User Name]  and isnull([Rank],'')!=''
 order by rank asc) [User Group]
,(SELECT top 1 isnull([Default],'') from Access_Permission b where a.[User Name]=b. [User Name] and isnull([Rank],'')!='' order by rank asc) [Default]  
,STUFF((SELECT distinct ';' + [Custom Application1] from Access_Permission b where a.[User Name]=b. [User Name]  FOR XML PATH ('')), 1, 1,'') [Module]
,STUFF((SELECT distinct ';' + [Custom Sub Application1] from Access_Permission b where a.[User Name]=b. [User Name]  FOR XML PATH ('')), 1, 1,'') [Sub Module] 

from Access_Permission  a where isnull([Rank],'')!='' 















GO
