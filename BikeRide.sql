Create Table Bikeride (
ride_id varchar(100),
rideable_type varchar(50),
started_at TIMESTAMP,
ended_at TIMESTAMP,
start_station_name varchar(100),
start_station_id varchar(50),
end_station_name varchar(100),
end_station_id varchar(50),
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual Varchar(50)
);

Select * from Bikeride;


   ----- Add New Column 'Ride_Length' To Calculate Total Ride Duration of each ride -----
Alter Table Bikeride
Add Column ride_length Interval;

Update Bikeride
set ride_length = ended_at - started_at;


   ----- Add New Column 'Day_of_week' To Extract Day Number from Column 'Started_at' ------
Alter Table Bikeride
Add Column Day_of_Week int;

Update Bikeride
set day_of_week = Extract (ISODOW from started_at);


  ----- Total Rides of Last 12 Months -----
Select count(ride_id) as Total_rides
from Bikeride;

   ----- Average Ride Duration of Last 12 Months -----
Select Avg(ride_length) as Average_ride_length 
from Bikeride;

   ----- Maximum Ride Duration of Last 12 Months -----
Select max(ride_length) as Maximum_ride_length
from Bikeride;

 ---- Total Rides & Average Ride Duration By Membership Type of Last 12 Months -----
Select member_casual, count(ride_id) as Total_rides, 
       Avg(ride_length) as Average_ride_length
from Bikeride
Group by member_casual; 

 ---- Total Rides & Average Ride Duration By Rideable Type of Last 12 Months ----
Select rideable_type, count(ride_id) as Total_rides, 
       Avg(ride_length) as Average_ride_length
from Bikeride
Group by rideable_type;

--- Total Rides & Average Ride Duration By Membership Type & Rideable Type of Last 12 Months ---
Select member_casual, rideable_type, count(ride_id) as Total_rides,
       Avg(ride_length) as Average_ride_length
from Bikeride
Group by member_casual, rideable_type;

  ------  Total Rides & Average Ride Duration Per Day of Last 12 Months -------
Select Date(started_at) as Year_Date, count(ride_id) as Total_rides,
       Avg(ride_length) as Average_Ride_length
from Bikeride
Group by Year_Date
Order by Year_Date;

 ---- Peak Day Per Month ---- 
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_Month, Date(started_at) as Year_Date, 
       count(ride_id) as Total_rides,
       Avg(ride_length) as Average_ride_length
from  Bikeride
Group by Year_month, Year_Date
Order by Year_month),
cte2 as (
Select *, dense_rank() Over (Partition by Year_Month Order by Total_rides desc) as Peak_day
from cte1)
Select Year_Month, Year_Date, Total_rides, Average_ride_length, To_char(Year_date, 'day') as Day
from cte2 
Where peak_day = 1;

---- Total Rides & Average Ride Duration Per Day By Membership Type of Last 12 Months ----
Select Date(started_at) as Year_Date, member_casual,
       count(ride_id) as Total_rides,
       Avg(ride_length) as Average_Ride_length
from Bikeride
Group by Year_Date, member_casual
Order by Year_Date;

 ---- Peak Day Per Month By Membership Types ----
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_month, Date(started_at) as Year_date,
       member_casual, count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_month, Year_date, member_casual
Order by Year_month),
cte2 as (
Select *, 
dense_rank() Over (Partition by Year_month, member_casual Order by Total_rides desc) as Peak_day
from cte1)
Select Year_month, Year_date, member_casual, Total_rides, Average_ride_length, 
       To_char(Year_date, 'day') as Day 
from cte2
Where peak_day = 1
Order by Year_month, Total_rides desc;

 ---- Total Rides & Average Ride Duration Per Day By Rideable Type of Last 12 Months ----
Select Date(started_at) as Year_Date, rideable_type,
       count(ride_id) as Total_rides,
       Avg(ride_length) as Average_Ride_length
from Bikeride
Group by Year_Date, rideable_type
Order by Year_Date;

 ---- Peak day Per Month By Rideable Type ----
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_month, Date(started_at) as Year_Date,
       rideable_type, count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month, Year_Date, rideable_type
Order by Year_month),
cte2 as (
Select *, 
   dense_rank() Over (Partition by Year_month, rideable_type Order by Total_rides desc) as Peak_day
from cte1)
Select Year_month, Year_date, rideable_type, total_rides, Average_ride_length,
       To_char(Year_date, 'day') as Day
