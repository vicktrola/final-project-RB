with c_registered as (--считаем количество зарегистрировавшихся пользователей
				select channel, count(distinct user_id) as cnt_users
				from df_user_viewed
				where status = 'registered'
					group by channel)
select df_cost.channel, 
	   
from df_cost 
	join c_registered using(channel)