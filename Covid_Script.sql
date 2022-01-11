describe covid_deaths;

select * 
from covid_deaths
where continent = ""; 

-- test query

select date,sum(new_cases)
from covid_deaths
group by date;

-- Finding death % by location

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage 
from covid_deaths
where location like '%states%'
order by death_percentage desc;

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage 
from covid_deaths
where location = "India"
order by death_percentage desc;

-- Finding affected % by location

select location,date,total_cases,population,(total_cases/population)*100 as percentage_affected
from covid_deaths
where location = "India"
order by 1,2 desc;

-- Finding highest no. of cases by location

select location,date,max(total_cases) as highest_cases,population,max((total_cases/population)*100) as max_percentage_affected
from covid_deaths
group by location , population
order by max_percentage_affected desc;

-- Finding most deaths reocrded by location

select location,max(cast(total_deaths as unsigned int)) as highest_deaths_recorded,population 
from covid_deaths
where continent != ""
group by location 
order by highest_deaths_recorded desc;

-- Finding death % over the world by dates

select date,sum(new_cases) as total_new_cases,sum(new_deaths) as total_new_deaths , (sum(new_deaths))/(sum(new_cases))*100 as death_percent_by_date 
from covid_deaths
where continent != "" 
group by date
order by 1,2;

select date,new_vaccinations
from covid_vaccination
where new_vaccinations <> 0;

select *
from covid_deaths as deaths
join covid_vaccination  as vacc
on deaths.location = vacc.location
and deaths.date = vacc.date
where deaths.location = "India";

select deaths.location,deaths.date,deaths.population,vacc.new_vaccinations
from covid_deaths as deaths
join covid_vaccination as vacc
on deaths.location = vacc.location
and deaths.date = vacc.date
where deaths.continent != "" 
order by 1,2;

select date,new_vaccinations,total_vaccinations
from covid_vaccination
where location = "India" and new_vaccinations<>0;

create temporary table percent_vaccinated_usage
select death.population,vacc.people_fully_vaccinated,death.date,
(vacc.people_fully_vaccinated/death.population)*100 as percentage_of_fully_vaccination
from covid_deaths as death
join covid_vaccination as vacc
on death.location = vacc.location
and death.date = vacc.date
where death.location = "India" and vacc.people_fully_vaccinated<>0;

drop table if exists percent_vaccinated_usage_2;
create temporary table percent_vaccinated_usage_2
(continent varchar(25),
location varchar(25),
date varchar(30),
population int,
people_fully_vaccinated int,
percentage_of_fully_vaccination float8);

insert into percent_vaccinated_usage_2
select death.continent,death.location,death.date,death.population,vacc.people_fully_vaccinated,
(vacc.people_fully_vaccinated/death.population)*100 as percentage_of_fully_vaccination
from covid_deaths as death
join covid_vaccination as vacc
on death.location = vacc.location
and death.date = vacc.date
where death.location = "India" and vacc.people_fully_vaccinated<>0;

select *
from percent_vaccinated_usage_2
order by percentage_of_fully_vaccination desc
limit 6;


select date,percentage_of_fully_vaccination
from percent_vaccinated_usage
where date like '%2021%'
order by percentage_of_fully_vaccination desc;
drop view if exists death_count_world_wide;
create view death_count_world_wide as
select location,max(total_deaths) as deaths
from covid_deaths
where continent != ""
group by location;
select * from death_count_world_wide;