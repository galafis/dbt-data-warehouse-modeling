-- Assert that all revenue values are positive
-- This test will fail if any orders have negative revenue

select
    order_id,
    sales_amount,
    net_sales
from {{ ref('fct_orders') }}
where sales_amount < 0 
   or net_sales < 0