from cte2
Where Peak_day = 1
Order by Year_month, Total_rides desc;

-- Total Rides & Average Ride Duration Per Day By Membership Type & Rideable Type of Last 12 Months-
Select Date(started_at) as Year_Date, member_casual, rideable_type,
       count(ride_id) as Total_rides,
       Avg(ride_length) as Average_Ride_length
from Bikeride
Group by Year_Date, member_casual, rideable_type
Order by Year_Date;

 ---- Peak Day Per Month By Membership Type & Rideable Type ----
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_Month, Date(started_at) as Year_date,
       member_casual, rideable_type, count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_month, Year_date, member_casual, rideable_type
Order by Year_date),
cte2 as (
Select *, 
dense_rank() Over (Partition by year_month, member_casual, rideable_type Order by Total_rides desc)
as Peak_day
from cte1)
Select Year_month, Year_date, member_casual, rideable_type, Total_rides, Average_ride_length,
       To_char(Year_date, 'day') as Day
from cte2
Where Peak_day = 1
Order by Year_month, Total_rides desc;

  ------ Total Rides & Average Ride Duration Per Month of Last 12 Months -------
Select To_char(started_at, 'YYYY-MM') As Year_Month,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month
Order by Year_Month;

 ---- Total Rides & Average Ride Duration Per Month By Membership Type of Last 12 Months ----
Select To_char(started_at, 'YYYY-MM') as Year_Month, member_casual, 
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month, member_casual
Order by Year_Month;

 ---- Peak Month By Membership Type ----
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_Month, member_casual,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month, member_casual),
cte2 as (
Select *, sum(total_rides) Over (Partition By year_month) as Total_sum
from cte1),
cte3 as (
Select *,
  dense_rank() Over (Partition by member_casual Order by Total_sum desc) as Peak_month
from cte2)
Select Year_month, member_casual, Total_rides, Average_ride_length
from cte3
Where Peak_month = 1

 ---- Total Rides & Average Ride Duration Per Month By Rideable Type of Last 12 Months ----
Select To_char(started_at, 'YYYY-MM') as Year_Month, rideable_type,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month, rideable_type
Order by Year_Month;

  ---- Peak Month By Rideable type ----
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_month, rideable_type,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_month, rideable_type),
cte2 as (
Select *, sum(Total_rides) Over (Partition by Year_month) as Total_sum
from cte1),
cte3 as (
Select *, dense_rank() Over (Partition by rideable_type Order by Total_sum desc) as Peak_month
from cte2
Order by total_sum desc)
Select Year_month, rideable_type, total_rides, Average_ride_length 
from cte3
Where Peak_month = 1
       
-- Total Rides & Average Ride Duration Per Month By Rideable Type & Membership Type of Last 12 Months -
Select To_char(started_at, 'YYYY-MM') as Year_Month, member_casual, rideable_type,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month, member_casual, rideable_type
Order by Year_Month;

 ---- Peak Month By Membership Type & Rideable Type ----
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_Month, member_casual, rideable_type,
        count(ride_id) as Total_rides,
		Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month, member_casual, rideable_type
Order by Year_Month),
cte2 as (
Select *, sum(Total_rides) Over (Partition by Year_month) as Total_sum
from cte1),
cte3 as (
Select *, 
dense_rank() Over (Partition by member_casual, rideable_type Order by total_sum desc) as Peak_Month
from cte2)
Select year_month, member_casual, rideable_type, total_rides, Average_ride_length 
from cte3
Where Peak_month = 1;

 ---- Total Rides Per Hour ----
Select Extract(Hour from started_at) as ride_hour,
       count(ride_id) as Total_rides
from Bikeride
Group by ride_hour
Order By Total_rides desc;

 ---- Total Rides Per Hour By Membership Type ----
Select Extract(Hour from started_at) as ride_hour, member_casual,
       count(ride_id) as Total_rides
from Bikeride
Group by ride_hour, member_casual
Order by Total_rides desc;

 ---- Peak Hour By Membership Type ----
With cte1 as (
Select Extract(Hour from started_at) as ride_hour, member_casual,
       count(ride_id) as Total_rides
from Bikeride
Group by ride_hour, member_casual),
cte2 as (
Select *, dense_rank() Over(Partition by member_casual Order by Total_rides desc) as Peak_hour
from cte1)
Select ride_hour, member_casual, Total_rides from cte2
Where peak_hour = 1
Order by Total_rides desc;

 ---- Total Rides Per Hour By Annual Members ----
