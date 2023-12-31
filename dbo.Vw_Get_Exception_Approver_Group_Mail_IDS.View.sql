USE [V3_Neurology]
GO
/****** Object:  View [dbo].[Vw_Get_Exception_Approver_Group_Mail_IDS]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Vw_Get_Exception_Approver_Group_Mail_IDS]
as

select Distinct usr_e_mail as [Mail ids] from [Kezava_System_V3_Room-Management].dbo.usr_user a 
Left join[Kezava_System_V3_Room-Management].dbo.gru_group_user b on a.usr_user_seq_id=b.gru_user_seq_id
left join [Kezava_System_V3_Room-Management].dbo.grp_group c on b.gru_group_seq_id=c.grp_group_seq_id where c.grp_group_name ='Ambulatory Approver' 
and a.usr_status=1
GO
