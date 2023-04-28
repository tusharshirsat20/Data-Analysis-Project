create database kwalee;
use kwalee;

create table players (
install_datetime datetime,
player_id varchar(35),
platform varchar(10),
country varchar(5),
screen_size double,
system_memory int
);

desc players;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/players.csv"
INTO TABLE players
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(install_datetime,player_id,platform,country,screen_size,system_memory);

# EXPLORING DATA 

select * from players;
 
select distinct country from players;
select country,count(player_id) from players group by country order by 2 desc;

select platform,count(platform) from players group by platform;	

select system_memory,count(system_memory) as count_memory 
from players  
where system_memory between 2000 and 4000  
group by system_memory order by 2 desc;

select sum(count_memory) from 
(	
select system_memory,count(system_memory) as count_memory 
from players  
where system_memory between 2600 and 4000  
group by system_memory order by 2 desc
)
as table1;

select screen_size,count(screen_size) from players group by screen_size order by 2 desc;

select date(install_datetime) from players order by install_datetime ;



# New daily insalls

select date(install_datetime), count(install_datetime) as daily_installs 
from players 
group by DATE(install_datetime) 
order by date(install_datetime);

# Average new daily installs

with table2 as
( 
select date(install_datetime), count(install_datetime) as daily_installs 
from players 
group by DATE(install_datetime) 
order by date(install_datetime)
)
select avg(daily_installs) from table2;


# Total players did not opened the app after installing (60 players)

select p.player_id ,l.event_datetime 
from players p
left join levels l
on l.player_id=p.player_id
where event_datetime is NULL;


# Failing and quitting relationship with platform

select platform, count(platform) from
(
with table1 as (
select player_id,levelno,stageno,status_,
dense_rank() over(partition by player_id order by player_id,levelno desc,stageno desc) rnk
from levels
			)
select distinct t.player_id , p.platform as platform, system_memory
from table1 t
join players p
on t.player_id=p.player_id
where status_='fail' and rnk=1
)as table2
group by platform;

# Failing and quitting relationship with system_memory

select system_memory,count(system_memory) from #platform, count(platform) from
(
with table1 as (
select player_id,levelno,stageno,status_,
dense_rank() over(partition by player_id order by player_id,levelno desc,session_id) rnk
from levels
			)
select distinct t.player_id , p.platform as platform, system_memory
from table1 t
join players p
on t.player_id=p.player_id
where status_='fail' and rnk=1
)as table2
group by system_memory
order by 2 desc;
#group by platform;

/*
-- max levels dependency on platorm

select platform,count(platform) from #platform, count(platform) from
(
select l.player_id,max(l.levelno) as max_level , p.platform
from levels l
join players p
on l.player_id=p.player_id
group by l.player_id,p.platform
order by 2 desc
)as table1
group by platform;
*/


