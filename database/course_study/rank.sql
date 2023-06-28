-- Rank Demo

use market_star_schema;

-- rank of sales
SELECT customer_name, 
	ord_id,
	ROUND(sales) as Rounded_sales,
	RANK() OVER(order by sales DESC) AS Sales_rank

FROM market_fact_full as m
INNER JOIN
cust_dimen as c
using(cust_id)
WHERE customer_name = 'RICK WILSON';


-- rank of  top 10 sales orders from a customer
WITH rank_info AS (
SELECT customer_name, 
	ord_id,
	ROUND(sales) as Rounded_sales,
	RANK() OVER(order by sales DESC) AS Sales_rank

FROM market_fact_full as m
INNER JOIN
cust_dimen as c
using(cust_id)
WHERE customer_name = 'RICK WILSON'
)
SELECT * FROM rank_info
WHERE sales_rank <= 10;

-- for custome Rick Wilson all order , discount apply to order
-- dense rank

SELECT ord_id,
		discount,
        customer_name,
        RANK() OVER(order by discount DESC) AS disc_rank,
        DENSE_RANK() OVER(order by discount DESC) AS disc_dense_rank
        
FROM market_fact_full  as m
INNER JOIN  cust_dimen as c
using(cust_id)
WHERE customer_name = 'RICK WILSON';


-- rank the Number of orders each customer has placed

select customer_name,
	count(Distinct ord_id) as ord_count,
    Rank() over (order by count(distinct ord_id) desc) as order_rank,
    DENSE_RANK() over (order by count(distinct ord_id) desc) as order_dense_rank,
    ROW_NUMBER() over (order by count(distinct ord_id) desc) as order_row_rank
    
    from market_fact_full as m
    inner join
    cust_dimen as c
    on m.cust_id = c.cust_id
    group by customer_name;
    
    
    -- partitioning example
-- ranking each shipmode's shipment each month, partition by shipmode
select ship_mode,
    month(ship_date) as shipping_month,
    Count(*) as shipments
    
from shipping_dimen
group by ship_mode,
	month(ship_date) ;
    

-- with rank_cte as (
with shipping_summary as(    
select ship_mode,
    month(ship_date) as shipping_month,
    Count(*) as shipments
    
from shipping_dimen
group by ship_mode,
	month(ship_date) 
    )
select *,
	rank() over ( partition by ship_mode order by shipments DESC) AS shipping_rank
from shipping_summary;
-- )
-- select * from rank_cte where shipping_rank <= 3;
		

-- rank the Number of orders each customer has placed using Window to eliminate order by multiple time

select customer_name,
	ord_id,
    discount,
    Rank() over w as order_rank,
    DENSE_RANK() over w as order_dense_rank,
    ROW_NUMBER() over w as order_row_rank
    
    from market_fact_full as m
    inner join
    cust_dimen as c
    on m.cust_id = c.cust_id
    Window w as(partition by customer_name order by  discount desc);
    
    
    
-- lead and lag
with next_order_date AS
(
select *, lead(order_date, 1) over (order by order_date, ord_id DESC)
AS next_order_date
from orders_dimen
)
select *, datediff(next_order_date, order_date) as days_diff
from next_order_date;
    