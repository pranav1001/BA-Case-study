#upload required csv files into tables as per your known method
USE beat_case_Study;

DESC dailyactivity;
SELECT * FROM dailyactivity;
# of users with activity data
SELECT count(DISTINCT id) FROM dailyactivity;

DESC sleepday;
# of users with sleep data
SELECT count(DISTINCT id) FROM sleepday;
SELECT * FROM sleepday;

# adding weekday column and classify activity type based on no of steps
DROP VIEW IF EXISTS new_dailyActivity;
CREATE VIEW new_dailyActivity AS (
SELECT *,dayname(str_to_date(activitydate,'%m/%d/%Y')) AS weekday,
	CASE 
		WHEN TotalSteps<5000 THEN "Sedentary"
		WHEN TotalSteps>=5000 AND TotalSteps<=7499 THEN "Lightly active"
		WHEN TotalSteps>=7500 AND TotalSteps<=9999 THEN "Fairly active"
		ELSE "Very active"
	END
	AS "ActivityType" FROM dailyactivity);

#some basic observations
SELECT * FROM new_dailyActivity;

SELECT weekday,sum(calories) FROM new_dailyactivity 
GROUP BY weekday order by 2 desc;

SELECT activitytype, count(id) FROM new_dailyactivity GROUP BY activitytype;


SHOW TABLES;

# adding weekday column and classify sleep quality based on hours slept
DROP VIEW IF EXISTS new_sleepDay;
CREATE VIEW new_sleepDay AS (
SELECT *,dayname(str_to_date(sleepday,'%m/%d/%Y')) AS weekday,
CASE 
		WHEN TotalMinutesAsleep/60< 6 THEN "Poor"
		WHEN TotalMinutesAsleep/60>=6 AND TotalMinutesAsleep/60<8 THEN "Ok"
		ELSE "Good"
	END
	AS "SleepQuality"
FROM sleepday);

SELECT substring_index(sleepDay," ",1) FROM new_sleepday;
SELECT * FROM new_sleepday;

# joining both views to get complete data for the day of that user
DROP VIEW IF EXISTS user_records;
CREATE VIEW user_records AS(
SELECT new_dailyactivity.Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance,
 VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance,
    SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes,
    SedentaryMinutes, Calories, new_dailyactivity.weekday, ActivityType,
    TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed, SleepQuality
FROM new_dailyactivity LEFT JOIN new_sleepday 
ON new_dailyactivity.id=new_sleepday.id AND new_dailyactivity.ActivityDate=substring_index(new_SleepDay.sleepDay," ",1));

SELECT * FROM user_records;

SELECT totalsteps,calories,sleepquality from user_records;

# Explore some other csv files given using pandas as they are large and google big query charges to export results.




