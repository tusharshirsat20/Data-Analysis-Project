-- Visualization views
use covid;

-- DATA TO SHOW TIMELINE CASES/ DEATHS 

SELECT cd.location, cd.continent, cd.dates, total_cases,new_cases, total_deaths ,new_deaths, cv.total_vaccinations
FROM cdea cd
join cvac cv
on cd.location=cv.location and cd.dates=cv.dates
WHERE cd.continent <> ""
ORDER BY 2,1,3;

-- DATA TO PLOT ON MAP (MAX Cases/ Deaths)   -- FOR KPIs

with deavac as
(
SELECT cd.location, cd.continent,cd.population, MAX(total_cases)as Total_cases,max(total_deaths) as Total_deaths, MAX(cv.total_vaccinations) as Total_vaccinations
FROM cdea cd
join cvac cv
on cd.location=cv.location and cd.dates=cv.dates
-- WHERE cd.continent <> ""
GROUP BY cd.location , cd.continent, cd.population
ORDER BY 3 desc
)
select *,
(Total_cases/population)*100 as Infection_ratio,
(Total_deaths/Total_cases)*100 as Death_ratio,
(Total_vaccinations/population)*100 as Vaccination_ratio
from deavac;


-- GLOBAL NUMBERS (FOR KPIs is needed)

with death_count_table as
(select cd.location, cd.continent, max(total_cases)as cases_count, max(total_deaths) as death_count, max(cv.total_vaccinations) as vaccinations_count
from cdea cd
join cvac cv
on cd.location=cv.location and cd.dates=cv.dates
where cd.continent <> ''
group by cd.location,cd.continent
)
select continent,sum(death_count), sum(cases_count), sum(vaccinations_count)
from death_count_table
group by continent
order by 2 desc;


