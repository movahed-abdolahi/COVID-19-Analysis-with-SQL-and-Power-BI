--Over time analysis
-- from 2020-02-01 to 2024-12-31


select 
	*
from covid_combined
order by 3,4

select 
	code,
	continent,
	country,
	date,
	population,
	total_cases,
	new_cases,
	total_deaths,
	new_deaths,
	stringency_index,
	reproduction_rate,
	total_vaccinations,
	people_fully_vaccinated,
	total_boosters,
	new_vaccinations,
	gdp_per_capita,
	extreme_poverty,
	human_development_index,
	hospital_beds_per_thousand,
	median_age
into covid_datetime
from covid_combined
where continent is not null and gdp_per_capita is not null and hospital_beds_per_thousand is not null and extreme_poverty is not null
order by 3,4









