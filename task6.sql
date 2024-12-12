select user_id,
	   product,
	   amount,
	   price,
	   expenses,
	   ((price - expenses) * amount) as profit,
	   df_action.date,
	   to_char(date_trunc('month', df_action.date), 'YYYY-MM') as year_month,
	   country,
	   device,
	   source
from df_action join df_user_our using(user_id)
	 join df_transaction using(id_transaction)
order by df_action.date,
		 country,
		 product,
		 device,
		 source
