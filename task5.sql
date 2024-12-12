	with rev as (
	  			select 
					channel, 
					sum((price - expenses) * amount) as revenue
				from df_transaction 
					join df_action using(id_transaction)
						join df_user_viewed using(user_id)
				group by channel
				)
select df_cost.channel,
	   ROUND(100*revenue::double precision/cost) as "ROAS"
from rev left join df_cost using(channel)


