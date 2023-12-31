USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Supply]    Script Date: 7/21/2023 4:01:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VW_Room_Supply] as 
--SELECT 
--a.location,b.Building,c.[floor],d.Wing,e.[Room Number],right(b.building,1)+left(c.Floor,1)+'.'+left(d.wing,1)+[room number] [Room name]
--FROM dbo.[ERD_Location_Master] a left join dbo.[Building_Master] b on a.location=b.location
--left join dbo.[Floor_Master] c on a.location=c.location and b.Building=c.Building
--left join dbo.[wing_master] d on a.location=d.location and b.Building=d.Building and c.[floor]=d.[floor]
--left join [dbo].[ERD_Room_Master] e on e.location=c.location and e.Building=c.Building and e.[floor]=d.[floor] and d.Wing=e.Wing

SELECT 
e.location,e.Building,e.[floor],e.Wing,e.[Room Number]
,right(e.building,1)+left(e.Floor,1)+'.'+left(e.wing,1)+cast([room number] as varchar) [Room name]
FROM  [dbo].[ERD_Room_Master] e 





GO
