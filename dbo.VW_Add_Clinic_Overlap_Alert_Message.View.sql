USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Add_Clinic_Overlap_Alert_Message]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE VIEW [dbo].[VW_Add_Clinic_Overlap_Alert_Message] 
AS

--selecT Distinct [Message] =STUFF((SELECT  distinct ''+ a.[Message] FROM Add_Clinic_SchType_Message a where 1=1 FOR XML PATH('')), 1, 0, '') 
--from  Add_Clinic_SchType_Message b


selecT Distinct
case when (select count(*) from Add_Clinic_time_Alert)>0 then 
(select top 1 [Message] from Add_Clinic_time_Alert) 
when (select count(*) from Add_Clinic_SchType_Message)>0 then  
 STUFF((SELECT  distinct ''+ a.[Message] FROM Add_Clinic_SchType_Message a where 1=1 and isnull([message],'')!=''  FOR XML PATH('')), 1, 0, '')  
 else 
 STUFF('The rooms you selected are no longer available. Please re-select rooms for your clinic(s)\n\n '+(SELECT distinct '' +  replace(replace([Message],'<Message>',''),'</Message>','') as [Message] FROM Add_Clinic_Hard_Block a 
 where 1=1 and isnull([message],'')!='' FOR XML PATH('')), 1, 0, '') end [Message]



GO
