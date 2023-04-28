CREATE DATABASE kwalee;
USE kwalee;

CREATE TABLE levels (
event_datetime DATETIME,
player_id VARCHAR(35),
levelno INT,
stageno INT,
status_ VARCHAR(10),
session_id VARCHAR(35)
);

# Extract csv file into table

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/level_progress.csv"
INTO TABLE levels
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
( event_datetime,player_id,levelno,stageno,status_,session_id );

# Does failing increase risk on churn?
#	calculated game quits on players failing and immediately quitting
#    calculated game quits on last session player played
#    calculated game quits on last stage players played
#    calculated game  quits on last level players played

-- Queries 

# Daily active users
# After how many days most players left
# No. of players and their days played and max level
# Maximum level players are playing
# No. of fails on partticular level and stage
# Fails on level
# Failing ratio

#Failing and quiting factors- 
#	- No. of players failed after which they never played the game (by last event_datetime) (players who failed and immediately quit the game)
#   - No. of players failed in a session after which they never played the game (at least 1 fail in last session)
#   - No. of players failed in their last level after which they never played the game (at least 1 fail in their last level played)
#	- No. of players failed in a stage after which they never played the game (at least 1 fail in last stage)

# Count of level/stage on which players failed and never played the game (by last event_time)
# Frequency of count of fails on their last level ( so, people mostly fail 1 time in their last level played )



SELECT * FROM levels;

-- 1.DAU (daily active users)

# SELECT AVG(c) FROM (

SELECT DATE(event_datetime)AS d ,DAYNAME(event_datetime),COUNT(player_id) AS c FROM levels 
GROUP BY DATE(event_datetime),DAYNAME(event_datetime)
ORDER BY DATE(event_datetime) ;

 #)AS table1;


-- Maximum days most players played the game
    
SELECT days_played ,COUNT(days_played) FROM 
(
SELECT player_id, COUNT(DISTINCT DAY(event_datetime)) AS days_played , COUNT(session_id) ,MAX(levelno) AS maxlevel 
FROM levels
GROUP BY player_id
ORDER BY 2,3 DESC,4 DESC
) AS table1
GROUP BY days_played;


-- Count of players and their days played and max level (days till the players played and their max level)

SELECT days_played,maxlevel,COUNT(maxlevel) players_count
FROM (
SELECT player_id, COUNT(DISTINCT DAY(event_datetime)) AS days_played , COUNT(session_id) ,MAX(levelno) AS maxlevel FROM levels
GROUP BY player_id
ORDER BY 2,3 DESC,4 DESC
)AS table2
GROUP BY days_played,maxlevel
ORDER BY 1,3 DESC;


-- Maximum levels players played

SELECT max_level,COUNT(max_level) AS player_count FROM
(
SELECT player_id,MAX(levelno) AS max_level FROM levels
GROUP BY player_id
ORDER BY 2 DESC
)AS table1
GROUP BY max_level
ORDER BY 1,2 DESC;


-- No. of fails on partticular level and stage

SELECT levelno, stageno,COUNT(status_)
FROM levels 
WHERE status_='fail'
GROUP BY levelno,stageno
ORDER BY 1,2;

-- Fails on level
	
SELECT levelno,
COUNT(status_) 
FROM levels 
WHERE status_='fail'
GROUP BY levelno
ORDER BY 2 DESC;


-- Failing ratio (total fails per total starts )


WITH
table1 AS (
SELECT levelno, stageno, COUNT(status_) AS fail FROM levels
WHERE status_='fail'
GROUP BY levelno,stageno,status_
ORDER BY 1 ),

table2 AS (
SELECT levelno, stageno, COUNT(status_) AS total FROM levels
WHERE status_='start'
GROUP BY levelno,stageno,status_
ORDER BY 1 )

SELECT t1.levelno as Level_number, t1.stageno as Stage_number, t1.fail as Total_fails ,t2.total as Total_starts,CAST( (t1.fail/t2.total)*100  AS DECIMAL(10,2) ) AS Fails_ratio
FROM table1 AS t1
JOIN table2 t2
ON t1.levelno=t2.levelno AND t1.stageno=t2.stageno
ORDER BY 1,2;

##################################### failing and quitting ###############################################

-- No. of players failed after which they never played the game (by last event_datetime) (players who failed and immediately quit the game)

WITH table1 AS 
(
SELECT player_id, status_,levelno,stageno,session_id, event_datetime,
ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_datetime DESC) AS rnk
FROM levels
)
 SELECT status_ AS players_last_event_time,COUNT(status_) AS no_of_players FROM table1
WHERE rnk BETWEEN 0 AND 1
GROUP BY status_;



-- No. of players failed in a session after which they never played the game (at least 1 fail in last session)
#Players count - 963
    
WITH table1 AS
(
SELECT player_id,levelno,stageno,status_,session_id,event_datetime,
DENSE_RANK() OVER(PARTITION BY player_id ORDER BY player_id,session_id) rnk
FROM levels
)
SELECT DISTINCT player_id 
FROM table1
WHERE status_='fail' AND rnk BETWEEN 0 AND 1;



-- No. of players failed in their last level after which they never played the game (at least 1 fail in their last level played)
#Players count - 1743

WITH table1 AS (
SELECT player_id,levelno,stageno,status_,session_id,event_datetime,
DENSE_RANK() OVER(PARTITION BY player_id ORDER BY player_id,levelno DESC) rnk
FROM levels
)
#select count(*) from table1
SELECT DISTINCT player_id FROM table1
WHERE status_='fail' AND rnk=1;


-- No. of players failed in a stage after which they never played the game (at least 1 fail in last stage)
#Players count - 1350
    
WITH table1 AS (
SELECT player_id,levelno,stageno,status_,
DENSE_RANK() OVER(PARTITION BY player_id ORDER BY player_id,levelno DESC,stageno DESC) rnk
FROM levels
)
SELECT DISTINCT player_id 
FROM table1
WHERE status_='fail' AND rnk=1;



-- Count of level/stage on which players failed and never played the game (by last event_time)
	
SELECT levelno,count(levelno) AS players_failing FROM (
WITH table1 AS 
(
SELECT player_id, status_, levelno,stageno,event_datetime,
ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_datetime DESC) AS rnk
FROM levels
)
SELECT player_id, status_,levelno,stageno, event_datetime,rnk
FROM table1
WHERE status_='fail' AND rnk=1
)AS table2
GROUP BY levelno
ORDER BY 2 DESC;


-- Frequency of count of fails on their last level ( so, people mostly fail 1 time in their last level played )


select fails_on_last_level, count(fails_on_last_level) as frequency_of_fails from (

WITH table1 AS (
select player_id,levelno,stageno,status_,
DENSE_RANK() OVER(PARTITION BY player_id ORDER BY player_id,levelno DESC) rnk
FROM levels
)
SELECT player_id ,levelno AS last_level,COUNT(status_)AS fails_on_last_level
FROM table1
WHERE status_='fail' AND rnk=1
GROUP BY player_id,levelno  

)AS table3
GROUP BY fails_on_last_level
ORDER BY 2 DESC;


