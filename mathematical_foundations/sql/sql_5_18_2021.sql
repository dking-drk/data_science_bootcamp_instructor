
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

select avg(median_hh_income) as sample_mean, stddev(median_hh_income) as stddev 
from (select median_hh_income as median_hh_income
from census_metro_data_exp
order by random()
limit 1000) base 

select 66922.748000000000 + ((1.96*33262.93584583)/sqrt(1000)) ---- 68984.4061231629

select 66922.748000000000 - ((1.96*33262.93584583)/sqrt(1000)) ---- 64861.08987683712



select avg(median_hh_income) as true_mean
from census_metro_data_exp 