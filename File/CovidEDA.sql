
-- Calculating death percentage of confirmed cases
-- Calculating Percent of population infected
SELECT 
	code,
	continent,
	country,
	date,
	new_cases,
	total_cases,
	new_deaths,
	total_deaths,
	ROUND((total_deaths/total_cases)*100, 2) as DeathPercentage,
	ROUND((total_cases/population)*100, 2) as PopulationPercentInfected,
	population
FROM Covid_Deaths
WHERE total_cases > 0 AND continent IS NOT NULL
ORDER BY 3,4


-- Contries highest infected and deaths

SELECT 
	code,
	continent,
	country,
	MAX(CAST(total_cases as int)) as total_infected,
	MAX(CAST(total_deaths as int)) AS total_deaths,
	population
FROM Covid_Deaths
WHERE total_cases > 0 and continent is not null
GROUP BY
	code,
	continent,
	country,
	population
ORDER BY Total_Deaths DESC



-- infected and deaths by continent

WITH continent_test AS
(
SELECT 
	code,
	continent,
	country,
	MAX(CAST(total_cases as int)) as total_infected,
	MAX(CAST(total_deaths as int)) AS total_deaths,
	population
FROM Covid_Deaths
WHERE total_cases > 0 and continent is not null
GROUP BY
	code,
	continent,
	country,
	population
)
SELECT 
	DISTINCT continent,
	SUM(total_deaths) over (partition by continent) as total_deaths_continent
FROM continent_test
ORDER BY 2 DESC


--Global numbers

WITH global_test AS
(
SELECT 
	country,
	max(total_cases) as total_case_country,
	max(total_deaths) as total_deaths_country
FROM Covid_Deaths
WHERE total_cases > 0 AND continent IS NOT NULL
GROUP BY country
)
SELECT 
	SUM(total_case_country) AS total_case_global,
	SUM(total_deaths_country) AS total_deaths_global,
	ROUND((SUM(total_deaths_country)/SUM(total_case_country)) *100, 2) as deaths_percentage 
FROM global_test




-- joining vaccinations with deaths

SELECT 
	v.code,
	v.continent,
	v.country,
	v.date,
	v.total_tests,
	v.new_tests,
	v.positive_rate,
	v.new_vaccinations,
	v.median_age,
	v.population_density,
	v.gdp_per_capita,
	d.population
FROM Covid_Vaccinations v
JOIN Covid_Deaths d
	ON v.country=d.country and v.date=d.date
WHERE v.continent IS NOT NULL AND d.population IS NOT NULL
ORDER BY v.country, v.date


-- calculating rolling total of vaccinations per country using Window functions

SELECT 
	v.code,
	v.continent,
	v.country,
	v.date,
	v.new_vaccinations,
	SUM(CAST(v.new_vaccinations as float)) OVER (PARTITION BY v.country ORDER BY v.country, v.date) as rolling_total_vaccinations,
	d.population
FROM Covid_Vaccinations v
JOIN Covid_Deaths d
	ON v.country=d.country and v.date=d.date
WHERE v.continent IS NOT NULL AND d.population IS NOT NULL
ORDER BY v.country, v.date

-- percentage of population vaccinated

WITH vaccine_test AS
(
SELECT 
	v.code,
	v.continent,
	v.country,
	v.date,
	v.new_vaccinations,
	v.total_vaccinations,
	SUM(CAST(v.new_vaccinations as float)) OVER (PARTITION BY v.country ORDER BY v.country, v.date) as rolling_total_vaccinations,
	d.population
FROM Covid_Vaccinations v
JOIN Covid_Deaths d
	ON v.country=d.country and v.date=d.date
WHERE v.continent IS NOT NULL AND d.population IS NOT NULL
--ORDER BY v.country, v.date
)

SELECT 
	code,
	continent,
	country,
	MAX(rolling_total_vaccinations) as total_vaccinated,
	population,
-- General number of vaccine dose that most people received is 3 based on reports so to have a general sense I am multiplying population by 3 (Not accurate but common sense)
	round(MAX(rolling_total_vaccinations)/(population*3), 4)*100 as percentage_vaccinated
FROM vaccine_test
WHERE rolling_total_vaccinations IS NOT NULL
GROUP BY 
	code,
	continent,
	country,
	population
ORDER BY 3


























