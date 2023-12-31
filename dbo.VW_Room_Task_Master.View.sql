USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Task_Master]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Room_Task_Master]
as
select distinct b.[Location][Location Task],a.[Building][Building Task],
[Floor][Floor Task],[Wing][Wing Task],[Room Name][Room Name Task],[Room Status]
from [ERD_Location_Master] b Left join ERD_Room_Master a on a.Location=b.Location and a.[Room Status]='Active' 
GO
