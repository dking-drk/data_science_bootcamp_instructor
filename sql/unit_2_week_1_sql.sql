--- Unit 2 Week 1 SQL Project Danny King 

--- 1. Which metro area in the country has the highest average household income in the US?

select metro_city, avg(median_hh_income) as avg_hh_income
from public.census_metro_data 
group by metro_city
order by 2 desc


select metro_city, avg(median_hh_income) 
from public.census_metro_data 
group by metro_city , median_hh_income 
having median_hh_income = max(median_hh_income) 

order by 2 desc


SELECT cust_city, cust_country, MAX(outstanding_amt) 
FROM customer 
GROUP BY cust_country, cust_city 
HAVING MAX(outstanding_amt)>10000

--- Answer: Bridgeport 

--- 2. What metro area has the zip code with the largest population?



