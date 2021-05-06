--- 1. Which metro area in the country has the highest average household income in the US?

select metro_city, avg(median_hh_income) as avg_cost
from public.census_metro_data cmd 
group by 1
order by 2 desc

--- Answer: Bridgeport

--- 2. What metro area has the zip code with the largest population? 

select metro_city, max(population) as max_pop 
from public.census_metro_data cmd 
group by 1
order by 2 desc 

--- Answer: Houston 

--- 3. What state has the most metro areas?

select state, count(distinct metro_city) as total_metros 
from public.census_metro_data cmd 
group by 1
order by 2 desc 

--- Answer: California 

--- 4. Which metro area has the largest proportion of people aged 70-79?

select metro_city, sum(population_age_70_74+population_age_75_79)/sum(population)::numeric as proportion_70_to_79
from public.census_metro_data cmd 
group by 1
order by 2 desc 

--- Answer: Sarasota, FL


