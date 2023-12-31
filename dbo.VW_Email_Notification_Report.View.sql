USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Email_Notification_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_Email_Notification_Report]
as
WITH Eamil_Template
AS
(
select  d.frm_wrkFlow_stageNo,
Case when b.frm_layout_form_name like '%Provider%' then 'Provider Schedule'
	 When b.frm_layout_form_name like '%MDC%' then 'MDC Schedule' Else 'Clinic Schedule' End Stage,
	 frm_layout_form_name,
Case When frm_mail_workflow_stage_name='Exception Approval' then 'Ambulatory Approval'
	 When frm_mail_workflow_stage_name='Update Schedule' then 'Schedule Update Work Flow Email' Else frm_mail_workflow_stage_name End as frm_mail_workflow_stage_name ,
Case when frm_mail_group_type ='Non-Existing' then 'Programmed Email'
	 when frm_mail_group_type ='Existing' then 'Group Email' Else frm_mail_group_type end frm_mail_group_type,
case when a.frm_mail_group_type='Non-Existing'  then '0' 
	 when (a.frm_mail_group_type='Existing' and isnull(frm_mail_user_seq_id,'')='')  then 'SELECT ALL' ELSE  frm_mail_user_seq_id end frm_mail_user_seq_id,
case when frm_mail_user_seq_id like '%USP_GET_EmailID_For_MDC_Provider_ProviderDelegates%' THEN 'Provider;Provider Delegates' 
	 when frm_mail_user_seq_id like '%USP_GET_EmailID_For_Covering_Provider%' THEN 'CoveringProvider'
	  when frm_mail_user_seq_id like '%USP_GET_EmailID_For_MDC_Provider_AND_Delegates%' THEN 'MDC Provider;Provider Delegates'
	 when frm_mail_user_seq_id like '%USP_Get_Generic_Specialty_Mail_ids%' THEN 'CreatedBY;Clinic Specialty'
	 when frm_mail_user_seq_id like '%USP_Get_MDC_Guest_Division_Coordinator_MailID%' THEN 'Guest Division Schedule Coordinator' 
	 when (a.frm_mail_group_type='Non-Existing' and frm_mail_user_seq_id like '%Employee_Master%') THEN 'Requestor' else c.grp_group_name end as [Grp_group_Name],
Case When a.frm_mail_report_type='PDF' THEN 'Yes' Else 'No' End as [PDF Attached]  
from dbo.fd_template_mails a
inner join dbo.fd_template_layout b on b.frm_layout_seq_id=a.frm_mail_layout_seq_id 
left JOIN DBO.grp_group C ON A.frm_mail_group_seq_id= C.grp_group_seq_id 
left join dbo.fd_template_work_flow d on b.frm_layout_seq_id=d.frm_wrkflow_layout_seq_id 
and d.frm_wrkflow_operator=a.frm_mail_workflow_stage_name WHERE a.frm_mail_group_type in ('Non-Existing','Existing') 
AND b.frm_layout_form_name in ('Provider Regular Schedule','Clinic Regular Schedule','Cancel Provider Clinic','Add Provider Clinic'
,'MDC Regular Schedule','Cancel MDC Clinic','Shorten Provider Clinic','Edit Provider Clinic Specialty','Cancel Clinic'
,'Limit Provider Schedule','Limit Clinic Schedule','Add Clinic','Shorten Clinic','Room Only Regular Schedule'
,'Provider Room Hold Schedule','Cancel Room Only Schedule','Add Room Only Schedule','Limit Room Only Schedule','Shorten Room Only Schedule')
and isnull(d.frm_wrkFlow_stageNo,'')!=''
UNION
select 1,'Provider Schedule','Provider Regular Schedule','Create Schedule','Work Flow Step Mail','0','Schedule Creator','No' 
UNION
select 1,'Provider Schedule','Provider Regular Schedule','Create Assign Task','For Room Assignment Task','0','Ambulatory Room Operations','No' 
UNION
select 2,'Provider Schedule','Provider Regular Schedule','Review Schedule','Work Flow Step Mail','0','Schedule Reviewer','No' 
UNION
select 3,'Provider Schedule','Provider Regular Schedule','Division Approval','Work Flow Step Mail','0','Division Approver','No' 
UNION
select 4,'Provider Schedule','Provider Regular Schedule','Ambulatory Approval','Work Flow Step Mail','0','Ambulatory Approver','No' 
UNION
select 1,'MDC Schedule','MDC Regular Schedule','Create Schedule','Work Flow Step Mail','0','MDC Schedule Creator','No' 
UNION
select 1,'MDC Schedule','MDC Regular Schedule','Create Schedule','For Room Assignment Task','0','Ambulatory Room Operations','No' 
UNION
select 2,'MDC Schedule','MDC Regular Schedule','Review Schedule','Work Flow Step Mail','0','MDC Schedule Reviewer','No' 
UNION
select 3,'MDC Schedule','MDC Regular Schedule','Division Approval','Work Flow Step Mail','0','Division Approver','No' 
UNION
select 4,'MDC Schedule','MDC Regular Schedule','Ambulatory Approval','Work Flow Step Mail','0','MDC Schedule Coordinator','No' 
UNION
select 1,'Clinic Schedule','Clinic Regular Schedule','Create Schedule','Work Flow Step Mail','0','Schedule Creator','No' 
UNION
select 1,'Clinic Schedule','Clinic Regular Schedule','Create Schedule','For Room Assignment Task','0','Ambulatory Room Operations','No' 
UNION
select 2,'Clinic Schedule','Clinic Regular Schedule','Review Schedule','Work Flow Step Mail','0','Schedule Reviewer','No' 
UNION
select 3,'Clinic Schedule','Clinic Regular Schedule','Division Approval','Work Flow Step Mail','0','Division Approver','No' 
UNION
select 4,'Clinic Schedule','Clinic Regular Schedule','Ambulatory Approval','Work Flow Step Mail','0','Schedule Coordinator','No'
UNION
select 1,'Room Only Schedule','Room Only Regular Schedule','Create Schedule','Work Flow Step Mail','0','Room Only Schedule Creator','No' 
UNION
select 1,'Room Only Schedule','Room Only Regular Schedule','Create Schedule','For Room Assignment Task','0','Ambulatory Room Operations','No' 
UNION
select 2,'Room Only Schedule','Room Only Regular Schedule','Review Schedule','Work Flow Step Mail','0','Room Only Schedule Reviewer','No' 
UNION
select 3,'Room Only Schedule','Room Only Regular Schedule','Division Approval','Work Flow Step Mail','0','Division Approver','No' 
UNION
select 4,'Room Only Schedule','Room Only Regular Schedule','Ambulatory Approval','Work Flow Step Mail','0','Room Only Schedule Confirmer','No'
UNION
select 1,'Room Only Schedule','Shorten Room Only Schedule','Request Shorten Clinic','(>= 8 Weeks OR <= 2 Hours);Work Flow Step Mail','0','Room Only Schedule Coordinator','No' ---Generic Clinic
UNION
select 1,'Room Only Schedule','Shorten Room Only Schedule','Request Shorten Clinic','(< 8 Weeks and > 2 Hours);Work Flow Step Mail','0','Division Approver','No' ---Generic Clinic
UNION
select 2,'Room Only Schedule','Shorten Room Only Schedule','Approve Shorten Clinic','Work Flow Step Mail','0','Room Only Schedule Coordinator','No' ---Generic Clinic
UNION
select 1,'Room Only Schedule','Cancel Room Only Schedule','Request Cancellation','(>= 8 Weeks);Work Flow Step Mail','0','Room Only Schedule Coordinator','No'
UNION
select 1,'Room Only Schedule','Cancel Room Only Schedule','Request Cancellation','(< 8 Weeks);Work Flow Step Mail','0','Division Approver','No'
UNION
select 2,'Room Only Schedule','Cancel Room Only Schedule','Approve Cancellation','Work Flow Step Mail','0','Room Only Schedule Coordinator','No'
UNION
select 1,'Room Hold Schedule','Provider Room Hold Schedule','Create Schedule','Work Flow Step Mail','0','Schedule Creator','No' 
UNION
select 1,'Room Hold Schedule','Provider Room Hold Schedule','Create Schedule','For Room Assignment Task','0','Ambulatory Room Operations','No' 
UNION
select 2,'Room Hold Schedule','Provider Room Hold Schedule','Review Schedule','Work Flow Step Mail','0','Schedule Reviewer','No' 
UNION
select 3,'Room Hold Schedule','Provider Room Hold Schedule','Division Approval','Work Flow Step Mail','0','Division Approver','No' 
UNION
select 4,'Room Hold Schedule','Provider Room Hold Schedule','Ambulatory Approval','Work Flow Step Mail','0','Schedule Coordinator','No'
UNION
select 1,'Provider Schedule','Add Provider Clinic','Request Add Clinic','Work Flow Step Mail','0','Schedule Creator','No' 
UNION
select 1,'Provider Schedule','Add Provider Clinic','Request Add Clinic','For Room Assignment Task','0','Ambulatory Room Operations','No' 
UNION
select 2,'Provider Schedule','Add Provider Clinic','Review Add Clinic','Work Flow Step Mail','0','Schedule Reviewer','No'
UNION
select 3,'Provider Schedule','Add Provider Clinic','Ambulatory Approval','Work Flow Step Mail','0','Ambulatory Approval','No'
UNION
select 1,'Clinic Schedule','Add Clinic','Add Clinic','Work Flow Step Mail','0','Schedule Creator','No' ---Generic Clinic
UNION
select 1,'Clinic Schedule','Add Clinic','Add Clinic','For Room Assignment Task','0','Ambulatory Room Operations','No' 
UNION
select 2,'Clinic Schedule','Add Clinic','Review Add Clinic','Work Flow Step Mail','0','Schedule Reviewer','No' ---Generic Clinic
UNION
select 3,'Clinic Schedule','Add Clinic','Ambulatory Approval','Work Flow Step Mail','0','Ambulatory Approval','No' ---Generic Clinic
UNION
select 1,'Provider Schedule','Shorten Provider Clinic','Request Shorten Clinic','(>= 8 Weeks OR <= 2 Hours);Work Flow Step Mail','0','Schedule Coordinator' ,'No'
UNION
select 1,'Provider Schedule','Shorten Provider Clinic','Request Shorten Clinic','(< 8 Weeks and > 2 Hours);Work Flow Step Mail','0','Division Approver','No'
UNION
select 2,'Provider Schedule','Shorten Provider Clinic','Approve Shorten Clinic','Work Flow Step Mail','0','Schedule Coordinator','No'
UNION
select 1,'Clinic Schedule','Shorten Clinic','Request Shorten','(>= 8 Weeks OR <= 2 Hours);Work Flow Step Mail','0','Schedule Coordinator','No' ---Generic Clinic
UNION
select 1,'Clinic Schedule','Shorten Clinic','Request Shorten','(< 8 Weeks and > 2 Hours);Work Flow Step Mail','0','Division Approver','No' ---Generic Clinic
UNION
select 2,'Clinic Schedule','Shorten Clinic','Approve Shorten','Work Flow Step Mail','0','Schedule Coordinator','No' ---Generic Clinic
UNION
select 1,'Provider Schedule','Limit Provider Schedule','Request Limit Schedule','Work Flow Step Mail','0','Schedule Coordinator','No'
UNION
select 1,'Clinic Schedule','Limit Clinic Schedule','Request Limit Schedule','Work Flow Step Mail','0','Schedule Coordinator','No' ---Generic Clinic
UNION
select 1,'Provider Schedule','Cancel Provider Clinic','Request Cancellation','(>= 8 Weeks);Work Flow Step Mail','0','Schedule Coordinator','No'
UNION
select 1,'Provider Schedule','Cancel Provider Clinic','Request Cancellation','(< 8 Weeks);Work Flow Step Mail','0','Division Approver','No'
UNION
select 2,'Provider Schedule','Cancel Provider Clinic','Approve Cancellation','Work Flow Step Mail','0','Schedule Coordinator','No'
UNION
select 1,'Clinic Schedule','Cancel Clinic','Request Cancellation','(>= 8 Weeks);Work Flow Step Mail','0','Schedule Coordinator','No' ---Generic Clinic
UNION
select 2,'Clinic Schedule','Cancel Clinic','Request Cancellation','(< 8 Weeks);Work Flow Step Mail','0','Division Approver','No' ---Generic Clinic
UNION
select 2,'Clinic Schedule','Cancel Clinic','Approve Cancellation','Work Flow Step Mail','0','Division Approver','No' ---Generic Clinic
UNION
select 1,'Provider Schedule','Edit Provider Clinic Specialty','Request Edit Clinic','Work Flow Step Mail','0','Schedule Coordinator','No'
UNION
select 1,'MDC Schedule','Cancel MDC Clinic','Request Cancellation','(>= 8 Weeks);Work Flow Step Mail','0','MDC Schedule Coordinator','No' ---Generic Clinic
UNION
select 1,'MDC Schedule','Cancel MDC Clinic','Request Cancellation','(< 8 Weeks);Work Flow Step Mail','0','Division Approver','No' ---Generic Clinic
UNION
select 2,'MDC Schedule','Cancel MDC Clinic','Approve Cancellation','Work Flow Step Mail','0','MDC Schedule Coordinator','No' ---Generic Clinic
) 
,
User_Split
AS
(
select a.*,b.usr_e_mail from Eamil_Template a cross apply dbo.fnSplitString(a.frm_mail_user_seq_id,',') c
left join [dbo].usr_user b on cast(b.usr_user_seq_id as NVARCHAR(max))=cast(c.splitdata as NVARCHAR(MAX))
where a.frm_mail_user_seq_id not in ('0','SELECT ALL') AND ISNULL(B.usr_status,0)=1
UNION 
select a.[frm_wrkFlow_stageNo],a.Stage, a.[frm_layout_form_name],a.[frm_mail_workflow_stage_name],a.[frm_mail_group_type],a.[frm_mail_user_seq_id],a.[Grp_group_Name],a.[PDF Attached],b.[usr_e_mail]
from 
	(
	select a.* from Eamil_Template a where a.frm_mail_user_seq_id in ('0', 'SELECT ALL'))a
	LEFT join (select distinct a.grp_group_name,c.usr_e_mail,c.usr_user_seq_id 
	from dbo.grp_group a left join dbo.gru_group_user b on a.grp_group_seq_id=b.gru_group_seq_id
	left join dbo.usr_user c on b.gru_user_seq_id=c.usr_user_seq_id 
	where a.grp_group_name in ('Clinic Delegate','Clinical Staffing Manager','Division Approver','Guest Division Schedule Coordinator',
	'MDC Delegate','MDC Schedule Coordinator','Room Only Schedule Confirmer','Room Only Schedule Coordinator','Room Only Schedule Reviewer',
	'Schedule Confirmer','Schedule Coordinator','Schedule Reviewer','Scheduling Center','Room Only Schedule Creator','Schedule Creator')
	and isnull(c.usr_e_mail,'')!='' AND ISNULL(C.usr_status,0)=1) b on a.grp_group_name=b.grp_group_name
	UNION 
	select a.[frm_wrkFlow_stageNo],a.Stage, a.[frm_layout_form_name],a.[frm_mail_workflow_stage_name],a.[frm_mail_group_type],a.[frm_mail_user_seq_id],a.[Grp_group_Name],a.[PDF Attached],b.[usr_e_mail]
	from 
	(
	select a.* from Eamil_Template a where a.frm_mail_user_seq_id in ('0', 'SELECT ALL'))a
	LEFT join (select distinct a.grp_group_name,c.usr_e_mail,c.usr_user_seq_id 
	from dbo.Roomsysdb_grp_group a left join dbo.Roomsysdb_gru_group_user b on a.grp_group_seq_id=b.gru_group_seq_id
	left join dbo.Roomsysdb_usr_user c on b.gru_user_seq_id=c.usr_user_seq_id 
	where a.grp_group_name in ('Ambulatory Approver','Ambulatory Room Operations')
	 and isnull(c.usr_e_mail,'')!=''AND ISNULL(C.usr_status,0)=1) b on a.grp_group_name=b.grp_group_name
)  

