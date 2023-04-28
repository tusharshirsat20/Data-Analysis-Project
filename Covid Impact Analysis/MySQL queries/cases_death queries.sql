use covid;

-- DATA we will be working with location,continent,population, dates, total_cases, total_deaths, new_cases,new_deaths

select location,continent,population, dates, total_cases, total_deaths, new_cases,new_deaths,total_tests,new_tests from cdea;
SELECT * FROM covid.cdea;

-- Total entries of countries

select distinct location,count(*) 
from cdea
group by location ;

-- total countries
-- Data of total 219 loations

select count(distinct location)
from cdea
where continent <> "";

-- Total cases/deaths according to continents and their countries

-- Countries with most cases were USA, India, Brazil, France, Turkey, Russia
-- Countries with most deaths are USA, Brazil, Mexico, India, UK

SELECT location, continent, MAX(total_cases),max(total_deaths)
FROM cdea
WHERE continent <> ""
GROUP BY location , continent
ORDER BY 3 desc;

-- Continent with most cases was Europe

select location,population,max(total_deaths)
from cdea
where continent = ""
group by location,population
order by 3 desc;

-- Death ratio per cases (Likeliness of dying if you get covid)
-- Countries with highest death per cases ratio are Sudan, Guyana, Iran, Gambia

-- Rolling ratio

select location,continent, dates,total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_ratio
from cdea
where continent <> ""
order by 1,3;  #location,dates; #continent,location;

-- Max ratio 

select location,max(total_deaths), max((total_deaths/total_cases)*100) as Death_ratio
from cdea
where continent <> ""
group by location
order by 3  ; #location,dates,continent;

-- Covid cases per population (Likeliness of getting infected)
-- Countries with highest infection ratio are Andorra, Montenegro, Czechia, Luxembourg, Bahrain, Serbia, USA

-- Rolling ratio

select location, continent, dates, total_cases, total_deaths, population, (total_cases/population)*100 as Infection_ratio
from cdea
where continent <> ""
order by 1,3 ;  #location,dates; #continent;

-- Max ratio

select location,population,max(total_cases), max((total_cases/population)*100) as Infection_ratio
from cdea
where continent <> ""
group by location,population 
order by 4 desc; #location,dates #continent,location;


-- GLOBAL NUMBERS (using CTEs)

with death_count_table as
(select location,continent, max(total_cases), max(total_deaths) as death_count
from cdea
where continent <> ''
group by location,continent
)
select continent,sum(death_count)
from death_count_table
group by continent
order by 2 desc;
