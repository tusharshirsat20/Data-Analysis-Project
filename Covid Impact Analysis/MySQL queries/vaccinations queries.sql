-- DATA we will be working with location,continent,population, dates, total_vaccinations, new_vaccinations, total_cases, total_deaths, new_cases,new_deaths

select location,continent,population, dates, total_vaccinations, new_vaccinations, total_tests,new_tests  from cvac ;
SELECT * FROM covid.cvac;
#where new_vaccinations>0;

use covid;

-- Vaccination rolling ratio

select cvac.dates,cvac.location,/*cvac.continent, */cdea.population, cvac.total_vaccinations, (cvac.total_vaccinations/cdea.population)*100 as Vaccination_ratio
from cvac
join cdea
on cvac.dates=cdea.dates and cvac.location=cdea.location
where cvac.continent <> ''
order by cvac.location,5 ;

-- MAX total vaccinations 
-- Most vaccination occured in China, USA, India, UK, Brazil

select location,continent, max(total_vaccinations)
from cvac
where continent <> ''
group by location,continent
order by 4 desc; #continent


-- Rolling sum of new vaccinations by countries (using partition by)

select cvac.dates,cvac.location,cvac.continent,cdea.population,
sum(cvac.new_vaccinations) over (partition by cvac.location order by cvac.location,cvac.dates) as Rolling_vaccination_sum
from cvac
join cdea
on cvac.dates=cdea.dates and cvac.location=cdea.location
where cvac.continent <> '' ;#and cvac.new_vaccinations>0
#order by cvac.location,cvac.dates;
#order by cvac.continent,4 ;

-- Above quesry using CTEs

with rolling_vacs as
(select cvac.dates,cvac.location,cvac.continent,cdea.population,
sum(cvac.new_vaccinations) over (partition by cvac.location order by cvac.location,cvac.dates) as Rolling_vaccination_sum
from cvac
join cdea
on cvac.dates=cdea.dates and cvac.location=cdea.location
where cvac.continent <> '' )
select *,(Rolling_vaccination_sum/population)*100 as vaccinations_ratio from rolling_vacs;