SELECT distinct (select top 1 com_company_name from dbo.com_company where com_company_seq_id=1) 
as [Company Name],a.frm_wrkFlow_stageNo As [Mail Seq Id]
,a.Stage
,Case 
when A.frm_layout_form_name ='Provider Regular Schedule' then 1
when A.frm_layout_form_name ='Irregular Provider Schedule' then 2
when A.frm_layout_form_name ='Add Provider Clinic' then 3
when A.frm_layout_form_name ='Cancel Provider Clinic' then 4
when A.frm_layout_form_name ='Shorten Provider Clinic' then 5
when A.frm_layout_form_name ='Limit Provider Schedule' then 6
when A.frm_layout_form_name ='Edit Provider Clinic Specialty' then 7
when A.frm_layout_form_name ='Clinic Regular Schedule' then 8
when A.frm_layout_form_name ='Irregular Clinic Schedule' then 9
when A.frm_layout_form_name ='Add Clinic' then 10
when A.frm_layout_form_name ='Cancel Clinic' then 11
when A.frm_layout_form_name ='Shorten Clinic' then 12
when A.frm_layout_form_name ='Limit Clinic Schedule' then 13
when A.frm_layout_form_name ='MDC Regular Schedule' then 14
when A.frm_layout_form_name ='Cancel MDC Clinic' then 15
when A.frm_layout_form_name ='Room Only Regular Schedule' then 16
when A.frm_layout_form_name ='Add Room Only Schedule' then 17
when A.frm_layout_form_name ='Cancel Room Only Schedule' then 18
when A.frm_layout_form_name ='Shorten Room Only Schedule' then 19
when A.frm_layout_form_name ='Limit Room Only Schedule' then 20
when A.frm_layout_form_name ='Provider Room Hold Schedule' then 21 Else A.frm_layout_form_name End [Process Order]
,A.frm_layout_form_name as [Process Name],A.frm_mail_workflow_stage_name as [WorkFlow Stage Name],Isnull(A.frm_mail_group_type,'') as [Email Group Type],ISNULL(A.grp_group_name,'') as [Group Name]
,Isnull(STUFF((select DISTINCT ';'+ c.usr_e_mail from User_Split c where a.grp_group_name=c.grp_group_name 
and a.frm_layout_form_name=c.frm_layout_form_name and a.Stage=c.Stage  for XML PATH ('')),1,1,''),'') as [Email Send To]
,[PDF Attached]
FROM User_Split A



GO
