
# COVID-19 Global Impact Analysis

## Overview

This project investigates the global impact of COVID-19 using datasets containing country-level statistics on deaths and vaccinations. The analysis explores relationships between wealth indicators (like GDP and HDI), government policies (stringency index), and COVID outcomes such as total deaths, death rates, and vaccination coverage.

SQL is the primary tool used for data cleaning, transformation, and exploratory data analysis (EDA). The goal is to uncover how different factors influenced the spread and fatality of the virus worldwide.

---

## Dataset Information

**Files Used:**

- `CovidDeaths.xlsx`: Contains daily COVID-19 statistics (cases, deaths, population, etc.) by location.
- `CovidVaccinations.xlsx`: Records daily vaccination progress by location.Also includes metrics like GDP, HDI, Extreme poverty, etc.
- SQL Scripts:
  - `CovidAnalysis.sql`
  - `OverTimeAnalysis.sql`
  - `CovidEDA.sql`

---

## Data Cleaning and Preparation

**SQL File: `CovidAnalysis.sql`**
**SQL File: `CovidEDA.sql`**

### 1. Inspecting and Understanding the Dataset

Checked data structure and key columns:

```sql
SELECT * FROM CovidDeaths WHERE continent IS NOT NULL;
```

Filtered out irrelevant records (like aggregates at world or continent level) by ensuring `continent IS NOT NULL`.

---

### 2. Total Cases vs Total Deaths

Analyzed fatality rate:

```sql
SELECT location, date, total_cases, total_deaths,
       (total_deaths / total_cases) * 100 AS death_rate_percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;
```

---

### 3. Total Cases vs Population

Calculated infection percentage:

```sql
SELECT location, date, population, total_cases,
       (total_cases / population) * 100 AS infection_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;
```

---

### 4. Countries with Highest Infection Rate

Identified most affected countries:

```sql
SELECT location, population, MAX(total_cases) AS highest_infection_count,
       MAX((total_cases / population)) * 100 AS highest_infection_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY highest_infection_rate DESC;
```

---

### 5. Countries with Highest Death Count

```sql
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;
```

---

### 6. Global Numbers Overview

Total deaths and infection rates at global view:

```sql
SELECT SUM(new_cases) AS total_cases,
       SUM(CAST(new_deaths AS INT)) AS total_deaths,
       (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS global_death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL;
```

---

## Vaccination Data Analysis

### 7. Joining Death and Vaccination Data

```sql
SELECT *
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
```

---

### 8. Rolling Total of Vaccinations

Used window functions to track progress:

```sql
SELECT dea.continent, dea.location, dea.date, dea.population,
       vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.date)
       AS rolling_people_vaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
```

---

## Exploratory Analysis Over Time

**SQL File: `OverTimeAnalysis.sql`**

### 9. Vaccination Trends by Country

Examined how countries increased vaccination rates over time.

```sql
SELECT location, date, people_vaccinated, total_vaccinations
FROM CovidVaccinations
WHERE people_vaccinated IS NOT NULL
ORDER BY location, date;
```

---

### 10. Analyzing Government Stringency and HDI

Analyzed how government response and development index relate to COVID outcomes:

```sql
SELECT location, date, stringency_index, total_deaths
FROM CovidDeaths
WHERE stringency_index IS NOT NULL;
```

```sql
SELECT location, hdi, MAX(total_deaths) AS total_deaths
FROM CovidDeaths
WHERE hdi IS NOT NULL
GROUP BY location, hdi
ORDER BY total_deaths DESC;
```

---

## SQL Techniques and Functionalities Used

- **JOINs:** To merge death and vaccination data.
- **GROUP BY & ORDER BY:** For aggregation and ranking insights.
- **Window Functions:** Used `SUM() OVER()` for cumulative vaccination tracking.
- **Filtering:** Using `WHERE`, `IS NOT NULL` to clean data.
- **String & Type Conversion:** CAST, COALESCE for safe computation.
- **Subqueries:** To filter for max values or create intermediate results.
- **Created tables and views:** To save analysis results for further analysis and visualization


---

## Key Insights and Findings

- Countries with higher HDI or GDP didn't always experience lower death rates, indicating that other influential factors—such as higher levels of social interaction, population density, age demographics, and public health infrastructure—played a significant role in shaping COVID-19 outcomes.
- Stringency of government response had correlation with fatality and spread rates.
- High-income countries led vaccination efforts, but not all saw proportional declines in death rates.
- Rolling vaccination totals reveal acceleration patterns and public health strategy shifts.

---

## Conclusion

This project demonstrates how SQL can be used for powerful, real-world data analysis by uncovering global patterns in COVID-19 outcomes. Through data cleaning, transformation, and exploration of deaths and vaccinations, we found that high GDP or HDI did not guarantee lower death rates—highlighting the influence of other factors such as social interaction levels, healthcare infrastructure, and government responses. By combining advanced SQL techniques like window functions and joins, we tracked trends over time and drew meaningful insights into the effectiveness of public health strategies, emphasizing the importance of multidimensional analysis in understanding global crises.

---

## Files

- 📊 `CovidDeaths.xlsx`
- 💉 `CovidVaccinations.xlsx`
- 🧹 `CovidAnalysis.sql` - Cleaning and base analysis.
- 📈 `CovidEDA.sql` - Vaccination-focused queries and joins.
- 🕒 `OverTimeAnalysis.sql` - Time-based trend analysis.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---


## Author

**Movahed Abdolahi**

For inquiries, feedback, or collaboration: [Connect with me on LinkedIn](https://www.linkedin.com/in/movahed-abdolahi/)
