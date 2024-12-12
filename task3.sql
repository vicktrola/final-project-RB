with c_registered as ( --считаем количество зарегистрировавшихся пользователей
						select channel, 
							   count(distinct user_id) as count_registered
						from df_user_viewed
						where status = 'registered'
							group by channel, status
						),
	c_viewed as ( --считаем количество просмотревших пользователей
						select channel, 
							   count(distinct user_id) as count_viewed
						from df_user_viewed
						where status = 'viewed'
							group by channel, status
						)
select c_viewed.channel, 
		round(cast(count_registered/count_viewed::double precision*100 as decimal),2) as "CTR"
from c_registered 
	join c_viewed using(channel)
						