USE [V3_Neurology]
GO
/****** Object:  View [dbo].[vw_Schedule_change_detail_report]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_Schedule_change_detail_report]
as
----------------------Provider Regular Schedule ---------------------
Select  a.[Schedule Updated On] as [Created or Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created or Modified By],
a.[Originating Process] as [Schedule Type], 'Add' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from provider_regular_schedule a with (nolock) 
where isnull([Location] ,'')!='' and not exists (Select '' from [Provider_Regular_Schedule_History] b with (nolock)  inner join
		(select [Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Provider_Regular_Schedule_History] with (nolock)  group by [Provider])c on  
b.[Provider]=c.[Provider] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.Provider=b.Provider) 
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
Union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Remove' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from [Provider_Regular_Schedule_History] a with (nolock)  inner join
		(select [Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Provider_Regular_Schedule_History] with (nolock)  group by [Provider])c on  
a.[Provider]=c.[Provider] and a.[Schedule Updated On]=c.[Schedule Updated On] 
where isnull([Location] ,'')!='' and not exists (Select '' from provider_regular_schedule b with (nolock)  where a.Provider=b.Provider and a.[Clinic Schedule Week]=b.[Clinic Schedule Week]
and a.[Work Days]=b.[Work Days] and a.[Location]=b.Location and a.[Clinic Hours Category]=b.[Clinic Hours Category])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Modified' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from provider_regular_schedule a with (nolock)  
where isnull([Location] ,'')!='' and exists (Select '' from [Provider_Regular_Schedule_History] b with (nolock)  inner join
		(select [Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Provider_Regular_Schedule_History] with (nolock)  group by [Provider])c on  
b.[Provider]=c.[Provider] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.Provider=b.Provider and (a.[Clinic Schedule Week]!=b.[Clinic Schedule Week] 
or a.[Clinic Specialty]!=b.[Clinic Specialty] or a.[Work Days]!=b.[Work Days] or a.[Location]!=b.Location or a.[Clinic Hours Category]!=b.[Clinic Hours Category])
or a.[Building]!=b.[Building] or a.[Floor]!=b.[Floor] or a.[Suite]!=b.[Suite] and a.[DEP Name]!=b.[DEP Name])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
UNION ALL
----------------------Clinic Regular Schedule ---------------------
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Add' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from Clinic_regular_schedule a  with (nolock) 
where isnull([Location] ,'')!='' and not exists (Select '' from [Clinic_Regular_Schedule_History] b with (nolock) inner join
		(select [Clinic Specialty], max([Schedule Updated On]) [Schedule Updated On] from  [Clinic_regular_schedule_History] with (nolock)  group by [Clinic Specialty])c on  
b.[Clinic Specialty]=c.[Clinic Specialty] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.[Clinic Specialty]=b.[Clinic Specialty]) 
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
Union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Remove' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from [Clinic_Regular_Schedule_History] a with (nolock)  inner join
		(select [Clinic Specialty], max([Schedule Updated On]) [Schedule Updated On] from  [Clinic_Regular_Schedule_History] with (nolock)  group by [Clinic Specialty])c on  
a.[Clinic Specialty]=c.[Clinic Specialty] and a.[Schedule Updated On]=c.[Schedule Updated On] 
where isnull([Location] ,'')!='' and not exists (Select '' from Clinic_Regular_Schedule b with (nolock)  where a.[Clinic Specialty]=b.[Clinic Specialty] and a.[Clinic Schedule Week]=b.[Clinic Schedule Week]
and a.[Work Days]=b.[Work Days] and a.[Location]=b.Location and a.[Clinic Hours Category]=b.[Clinic Hours Category])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Modified' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from [Clinic_Regular_Schedule] a with (nolock)  
where isnull([Location] ,'')!='' and exists (Select '' from [Clinic_Regular_Schedule_History] b with (nolock)  inner join
		(select [Clinic Specialty], max([Schedule Updated On]) [Schedule Updated On] from  [Clinic_Regular_Schedule_History] with (nolock)  group by [Clinic Specialty])c on  
b.[Clinic Specialty]=c.[Clinic Specialty] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.[Clinic Specialty]=b.[Clinic Specialty] and (a.[Clinic Schedule Week]!=b.[Clinic Schedule Week] 
or a.[Work Days]!=b.[Work Days] or a.[Location]!=b.Location or a.[Clinic Hours Category]!=b.[Clinic Hours Category])
or a.[Building]!=b.[Building] or a.[Floor]!=b.[Floor] or a.[Suite]!=b.[Suite] and a.[DEP Name]!=b.[DEP Name])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
UNION ALL

----------------------Provider Room Hold Schedule ---------------------
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Add' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from Provider_Room_Hold_Schedule a with (nolock) 
where isnull([Location] ,'')!='' and not exists (Select '' from [Provider_Room_Hold_Schedule_History] b with (nolock)  inner join
		(select [Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Provider_Room_Hold_Schedule_History] with (nolock)  group by [Provider])c on  
b.[Provider]=c.[Provider] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.Provider=b.Provider) 
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
Union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Remove' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from [Provider_Room_Hold_Schedule_History] a with (nolock)  inner join
		(select [Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Provider_Room_Hold_Schedule_History] with (nolock)  group by [Provider])c on  
a.[Provider]=c.[Provider] and a.[Schedule Updated On]=c.[Schedule Updated On] 
where isnull([Location] ,'')!='' and not exists (Select '' from Provider_Room_Hold_Schedule b with (nolock)  where a.Provider=b.Provider and a.[Clinic Schedule Week]=b.[Clinic Schedule Week]
and a.[Work Days]=b.[Work Days] and a.[Location]=b.Location and a.[Clinic Hours Category]=b.[Clinic Hours Category])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Modified' as [Change Type], a.[Division Name] as[Division], a.[Provider], a.[Clinic Type], a.[Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from Provider_Room_Hold_Schedule a  with (nolock) 
where isnull([Location] ,'')!='' and exists (Select '' from [Provider_Room_Hold_Schedule_History] b with (nolock)  inner join
		(select [Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Provider_Room_Hold_Schedule_History] with (nolock)  group by [Provider])c on  
b.[Provider]=c.[Provider] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.Provider=b.Provider and (a.[Clinic Schedule Week]!=b.[Clinic Schedule Week] 
or a.[Clinic Specialty]!=b.[Clinic Specialty] or a.[Work Days]!=b.[Work Days] or a.[Location]!=b.Location or a.[Clinic Hours Category]!=b.[Clinic Hours Category])
or a.[Building]!=b.[Building] or a.[Floor]!=b.[Floor] or a.[Suite]!=b.[Suite] and a.[DEP Name]!=b.[DEP Name])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
UNION ALL

----------------------Room only Regular Schedule ---------------------
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Add' as [Change Type], a.[Division Name] as[Division], a.[Room Only Schedule Provider] [Provider], Null as [Clinic Type], Null as [Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from Room_Only_Regular_Schedule a with (nolock) 
where isnull([Location] ,'')!='' and not exists (Select '' from [Room_Only_Regular_Schedule_History] b with (nolock)  inner join
		(select [Room Only Schedule Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Room_Only_Regular_Schedule_History] with (nolock)  group by [Room Only Schedule Provider])c on  
b.[Room Only Schedule Provider]=c.[Room Only Schedule Provider] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider]) 
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
Union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Remove' as [Change Type], a.[Division Name] as[Division], a.[Room Only Schedule Provider] as [Provider], null as[Clinic Type], null [Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from [Room_Only_Regular_Schedule_History] a with (nolock)  inner join
		(select [Room Only Schedule Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Room_Only_Regular_Schedule_History] with (nolock)  group by [Room Only Schedule Provider])c on  
a.[Room Only Schedule Provider]=c.[Room Only Schedule Provider] and a.[Schedule Updated On]=c.[Schedule Updated On] 
where isnull([Location] ,'')!='' and not exists (Select '' from Room_Only_Regular_Schedule b with (nolock)  where a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider] and a.[Clinic Schedule Week]=b.[Clinic Schedule Week]
and a.[Work Days]=b.[Work Days] and a.[Location]=b.Location and a.[Clinic Hours Category]=b.[Clinic Hours Category])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()
union all
Select  a.[Schedule Updated On] as [Created/Modified On], Case when isnull(a.[System Submitter Name],'')='' then a.[Created By] else  a.[System Submitter Name] end  [Created/Modified By],
a.[Originating Process] as [Schedule Type], 'Modified' as [Change Type], a.[Division Name] as[Division], a.[Room Only Schedule Provider] as[Provider], null as [Clinic Type], null as [Clinic Specialty],
a.[Clinic Schedule Week] as [Week], a.[Work Days] as[Day of Week], a.[Schedule Start Date], a.[Schedule End Date], a.[Clinic Start Time] as[Start Time],
a.[Clinic End Time] as[End Time], a.[Clinic Hours Category], a.[Location], a.[Building], a.[Floor], a.[Suite], a.[Room Name], a.[Room Number],isnull([Clinic Schedule Notes],'') as [Notes]
from Room_Only_Regular_Schedule a with (nolock) 
where isnull([Location] ,'')!='' and exists (Select '' from [Room_Only_Regular_Schedule_History] b with (nolock)  inner join
		(select [Room Only Schedule Provider], max([Schedule Updated On]) [Schedule Updated On] from  [Room_Only_Regular_Schedule_History] with (nolock)  group by [Room Only Schedule Provider])c on  
b.[Room Only Schedule Provider]=c.[Room Only Schedule Provider] and b.[Schedule Updated On]=c.[Schedule Updated On] where a.[Room Only Schedule Provider]=b.[Room Only Schedule Provider]
 and (a.[Clinic Schedule Week]!=b.[Clinic Schedule Week] or a.[Work Days]!=b.[Work Days] or a.[Location]!=b.Location or a.[Clinic Hours Category]!=b.[Clinic Hours Category])
or a.[Building]!=b.[Building] or a.[Floor]!=b.[Floor] or a.[Suite]!=b.[Suite] and a.[DEP Name]!=b.[DEP Name])
and a.location in (select location from ERD_Location_Master where [Room Mandatory]='Yes') and a.[Schedule End Date] >= Getdate()




GO