Select Extract(Hour from started_at) as ride_hour, member_casual,
       count(ride_id) as Total_rides
from Bikeride
where member_casual = 'member'
Group by ride_hour, member_casual
Order by Total_rides desc;

 ---- Total Rides Per Hours By Casual Members ----
Select Extract(Hour from started_at) as ride_hour, member_casual,
       count(ride_id) as Total_rides
from Bikeride
where member_casual = 'casual'
Group by ride_hour, member_casual
Order by Total_rides desc;

 ---- Total Rides Per Hour By Rideable Type ----
Select Extract(Hour from started_at) as ride_hour, rideable_type,
       count(ride_id) as Total_rides
from Bikeride
Group by ride_hour, rideable_type
Order by Total_rides desc;

 --- Peak Hour By Rideable Type ----
With cte1 as (
Select Extract(Hour from started_at) as ride_hour, rideable_type,
       count(ride_id) as Total_rides
from Bikeride
Group by ride_hour, rideable_type),
cte2 as (
Select *, dense_rank() Over(Partition by rideable_type Order by Total_rides desc) as Peak_hour
from cte1)
Select ride_hour, rideable_type, Total_rides 
from cte2
Where Peak_hour = 1
Order by Total_rides desc;

 ---- Total Rides Per Hour By Electric Bike ----
Select Extract(Hour from started_at) as ride_hour, rideable_type,
       count(ride_id) as Total_rides
from Bikeride
Where rideable_type = 'electric_bike'
Group by ride_hour, rideable_type
Order by Total_rides desc;

 ---- Total Rides Per Hour By Classic Bike ----
Select Extract(Hour from started_at) as ride_hour, rideable_type,
       count(ride_id) as Total_rides
from Bikeride
Where rideable_type = 'classic_bike'
Group by ride_hour, rideable_type
Order by Total_rides desc;

 ---- Total Rides Per Hour By Membership Type & Rideable Type ----
Select Extract(Hour from started_at) as ride_hour, member_casual, rideable_type,
       count(ride_id) as Total_rides
from Bikeride
Group by ride_hour, member_casual, rideable_type
Order by Total_rides desc;

 ---- Peak Hour By Membership Type & Rideable Type ----
With cte1 as (
Select Extract(Hour from started_at) as ride_hour, member_casual, rideable_type,
       count(ride_id) as Total_rides
from Bikeride
Group by ride_hour, member_casual, rideable_type),
cte2 as (
Select *, 
 dense_rank() Over (Partition by member_casual, rideable_type Order by Total_rides desc) as Peak_hour
from cte1)
Select ride_hour, member_casual, rideable_type, total_rides
from cte2
Where Peak_hour = 1
Order by Total_rides desc;

 ---- Total Rides Per Hour By Day of Week ----
Select day_of_week, Extract(Hour from started_at) as ride_hour,
       count(ride_id) as Total_rides
from Bikeride
Group by day_of_week, ride_hour
Order by day_of_week, ride_hour;

 ---- Peak Hour By Day of Week ----
With cte1 as (
Select day_of_week, Extract(Hour from started_at) as ride_hour,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length,
       dense_rank() Over(Partition by day_of_week Order by count(ride_id) desc) as Peak_hour
from Bikeride
Group by day_of_week, ride_hour)
Select day_of_week, ride_hour, total_rides, Average_ride_length from cte1
where peak_hour = 1
Order by day_of_week;

 ---- Total Rides Per Hour By Month ----
Select To_char(started_at, 'YYYY-MM') as Year_month, Extract(Hour from started_at) as ride_hour,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_month, ride_hour
Order by Year_month, ride_hour;
       
 ---- Peak Hour By Month ----
With cte1 as (
Select To_char(started_at, 'YYYY-MM') as Year_month, Extract(Hour from started_at) as ride_hour,
       count(ride_id) as Total_rides,
	   Avg(ride_length) as Average_ride_length
from Bikeride
Group by Year_Month, ride_hour),
cte2 as (
Select *, dense_rank() Over(Partition by Year_Month Order by Total_rides desc) as Peak_hour
from cte1)
Select Year_month, ride_hour, Total_rides, Average_ride_length from cte2
Where peak_hour = 1;

