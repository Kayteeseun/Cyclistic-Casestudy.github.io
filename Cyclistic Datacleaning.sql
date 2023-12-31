--combining tables together into one table
SELECT 
ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
 INTO A_CLEANED
FROM (
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202201-divvy-tripdata$']
union ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202202-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202203-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202204-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202205-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202206-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202207-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202208-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202209-divvy-publictripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202210-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202211-divvy-tripdata$']
UNION ALL
select ride_id,rideable_type, started_at, ended_at, start_lat, start_lng,end_lat,
end_lng,member_casual,start_station_name,end_station_name,day_of_week 
FROM['202212-divvy-tripdata$']) A
--Uploading not null values
SELECT * INTO B_CLEANED
FROM( SELECT * FROM A_CLEANED WHERE start_lat is nOT null AND start_lng is not null AND
end_lat is not null AND end_lng is not null AND
start_station_name is not null AND end_station_name is not null) B
SELECT * FROM B_CLEANED
SELECT COUNT (*) FROM B_CLEANED
--checking of duplicates
SELECT ride_id, COUNT(ride_id ) FROM B_CLEANED
GROUP BY ride_id
HAVING COUNT (ride_id) > 1
 
--delete duplicates
		DELETE FROM B_CLEANED
		WHERE ride_id IN (SELECT ride_id
		FROM B_CLEANED
		GROUP BY ride_id HAVING COUNT(ride_id) > 1)

		DELETE FROM B_CLEANED
        WHERE ended_at < started_at;
		--checking of short rides
SELECT  duration
FROM B_CLEANED
WHERE ended_at < started_at;
---delected short rides
DELETE FROM B_CLEANED
WHERE ended_at < started_at;
		--checking membercasual and rideable table names
SELECT rideable_type,
member_casual
FROM B_CLEANED
GROUP BY rideable_type, member_casual

--checking of empty spaces
SELECT ride_id,rideable_type,
start_station_name,
end_station_name,
member_casual
FROM B_CLEANED
WHERE ride_id LIKE ' %' OR ride_id LIKE '% '
OR rideable_type LIKE ' %' OR rideable_type LIKE '% '
OR start_station_name LIKE ' %' OR rideable_type LIKE '% '
OR end_station_name LIKE ' %' OR rideable_type LIKE '% '

--  count of records with test name in  start_station_name or end_station_name
SELECT COUNT(*) AS records_count
FROM B_CLEANED
WHERE start_station_name LIKE ('%test%') OR end_station_name LIKE ('%test%');
-- Deleted records with  'TEST' or 'test' in  start_station_name or end_station_name
DELETE FROM B_CLEANED
WHERE start_station_name LIKE ('%test%') OR end_station_name LIKE ('%test%')
OR start_station_name LIKE ('%TEST%') OR end_station_name LIKE ('%TEST%');
SELECT * FROM B_CLEANED
--checking the lenght of ride_id
SELECT LEN(ride_id) AS length_ride_id, COUNT(ride_id) AS no_of_rows
FROM B_CLEANED
GROUP BY ride_id
HAVING COUNT(ride_id) > 1

--adding columns to B_cleaned table
	ALTER TABLE B_CLEANED
	ADD day_of_week char(10)
	ALTER TABLE B_CLEANED
	ADD month char(20)
	ALTER TABLE B_CLEANED
	 ADD duration INT
	 ALTER TABLE B_CLEANED
	 ADD date DATE
--updating new columns
	UPDATE B_CLEANED
SET Day_of_week = daTEname(WEEKDAY,started_at)

     UPDATE B_CLEANED
	 SET month = DATENAME(month, started_at)
	 
	 UPDATE B_CLEANED
	 SET date = CAST(started_at AS DATE)

	UPDATE B_CLEANED
	 SET duration = DATEDIFF(minute,ended_at,started_at) 
	
	SELECT * FROM B_CLEANED
	--checking errors in spelling  
		  SELECT * FROM B_CLEANED
	WHERE NOT rideable_type  =  'electric_bike' AND
	      NOT rideable_type  = 'classic_bike' AND
		  NOT rideable_type  = 'docked_bike';
		  --No errors spellimg found

		--Uploading the cleaned table to new table
        SELECT *  INTO Yearly_cyclistic 
		FROM (SELECT *  FROM B_CLEANED ) C
	



  




