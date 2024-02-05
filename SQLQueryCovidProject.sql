SELECT *
FROM Coviddeaths
ORDER BY 3,4

SELECT *
FROM Covidvaccinations
ORDER BY 3,4

--Select Data that we are going to be using

SELECT location,date,total_cases,new_cases, total_deaths, population
FROM Coviddeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths


ALTER TABLE Coviddeaths
ALTER COLUMN total_cases float

--Shows likelyhood of dying from covid in your country

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM dbo.Coviddeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at total cases vs population
--Show what percentage of population has gotten covid

SELECT location,date,population,total_cases,  (total_cases/population) * 100 AS perc_covid
FROM dbo.Coviddeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population

SELECT location,population,MAX(total_cases) Highest_infection_count, MAX((total_cases/population) * 100) AS PercentPopulationInfected
FROM dbo.Coviddeaths
--WHERE location LIKE '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Showing the countries with the highest death count per population

SELECT location,MAX(total_deaths) total_death_count
FROM Coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

--Lets break things down by continent

SELECT Continent,MAX(total_deaths) total_death_count
FROM Coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

--Showing the Continents with the highest death count

SELECT Continent,MAX(total_deaths) total_death_count
FROM Coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC

--Global numbers

SELECT date,SUM(new_cases), SUM(new_deaths), (SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentage--total_cases,total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM dbo.Coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--Looking at total population vs total vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CAST(vac.new_vaccinations AS int)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date)
FROM Coviddeaths dea
JOIN Covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3

--Creating View to store data for later visualizations

CREATE VIEW ContinentDeathCount AS
SELECT Continent,MAX(total_deaths) total_death_count
FROM Coviddeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
--ORDER BY total_death_count DESC
