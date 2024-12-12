--Шаг 1. Анализ конверсии

with step1 as (
			select to_char(date_trunc('month', date), 'YYYY-MM') as год_месяц, 
					COUNT(distinct id_transaction) as opened
			from df_action
				group by 1),
	step2 as (
			select to_char(date_trunc('month', date), 'YYYY-MM') as год_месяц, 
					COUNT(distinct id_transaction) as added
			from df_action
			where action != 'opened'
				group by 1),
	step3 as (
			select to_char(date_trunc('month', date), 'YYYY-MM') as год_месяц, 
					COUNT(distinct id_transaction) as purchased
			from df_action
			where action = 'purchased'
				group by 1)
select step3.год_месяц,
			opened,
			added,
			purchased,
			round(cast(added/opened::double precision*100 as decimal),2) as "конверсия_корзина_%",
			round(cast(purchased/added::double precision*100 as decimal),2) as "конверсия_покупка_%"
from step1 join step2 using(год_месяц)
	join step3 using(год_месяц)
	
	
	
	


