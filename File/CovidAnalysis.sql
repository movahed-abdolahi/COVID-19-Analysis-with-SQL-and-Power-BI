-- Updating null values

update Covid_Deaths
set total_cases = 0
where total_cases is null;

-- looking at two tables 

select *
into deaths
from Covid_Deaths
where date BETWEEN '2020-02-1' AND '2024-12-31'


select *
into vaccination
from Covid_Vaccination
where date BETWEEN '2020-02-1' AND '2024-12-31'



-- Joining two tables into a new covid_combined table to run calculations and aggregations

DROP TABLE covid_combined
SELECT 
	cd.code,
	cd.continent,
	cd.country,
	cd.date,
	cd.population,
	cd.total_cases,
	cd.new_cases,
	cd.total_deaths,
	cd.new_deaths,
	cv.stringency_index,
	cv.reproduction_rate,
	cv.total_vaccinations,
	cv.people_vaccinated,
	cv.people_fully_vaccinated,
	cv.total_boosters,
	cv.new_vaccinations,
	cv.gdp_per_capita,
	cv.extreme_poverty,
	cv.human_development_index,
	cv.hospital_beds_per_thousand,
	cv.median_age
INTO covid_combined
FROM deaths cd
JOIN	vaccination cv
	ON cd.country = cv.country AND cd.date = cv.date


-- looking at new combined table

select *
from covid_combined
order by 3,4

-- creating country level aggregations into a new table 

drop table country_summery
select 
	code,
	continent,
	country,
	MAX(population) AS population,
	MAX(total_cases) AS total_cases,
	MAX(total_deaths) AS  total_deaths,
    MAX(total_vaccinations) AS total_vaccinations,
    MAX(people_fully_vaccinated) AS people_fully_vaccinated,
    MAX(total_boosters) AS total_boosters,
    MAX(human_development_index) AS human_development_index,
    ROUND(MAX(gdp_per_capita),0) AS gdp_per_capita,
    ROUND(MAX(extreme_poverty),2) AS extreme_poverty,
    MAX(hospital_beds_per_thousand) AS hospital_beds_per_thousand,
    MAX(median_age) AS median_age,
    ROUND(AVG(cast(stringency_index as float)),2) AS avg_stringency,
	ROUND(MAX(CAST(stringency_index as float)), 2) AS max_stringency,

    ROUND(AVG(cast(reproduction_rate as float)),2) AS avg_reproduction,
    ROUND((MAX(cast(total_cases as float)) / MAX(population)) * 1000000,0) AS cases_per_million,
    ROUND((MAX(cast(total_deaths as float)) / MAX(population)) * 1000000,0) AS deaths_per_million,

	-- Calculating COVID fatality rate and percentage of population infected
	ROUND((MAX(CAST(total_deaths AS float))/MAX(cast(total_cases as float)))*100, 2) AS Fatality_rate,

	-- people who fully vaccinated
    ROUND((MAX(cast(people_fully_vaccinated as float)) / MAX(population)) * 100, 2) AS vaccination_rate
INTO covid_country
FROM covid_combined
WHERE continent IS NOT NULL AND human_development_index IS NOT NULL AND gdp_per_capita IS NOT NULL AND total_cases > 0
GROUP BY 	
	code,
	continent,
	country


-- looking at new country level aggregations table

select * 
from country_summery

-- country GDP per capita vs covid deaths

select 
	country,
	gdp_per_capita,
	deaths_per_million
from country_summery
order by gdp_per_capita;

-- Humane developement index vs covid cases

select
	country, 
	human_development_index, 
	cases_per_million
from country_summery
order by human_development_index desc;

-- stringency  vs deaths rate

select 
	country,
	avg_stringency,
	deaths_per_million
from country_summery
order by 2 desc;

-- Vaccination rate vs deaths rate

select 
	country,
	vaccination_rate,
	deaths_per_million
from country_summery
order by vaccination_rate desc;




