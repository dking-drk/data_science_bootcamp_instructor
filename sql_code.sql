 --- is a comment 

select *
from public.search_ad_data 
limit 10

select *
from public.search_ad_platforms sap 
limit 10

---- this is an answer 


select zip
from public.census_metro_data
where zip >= 2000 
and zip <= 3000
