-- Rank Demo

use market_star_schema;

SELECT customer_name, 
	ord_id,
	ROUND(sales) as Rounded_sales


FROM market_fact_full as m
INNER JOIN
cust_dimen as c
using(cust_id)
WHERE customer_name = 'RICK WILSON';