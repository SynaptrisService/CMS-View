USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Cancel_MDC_Clinic_Detail_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[VW_Cancel_MDC_Clinic_Detail_Report]
as
select Distinct [Created On],[Created By],[Submitted By],[WF Status],[Record Status],[Record Modified On],[System Submitter Name],[Submitted On],
[Record Modified By],[Master System ID],[Modified Section],[Originating Process],[Provider],[Employee Login ID],[Clinic Start Date],
[Clinic End Date],[Request Notice Period In Weeks],[Request Notice Period In Hours],[Clinic Date],[Clinic Hours Category],[Clinic Duration],
[Clinic Start Time],[Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],[MDC Clinic Specialty],
[Location],[Building],[Floor],[Wing],[Suite],[Room Name],[Room Number],[Room Label],[Workspaces Occupied],[No of Participants],
[No of Appointments Scheduled],[Cancel Confirmation],[Clinic Notes],[Covering Provider Name],[Cancel Provider Participation Only],
[Multi Specialty Clinic],[Reason For Cancellation],[Other Reason Notes],[Confirmation Date],[Confirmation No],[Rooms Released],
[Room Release Date],[Hospital Tracking Tool Updated],[Clinic ID],[Clinic Cancellation Notes],[Request Add Clinic],[Number of Date Options],
[Add Clinic Date Requested 1],[Add Clinic Hours Category Requested 1],[Add Clinic Duration Requested 1],[Add Clinic Location Requested 1],
[Add Clinic Date Requested 2],[Add Clinic Hours Category Requested 2],[Add Clinic Duration Requested 2],[Add Clinic Location Requested 2],
[Add Clinic Date Requested 3],[Add Clinic Hours Category Requested 3],[Add Clinic Duration Requested 3],[Add Clinic Location Requested 3],
[Approved Add Clinic Date],[Approved Add Clinic Hours Category],[Approved Add Clinic Duration],[Approved Add Clinic Start Time],
[Approved Add Clinic End Time],[Approved Add Clinic Location],[Add Clinic Total Hours],[Rooms Assigned],[Approved Building],
[Approved Floor],[Approved Wing],[Approved Suite],[Approved Room Name],[Approved Room Number],[Kezava Unique ID],[Source Originating Process],
[Division Name],[Clinic Template],[MDC Provider Name],[Division Notification],[Reference Division Name],[MDC Status],[MDC Clinic],[MDC Host Domain],
[Division Approval Required],[Division Approval Status],[Division Approval Comments],[EMR Update Status],[Display in Calendar],
[Cancel Approval Date],[Total No Scheduled Clinics],[Advance Notice Period],[MDC Details],[Approver Notes to Scheduling Center],
[Confirmer Notes],[Split Reference Date],[MDC Host Division Name]
from [Cancel_MDC_Clinic_Detail]
union
select Distinct [Created On],[Created By],[Submitted By],[WF Status],[Record Status],[Record Modified On],[System Submitter Name],[Submitted On],
[Record Modified By],[Master System ID],[Modified Section],[Originating Process],[Provider],[Employee Login ID],[Clinic Start Date],
[Clinic End Date],[Request Notice Period In Weeks],[Request Notice Period In Hours],[Clinic Date],[Clinic Hours Category],[Clinic Duration],
[Clinic Start Time],[Clinic End Time],[Scheduled Clinic Time],[Total No Of Hours],[Clinic Type],[Clinic Specialty],[MDC Clinic Specialty],
[Location],[Building],[Floor],[Wing],[Suite],[Room Name],[Room Number],[Room Label],[Workspaces Occupied],[No of Participants],
[No of Appointments Scheduled],[Cancel Confirmation],[Clinic Notes],[Covering Provider Name],[Cancel Provider Participation Only],
[Multi Specialty Clinic],[Reason For Cancellation],[Other Reason Notes],[Confirmation Date],[Confirmation No],[Rooms Released],
[Room Release Date],[Hospital Tracking Tool Updated],[Clinic ID],[Clinic Cancellation Notes],[Request Add Clinic],[Number of Date Options],
[Add Clinic Date Requested 1],[Add Clinic Hours Category Requested 1],[Add Clinic Duration Requested 1],[Add Clinic Location Requested 1],
[Add Clinic Date Requested 2],[Add Clinic Hours Category Requested 2],[Add Clinic Duration Requested 2],[Add Clinic Location Requested 2],
[Add Clinic Date Requested 3],[Add Clinic Hours Category Requested 3],[Add Clinic Duration Requested 3],[Add Clinic Location Requested 3],
[Approved Add Clinic Date],[Approved Add Clinic Hours Category],[Approved Add Clinic Duration],[Approved Add Clinic Start Time],
[Approved Add Clinic End Time],[Approved Add Clinic Location],[Add Clinic Total Hours],[Rooms Assigned],[Approved Building],
[Approved Floor],[Approved Wing],[Approved Suite],[Approved Room Name],[Approved Room Number],[Kezava Unique ID],[Source Originating Process],
[Division Name],[Clinic Template],[MDC Provider Name],[Division Notification],[Reference Division Name],[MDC Status],[MDC Clinic],[MDC Host Domain],
[Division Approval Required],[Division Approval Status],[Division Approval Comments],[EMR Update Status],[Display in Calendar],
[Cancel Approval Date],[Total No Scheduled Clinics],[Advance Notice Period],[MDC Details],[Approver Notes to Scheduling Center],
[Confirmer Notes],[Split Reference Date],[MDC Host Division Name] from [Cancel_MDC_Clinic_Inprogress]
GO
