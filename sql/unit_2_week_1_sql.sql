--- Unit 2 Week 1 SQL Project Danny King 

--- Which metro area in the country has the highest average household income in the US?

select metro_city, avg(median_hh_income) as avg_hh_income
from public.census_metro_data 
group by metro_city
order by 2 desc

--- Bridgeport 



