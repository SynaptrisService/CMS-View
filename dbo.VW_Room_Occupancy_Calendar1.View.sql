USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Occupancy_Calendar1]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	   create VIEW [dbo].[VW_Room_Occupancy_Calendar1] as  
		with RoomAssignDetail as
		(
			select 
				ROD.[Clinic Date],ROD.[Provider],ROD.[Clinic Type],ROD.[Clinic Specialty],ROD.[Location],ROD.[Room Number],
				ROD.[Clinic Start Time],ROD.[Clinic End Time], null [Room Status],ROD.[Schedule Start Date],ROD.[Schedule end Date],
				ROD.[Work Days],ROD.[Clinic Schedule Week],ROD.Building,ROD.[Floor],ROD.Wing,
				Datediff(hh,ROD.[Clinic Start Time],ROD.[Clinic End Time])[Total Hours],ROD.[Room Name],
				Datediff(MINUTE,ROD.[Clinic Start Time],ROD.[Clinic End Time])[Total Mins],
				(select 
					top 1 [Clinic Hours Category] from [dbo].[ERD_Clinic_Hours_Category]
				where 	(
						cast(ROD.[clinic start time] as time
						) 
						BETWEEN cast([Start Time Minimum Value] as time) and cast([Start Time Maximum Value] as time)
						and cast(ROD.[clinic end time] as time) BETWEEN cast([End Time Minimum Value] as time) 
						and cast([End Time Maximum Value] as time))) [Clinic Hours Category]
			from dbo.Room_Occupancy_Details ROD 
			where ROD.[Room Name] 
				in  (	select RAD.[Room Name] 
						from dbo.[Room_Assignment_Detail] RAD 
						where ROD.[Clinic Date]=RAD.[Clinic Date] 
						and ROD.Location=RAD.Location 
						and ROD.Building=RAD.Building 
						and ROD.[Floor]=RAD.[Floor] 
						and isnull(ROD.Wing,'')=isnull(RAD.wing,'')
					)   
			and ROD.[Clinic Date] >=(getdate()-90)  ),
		
	--********************************************************
	--The below block Used to get the Unoccupied data
	--********************************************************
		 
		UnoccupiedData as 
		(
			select 
					distinct [Clinic Date],null  [Provider],null [Clinic Type],null [Clinic Specialty],[Location],
					[Room Number],[Clinic Start Time][Start Time],[Clinic End Time] [End Time],[Clinic Hours Category],
					'Unoccupied' [Room Status],[Schedule Start Date],[Schedule end Date],[Work Days],[Clinic Schedule Week],
					Building,[Floor],Wing,Datediff(hh,[Clinic Start Time],[Clinic End Time])[Total Hours],
					[Room Name] ,Datediff(MINUTE,[Clinic Start Time],[Clinic End Time]) [Total Mins] 
			from 	RoomAssignDetail 
			where 	isnull(Provider,'')=''
			
			UNION 
			
			select 
					distinct  RSD.[Date],null  [Provider],null [Clinic Type],null [Clinic Specialty],RSD.[Location],
					RSD.[Room Number],RSD.[Start Time] [Star tTime],RSD.[End Time] [End Time],''[Clinic Hours Category],
					'Unoccupied' [Room Status],RSD.[Schedule Start Date],RSD.[Schedule end Date],RSD.[Work Days],RSD.[Clinic Schedule Week],
					RSD.Building,RSD.[Floor],RSD.wing,Datediff(hh,RSD.[Start Time],RSD.[End Time]) [Total Hours],RSD.[Room Name] ,
					Datediff(MINUTE,RSD.[Start Time],RSD.[End Time]) [Total Mins] 
			from 	dbo.[Room_Schedule_Detail] RSD
			where 	RSD.[Room Name] 
			not in 
				(
				select RAD.[Room Name] 
				from dbo.[Room_Assignment_Detail] RAD 
				where RSD.[Date]=RAD.[Clinic Date] 
				and RSD.Location=RAD.Location 
				and RSD.Building=RAD.Building 
				and RSD.[Floor]=RAD.[Floor] 
				and RSD.Wing=RAD.wing 
			
				)  
			and RSD.[Date] >=(getdate()-90)  
		),
		
	--********************************************************
	--The below block Used to get the Occupied data
	--********************************************************
		
		OccupiedData as 
		(			select distinct  [Clinic Date],[Provider],[Clinic Type],[Clinic Specialty],[Location],[Room Number],
			[Clinic Start Time][Start Time],[Clinic End Time] [End Time],
			case when isnull([Clinic Hours Category],'')='' then (select top 1 [Clinic Hours Category] 
			from [Provider_Regular_Schedule] PRS 
			where PRS.[Clinic Schedule Week]=RAD.[Clinic Schedule Week]
			and PRS.[Work Days]=RAD.[Work Days]
			and PRS.Location=RAD.Location
			and PRS.[Schedule Start Date]=RAD.[Schedule Start Date]
			and PRS.[Schedule End Date]=RAD.[Schedule End Date]
			) else [Clinic Hours Category] end as [Clinic Hours Category],'Occupied' [Room Status],
			[Schedule Start Date],[Schedule end Date],[Work Days],[Clinic Schedule Week],Building,[Floor],wing,
			Datediff(hh,[Clinic Start Time],[Clinic End Time])[Total Hours],[Room Name] ,
			Datediff(MINUTE,[Clinic Start Time],[Clinic End Time])[Total Mins] 
			from RoomAssignDetail RAD  where isnull(Provider,'')!=''		),
		
	--*****************************************************************
	--The below block Used to Combined Occupied and Unoccupied data
	--*****************************************************************
		OccupiedUnoccupiedData as
		(
		select * from OccupiedData
		Union ALL
		select * from UnoccupiedData
		),

	--******************************************************************************
	--The below block Used to Get Final Result set of Occupied and Unoccupied data
	--******************************************************************************

		RoomOccupancyData as 
		(
			select *,case when [Room Status]='Occupied' and [Total Hours]<2 then '#9bb764' when [Room Status]='Occupied' 
			and [Total Hours]>=2 and [Total Hours]<=5 then '#faff05'
			when [Room Status]='Occupied' and [Total Hours]>5 then '#ff6347' else '#9bb764' end 'Color Code',
			case when [Room Status]='Occupied' and [Used Hours]<2 then '#9bb764' when [Room Status]='Occupied' 
			and [Used Hours]>=2 and  [Used Hours]<=5 then '#faff05'
			when [Room Status]='Occupied' and [Used Hours]>5 then '#ff6347' else '#9bb764' end 'PCLR Color Code',
			case when [Room Status]='Occupied' and [Total Hours]<2 then 'LT2Hrs' when [Room Status]='Occupied' 
			and [Total Hours]>=2 and  [Total Hours]<=5 then 'GT2andLT5Hrs'
			when [Room Status]='Occupied' and [Total Hours]>5 then 'GT5Hrs' else 'Unoccupied' end 'RoomOccupancyStatus', 
			Dense_rank() over(partition by [clinic date],Building,[floor],wing,location,[room name] 
			order by [room status],[used hours] desc) rankno
			from 
			(
				select *,
				(
					select isnull(sum([Total Hours]),0) 
					from  OccupiedUnoccupiedData OUA 
					WHERE OUA.[Clinic Date]=OUB.[Clinic Date] 
					AND OUA.Location=OUB.Location
					AND OUA.Building=OUB.Building 
					AND OUA.wing=OUB.wing 
					AND OUA.[Floor]=OUB.[Floor] 
					AND OUA.[Room Name]=OUB.[Room Name] 
					and OUA.[Room Status]='Occupied') 'Used Hours'  
				from OccupiedUnoccupiedData OUB  
				where OUB.[Room Status]='Unoccupied'	
				UNION
				select *,
					(
					select isnull(sum([Total Hours]),0) 
					from  OccupiedUnoccupiedData OUA 
					WHERE OUA.[Clinic Date]=OUB.[Clinic Date] 
					AND OUA.Location=OUB.Location
					AND OUA.Building=OUB.Building 
					AND OUA.wing=OUB.wing 
					AND OUA.[Floor]=OUB.[Floor] 
					AND OUA.[Room Name]=OUB.[Room Name] 
					and OUA.[Room Status]='Occupied'
					)'Used Hours'
			 from OccupiedUnoccupiedData OUB   
			 where  OUB.[Room Status]='Occupied'
		
			)SQ
		)

	  	 select  	ROD.[Clinic Date],ROD.[Provider],ROD.[Clinic Type],ROD.[Clinic Specialty],ROD.[Location],[Room Number],
					dateadd(hour,datepart(HOUR,[Start Time]),dateadd(MINUTE,datepart(MINUTE,[Start Time]),CONVERT(datetime,[Clinic Date],103)))[Clinic Start Time],
					dateadd(hour,datepart(HOUR,[End Time]),dateadd(MINUTE,datepart(MINUTE,[End Time]),CONVERT(datetime,[Clinic Date],103)))[Clinic End Time],
					[Clinic Hours Category],[Room Status],[Schedule Start Date],
					[Schedule end Date],[Work Days],[Clinic Schedule Week],ROD.[Building],ROD.[Floor],ROD.[Wing],[Total Hours],
					ROD.[Room Name],[Used Hours],[Color Code],RoomOccupancyStatus,[PCLR Color Code],[rankno]
					,case when ROD.rankno=1 then ROD.[PCLR Color Code] else '' end PCLR ,
					case 	when datename(weekday,ROD.[clinic date]) ='Monday' then 2   
							when datename(weekday,ROD.[clinic date]) ='Tuesday' then 3 
							when datename(weekday,ROD.[clinic date])='Wednesday' then 4  
							when datename(weekday,ROD.[clinic date]) ='Thursday' then 5  
							when datename(weekday,ROD.[clinic date])='Friday' then 6  
							when datename(weekday,ROD.[clinic date])='Saturday' then 7 
							when datename(weekday,ROD.[clinic date])='Sunday' then 1  end 'Week Order',
					(
						select top 1 [Room Category] 
						from [dbo].[ERD_Room_Master] 
						where [room name]=ROD.[Room Name]
					)as [Room Category]
		 from 		RoomOccupancyData  ROD 
		 where 		ROD.[Total Mins] > 0 
		 and 		isnull([Clinic Specialty],'')!='Room Setup Time'
	
	union
	select  	ROD.[Clinic Date],ROD.[Provider],ROD.[Clinic Type],ROD.[Clinic Specialty],ROD.[Location],[Room Number],
				dateadd(hour,datepart(HOUR,[Start Time]),dateadd(MINUTE,datepart(MINUTE,[Start Time]),CONVERT(datetime,[Clinic Date],103)))[Clinic Start Time],
				dateadd(hour,datepart(HOUR,[End Time]),dateadd(MINUTE,datepart(MINUTE,[End Time]),CONVERT(datetime,[Clinic Date],103)))[Clinic End Time],
				[Clinic Hours Category],[Room Status],[Schedule Start Date],
				[Schedule end Date],[Work Days],[Clinic Schedule Week],ROD.[Building],ROD.[Floor],ROD.[Wing],[Total Hours],
				ROD.[Room Name],[Used Hours],[Color Code],RoomOccupancyStatus,[PCLR Color Code],[rankno]
				,case when ROD.rankno=1 then ROD.[PCLR Color Code] else '' end PCLR ,
				case 	when datename(weekday,ROD.[clinic date]) ='Monday' then 2   
						when datename(weekday,ROD.[clinic date]) ='Tuesday' then 3 
						when datename(weekday,ROD.[clinic date])='Wednesday' then 4  
						when datename(weekday,ROD.[clinic date]) ='Thursday' then 5  
						when datename(weekday,ROD.[clinic date])='Friday' then 6  
						when datename(weekday,ROD.[clinic date])='Saturday' then 7 
						when datename(weekday,ROD.[clinic date])='Sunday' then 1  end 'Week Order',
				(
					select top 1 [Room Category] 
					from [dbo].[ERD_Room_Master] 
					where [room name]=ROD.[Room Name]
				)	
				as [Room Category]
		from 	RoomOccupancyData  ROD 
		where 	ROD.[Total Mins] > 0
		 











GO
