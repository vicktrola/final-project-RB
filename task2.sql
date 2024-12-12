with c_add as (--считаем по юзеру количество брошенных корзин
				select 
					user_id, 
					count(action) as cnt_added,
					count(*) over () as all_added
				from df_action 
				where action = 'added'
					group by user_id
						order by user_id),
	  c_prch as (--считаем по юзеру количество купленных корзин
	  				select 
					user_id, 
					count(action) as cnt_purchased,
					count(*) over () as all_purchased
				from df_action 
				where action = 'purchased'
					group by user_id
						order by user_id), 
	  user_cat as (--распределяем юзеров по категориям, здесь же считаем CAR
	  				select 
					c_prch.user_id,
					case 
						when coalesce(cnt_added,0) - coalesce(cnt_purchased,0) > 1 then 'throwers'
						when coalesce(cnt_added,0) - coalesce(cnt_purchased,0) = 1 then 'buyers'
						when coalesce(cnt_added,0) - coalesce(cnt_purchased,0) = 0 then 'buyers'
						when coalesce(cnt_added,0) - coalesce(cnt_purchased,0) <= -1 then 'check_needed'
					end as category,
					cast(all_purchased::double precision/all_added*100 as decimal) as car
					from c_add full join c_prch using(user_id)),
		fin_cnt as (--отдельно выводим результаты, чтобы привести таблицу к нужному виду
					select (select count(*)
						from user_cat 
						where category = 'throwers') as throwers,
						(select count(*)
						from user_cat 
						where category = 'buyers') as buyers,
						(select count(*)
						from user_cat 
						where category = 'check_needed') as check_needed,
						car
					from user_cat
				limit 1)
select throwers, buyers,  check_needed, round(car,2) as "CAR"
from fin_cnt

	