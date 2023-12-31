USE [V3_Neurology]
GO
/****** Object:  View [dbo].[vw_Enterprise_Schedule_Data_By_Week]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_Enterprise_Schedule_Data_By_Week] as 


with 
 suite  as 
 (select  distinct suite,[No of Participants] ,[DayoftheWeek],weekno ,location from  [WeekNumber_Day] a 
left join  [dbo].[ERD_suite_master] b on 1=1 
 ),
 Clinichrscat as
 (
    select *,(select top 1 b.[clinic hours category] from [dbo].[ERD_Clinic_Hours_Category] b
	where  (cast(a.[Clinic Start Time] as time) BETWEEN cast([Start Time Minimum Value] as time) and cast([Start Time Maximum Value] as time)
and cast(a.[Clinic End Time] as time) BETWEEN cast([End Time Minimum Value] as time) and cast([End Time Maximum Value] as time))) [Clinic Hours Category1]

from [ERD_Enterprise_Schedule_Data] a
	
	
)
,


[Schedule_Data] as (select distinct   datename(weekday,[clinic date]) [Work Days],cast(ceiling(cast(right(CONVERT(Date,[Clinic date], 103),2)
				as float)/7.00)as nvarchar(10)) [Clinic Schedule Week] ,[Clinic Hours Category1][Clinic Hours Category], [Suite],
				case when [Clinic Hours Category1]='AM' then [No Of Participants] else 0 end 'AM Occupancy',
				case when [Clinic Hours Category1]='PM' then [No Of Participants] else 0 end 'PM Occupancy',
				case when [Clinic Hours Category1]='Evening' then [No Of Participants] else 0 end 'Evening Occupancy',
				case when [Clinic Hours Category1]='All Day' then [No Of Participants] else 0 end 'All Day Occupancy' 
					
				
				from Clinichrscat)

				select 
      [DayoftheWeek] [Work Days] ,weekno [Clinic Schedule Week],location,B.[Suite],isnull(sum([AM Occupancy]),0) [AM Occupancy] ,
	  isnull((isnull(max(b.[No of Participants]),0)-isnull(sum([AM Occupancy]),0)),0) 'AM Availability',
				isnull(sum([PM Occupancy]),0) [PM Occupancy],isnull((isnull(max(b.[No of Participants]),0)-isnull(sum([PM Occupancy]),0)),0) 'PM Availability'
				,isnull(sum([Evening Occupancy]),0) [Evening Occupancy],isnull((isnull(max(b.[No of Participants]),0)-isnull(sum([Evening Occupancy]),0)),0) 'Evening Availability',
				isnull(sum([All Day Occupancy]) ,0) [All Day Occupancy ],isnull((isnull(max(b.[No of Participants]),0)-isnull(sum([All day Occupancy]),0)),0) 'All Day Availability'
				from suite  b left join [Schedule_Data] a  on a.[Suite]=b.[Suite] and a.[work days]=b.[DayoftheWeek] and a.[Clinic Schedule Week]=b.Weekno 
				group by [DayoftheWeek],weekno,B.[Suite],location









GO
