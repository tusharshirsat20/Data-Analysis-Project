SELECT * FROM covid.cdea;
USE covid;

SHOW VARIABLES LIKE "secure_file_priv";
SELECT @@GLOBAL.secure_file_priv;
SET GLOBAL secure_file_priv="";

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile=TRUE;

CREATE TABLE cvac (
iso_code VARCHAR(10),
continent VARCHAR(20),
location VARCHAR(35),
dates DATE,
new_tests INT,
total_tests INT,
positive_rate DOUBLE,
tests_per_case DOUBLE,
tests_units VARCHAR(20),
total_vaccinations INT,
people_vaccinated INT,
people_fully_vaccinated INT,
new_vaccinations INT,
stringency_index DOUBLE,
population BIGINT,
population_density DOUBLE,
median_age DOUBLE,
aged_65_older DOUBLE,
aged_70_older DOUBLE,
gdp_per_capita DOUBLE,
extreme_poverty DOUBLE,
cardiovasc_death_rate DOUBLE,
diabetes_prevalence DOUBLE,
female_smokers DOUBLE,
male_smokers DOUBLE,
handwashing_facilities DOUBLE,
life_expectancy DOUBLE,
human_development_index DOUBLE
)

SELECT * FROM cvac;
USE covid;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cdea.csv"
INTO TABLE cdea
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(iso_code,continent,location,@dates,new_tests,total_tests,total_cases,new_cases,total_deaths,new_deaths,reproduction_rate,icu_patients,hosp_patients,weekly_icu_admissions,weekly_hosp_admissions,people_vaccinated,people_fully_vaccinated,new_vaccinations,stringency_index,population,population_density,median_age,aged_65_older,aged_70_older,gdp_per_capita,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,life_expectancy,human_development_index)
SET dates = STR_TO_DATE(@dates,'%m/%d/%Y');


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cvac.csv"
INTO TABLE cvac
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(iso_code,continent,location,@dates,new_tests,total_tests,positive_rate,tests_per_case,tests_units,total_vaccinations,people_vaccinated,people_fully_vaccinated,new_vaccinations,stringency_index,population,population_density,median_age,aged_65_older,aged_70_older,gdp_per_capita,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,life_expectancy,human_development_index)
SET dates = STR_TO_DATE(@dates,'%m/%d/%Y');


SELECT * FROM levels;
