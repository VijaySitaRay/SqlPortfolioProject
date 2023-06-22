select * 
from portfolioproject..coviddeath
where continent is not null
order by 3,4


select * 
from portfolioproject..covidvaccination
order by 3,4

select location, date,total_cases,new_cases,total_deaths,population
from portfolioproject..CovidDeath
order by 1,2

--looking at total case vs total deaths

select location,total_deaths,total_cases,date,
(convert (decimal, total_deaths) )/ (convert (decimal,total_cases))*100 as deathpercentage
from portfolioproject..coviddeath
where location like 'india' and continent is not null
order by 1,2



--looking total cases vs population
-- what percentafe of  population got covid

select location,  date, population,  total_cases,  
(convert (decimal, total_cases) )/ (convert (decimal,population))*100 as deathpercentage
from portfolioproject..coviddeath
where continent is not null
--where location like 'india'
order by location asc


--looking at country with highest infection rate compared tp population 

select location, population,  max(total_cases) as highest_infection_count,  
max((convert (decimal, total_cases) )/ (convert (decimal,population)))*100 as percentpopulationinfected
from portfolioproject..coviddeath
where continent is not null
--where location like 'india'
group by  population, location
order by percentpopulationinfected desc

--showing coountries with highest death count per population

select location,  max(convert(int,total_deaths)) as totaldeathscount
from portfolioproject..coviddeath
where continent is not null
--where location like 'india'
group by  location
order by totaldeathscount desc


--Lets break things down by continent


select continent,  max(convert(int,total_deaths)) as totaldeathscount
from portfolioproject..coviddeath
where continent is not null
--where location like 'india'
group by  continent
order by totaldeathscount desc


select location,  max(convert(int,total_deaths)) as totaldeathscount
from portfolioproject..coviddeath
where continent is null 
--where location like 'india'
group by  location
order by totaldeathscount desc


--showing the continent with highest death count


select continent,population, max((convert(int,total_cases))/(convert(int, total_deaths)))*100 as totaldeathscount
from portfolioproject..coviddeath
--where continent is not null
--where location like 'india'
group by  continent,population
order by totaldeathscount desc


--breaking global numbers

select date,sum(new_cases),sum(convert(int,new_deaths)), sum(convert(decimal,new_deaths))/sum(convert(decimal,new_cases))*100 as Deathpercentage
--total_cases ,total_deaths, (convert(int,total_deaths)/(convert(int,total_cases)))*100 as deathpercentage
from portfolioproject ..CovidDeath
where continent is not null
group by date,new_cases
order by 1,2


select new_cases from portfolioproject..CovidDeath



select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum (cast(new_deaths as int))/ sum(new_cases)*100 as DeathPercentage
from portfolioproject..CovidDeath
--where continent is not null
--group by date
order by 1,2


--total population vs vaccination 
select death.continent, death.location, death.date,death.population,
sum(convert(int,death.new_deaths)) over (partition by death.location order by death.location) as total_new_deaths
--, (total_new_deaths/population)*100
from portfolioproject..CovidDeath as death
join portfolioproject..CovidVaccination as vac
         on death.location=vac.location 
         and death.date = vac.date
where death.continent is not null and death.location = 'india'
order by 2,3


--USE CTE 

with vijay (continent,new_deaths,location,date,population,total_new_deaths)
as
(
select death.continent, death.location, death.date,death.population,
sum(convert(int,death.new_deaths)) over (partition by death.location order by death.location) as total_new_deaths
, (new_deaths/population)*100
from portfolioproject..CovidDeath as death
join portfolioproject..CovidVaccination as vac
         on death.location=vac.location 
         and death.date = vac.date
where death.continent is not null --and death.location = 'india'
--order by location desc
)
select *
from  vijay




--Use of temp table
drop table if exists #percentpopulationvacinated
create table #percentpopulationvacinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccination numeric,
tota_new_deaths numeric
)
insert into #percentpopulationvacinated
select death.continent, death.location, death.date,death.population,
sum(convert(int,death.new_deaths)) over (partition by death.location order by death.location) as total_new_deaths
, (new_deaths/population)*100
from portfolioproject..CovidDeath as death
join portfolioproject..CovidVaccination as vac
         on death.location=vac.location 
         and death.date = vac.date
where death.continent is not null --and death.location = 'india'
--order by location desc
select *
from  #percentpopulationvacinated


--creating view to store data for later visualization

create view percentpopulationvacinated as
select death.continent, death.location, death.date,death.population,
sum(convert(int,death.new_deaths)) over (partition by death.location order by death.location) as total_new_deaths
 --(new_deaths/population)*100
from portfolioproject..CovidDeath as death
join portfolioproject..CovidVaccination as vac
         on death.location=vac.location 
         and death.date = vac.date
where death.continent is not null
--and death.location = 'india'
--order by location desc


select *
from percentpopulationvacinated

