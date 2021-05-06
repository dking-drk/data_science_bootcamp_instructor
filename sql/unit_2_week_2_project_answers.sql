---- 1. Which campaign typically has the highest cost each year?

select year, campaign, avg_cost
from (select year,
	campaign, 
	avg_cost,
	rank () over ( 
		partition by year
		order by avg_cost desc
	) as campaign_cost_rank 
	from (select date_part('year',date) as year, sac.campaign, avg(cost) as avg_cost
		from public.search_ad_data sad
		inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id
		inner join public.search_ad_platforms sap on sad.platform_id=sap.platform_id
		group by 1,2) base) final_query 
where campaign_cost_rank = 1
order by 1,2

---- 2. Which campaign typically has the lowest cost per conversion each year.

select year, campaign, cost_per_conversion
from (select year, 
	campaign, 
	cost_per_conversion,
	rank () over ( 
		partition by year
		order by cost_per_conversion
	) as campaign_cpc_rank 
	from (select date_part('year',date) as year, sac.campaign, sum(sad.cost)/sum(sad.conversions) as cost_per_conversion
		from public.search_ad_data sad
		inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id
		inner join public.search_ad_platforms sap on sad.platform_id=sap.platform_id
		group by 1,2) base) final_query 
where campaign_cpc_rank = 1
order by 1,2

---- 3. What is the year over year trend in campaign costs?

select date_part('year',date) as year, sac.campaign, avg(cost) as avg_cost
		from public.search_ad_data sad
		inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id
		inner join public.search_ad_platforms sap on sad.platform_id=sap.platform_id
		group by 1,2

---- 4. What is the year over year trend in CPC?
		
select date_part('year',date) as year, sac.campaign, sum(sad.cost)/sum(sad.conversions) as cost_per_conversion
		from public.search_ad_data sad
		inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id
		inner join public.search_ad_platforms sap on sad.platform_id=sap.platform_id
		group by 1,2
		
---- Create a view extra credit
		
CREATE OR REPLACE VIEW public.vw_cpc_danielk as

select year, campaign, cost_per_conversion
from (select year, 
	campaign, 
	cost_per_conversion,
	rank () over ( 
		partition by year
		order by cost_per_conversion
	) as campaign_cpc_rank 
	from (select date_part('year',date) as year, sac.campaign, sum(sad.cost)/sum(sad.conversions) as cost_per_conversion
		from public.search_ad_data sad
		inner join public.search_ad_campaigns sac on sad.campaign_id=sac.campaign_id
		inner join public.search_ad_platforms sap on sad.platform_id=sap.platform_id
		group by 1,2) base) final_query 
where campaign_cpc_rank = 1
order by 1,2




















