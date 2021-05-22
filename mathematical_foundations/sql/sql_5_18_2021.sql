
--- Sample of 30

select avg(median_hh_income) as sample_mean, stddev(median_hh_income) as stddev 
from (select median_hh_income as median_hh_income
from census_metro_data_exp
order by random()
limit 30) base 


select 69060.666666666667 + ((1.96*42511.89180431)/sqrt(30)) ---- 84273.3517742472

select 69060.666666666667 - ((1.96*42511.89180431)/sqrt(30)) ---- 53847.98155908614

--- Sample of 100

select avg(median_hh_income) as sample_mean, stddev(median_hh_income) as stddev 
from (select median_hh_income as median_hh_income
from census_metro_data_exp
order by random()
limit 100) base 

select 69186.080000000000 + ((1.96*32219.92234900)/sqrt(100)) ---- 75501.184780404

select 69186.080000000000 - ((1.96*32219.92234900)/sqrt(100)) ---- 62870.975219596

--- Sample of 1000

select count(*) 
from census_metro_data_exp

select avg(median_hh_income) as sample_mean, stddev(median_hh_income) as stddev 
from (select median_hh_income as median_hh_income
from census_metro_data_exp
order by random()
limit 1000) base 

select 66489.342000000000 + ((1.96*35312.87587183)/sqrt(1000)) ---- 68678.05672232143

select 66489.342000000000 - ((1.96*35312.87587183)/sqrt(1000)) ---- 64300.62727767858

--- 64300.62727767858 -> 68678.05672232143 

---- Actual mean

select avg(median_hh_income) as true_mean
from census_metro_data_exp 

---- Download census_metro_data_exp

select zip, median_hh_income 
from public.census_metro_data_exp
order by random()
limit 1000

---- Project 5 start

select *, 
case 
	 when percent_under_18 > .1600 and percent_70_to_80 < .055 then 'high_under_18'
	 when percent_under_18 < .1600 and percent_70_to_80 > .055 then 'high_70_80' 
	 else 'other' 
end as population_bucket
from (select zip, 
(population_age_0_5 + population_age_10_14 + population_age_15_17)::numeric/population::numeric as percent_under_18, 
(population_age_70_74 + population_age_75_79)::numeric/population::numeric as percent_70_to_80,
median_hh_income
from census_metro_data_exp
where population > 0) base
where (percent_under_18 > .1600 and percent_70_to_80 < .055) or
(percent_under_18 < .1600 and percent_70_to_80 > .055)

---- Get proportions from search_ad_data 

select campaign, sum(conversions) as conversions, sum(clicks) as clicks
from public.search_ad_data sad 
inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id
where campaign in ('dirty_clothes', 'desk_organization')
group by 1


