select Location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths
order by 1,2

--Total Case vs Total Deaths in India
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
from [Portfolio Project]..CovidDeaths
where location like '%india%'
order by 1,2

--Total Population vs Total Deaths
select Location, date, population, total_cases, (total_cases/population)*100 as infection_percentage
from [Portfolio Project]..CovidDeaths
where location like '%india%'
order by 1,2

--Country with highest infection rate
select Location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as infection_percentage
from [Portfolio Project]..CovidDeaths
group by location,population
--where location like '%india%'
order by infection_percentage desc

-- Country with highest death count
select location, max(cast(total_deaths as int)) as total_death_count
from [Portfolio Project]..CovidDeaths
where continent is not null
group by location
order by total_death_count desc

-- Continent with highest death count
select location, max(cast(total_deaths as int)) as total_death_count
from [Portfolio Project]..CovidDeaths
where continent is null
group by location
order by total_death_count desc



-- Global numbers
--Total Case vs Total Deaths
select date, sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_percentage
from [Portfolio Project]..CovidDeaths
where continent is not null
--where location like '%india%'
group by date
order by 1,2

--Join both tables
select *
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.date=vac.date
and dea.location=vac.location


--Total population vs Total cases
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.date=vac.date
and dea.location=vac.location
where dea.continent is not null
order by 2,3

--Using temp table
with popvsvac (continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.date=vac.date
and dea.location=vac.location
where dea.continent is not null
--order by 2,3
)
select*, (Rollingpeoplevaccinated/population)*100
from popvsvac

--Create view for visualisation later
create view percentpopulatedvaccine as
select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
on dea.date=vac.date
and dea.location=vac.location
where dea.continent is not null
--order by 2,3



select*
from percentpopulatedvaccine